import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:tulapay/services/supabase_client.dart';

/// Handles merchant self-onboarding writes: creating the merchant profile +
/// KYB submission, uploading the identity document, and recording the
/// settlement account. Everything here relies on the RLS insert policies in
/// 0001_phase0_identity_and_merchants.sql, which pin owner_user_id to the
/// caller and force new merchants to start at account_status=pending_kyb —
/// a merchant can never self-approve through this service.
class MerchantService {
  MerchantService._();
  static final MerchantService instance = MerchantService._();

  Future<String> createMerchantProfile({
    required String businessName,
    required String ownerName,
    required String ownerPhone,
    required String businessCategory,
    required String registrationNumber,
    required String taxId,
    String? addressStreet,
    String? addressCity,
    String? ownerEmail,
  }) async {
    final userId = supabase.auth.currentUser!.id;

    // Resume rather than duplicate: if a previous attempt got this far but
    // failed before the document upload below completed, `merchants`/
    // `kyb_submissions` already exist for this owner. Neither table grants
    // the client UPDATE (by design — see 0001/0007, direct edits are
    // withheld in favor of the staff-only RPCs), so there's nothing to
    // correct here even if the resubmitted form differs; just reuse the
    // existing row instead of inserting a second merchant for one owner.
    final existing = await supabase
        .from('merchants')
        .select('id')
        .eq('owner_user_id', userId)
        .maybeSingle();
    if (existing != null) {
      return existing['id'] as String;
    }

    final merchantRow = await supabase
        .from('merchants')
        .insert({
          'owner_user_id': userId,
          'business_name': businessName,
          'owner_name': ownerName,
          'owner_phone': ownerPhone,
          'owner_email': ownerEmail,
          'business_category': businessCategory,
          'address_street': addressStreet,
          'address_city': addressCity,
        })
        .select('id')
        .single();

    final merchantId = merchantRow['id'] as String;

    await supabase.from('kyb_submissions').insert({
      'merchant_id': merchantId,
      'registration_number': registrationNumber,
      'tax_id': taxId,
    });

    return merchantId;
  }

  Future<void> uploadIdentityDocument({
    required String merchantId,
    required String docType,
    required XFile file,
  }) async {
    final ext = file.path.contains('.') ? file.path.split('.').last : 'jpg';
    final storagePath =
        '$merchantId/${DateTime.now().millisecondsSinceEpoch}.$ext';

    await supabase.storage.from('kyb-documents').upload(storagePath, File(file.path));

    await supabase.from('kyb_documents').insert({
      'merchant_id': merchantId,
      'doc_type': docType,
      'storage_path': storagePath,
    });
  }

  Future<void> submitSettlementAccount({
    required String merchantId,
    required String provider,
    required String phoneNumber,
  }) async {
    final last4 = phoneNumber.length >= 4
        ? phoneNumber.substring(phoneNumber.length - 4)
        : phoneNumber;

    await supabase.from('merchant_settlement_accounts').insert({
      'merchant_id': merchantId,
      'provider': provider,
      'account_msisdn': phoneNumber,
      'account_last4': last4,
    });
  }
}
