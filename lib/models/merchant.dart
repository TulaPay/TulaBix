import 'package:flutter/material.dart';

/// The merchant's own row (`merchants`), read back via
/// `MerchantRepository.myMerchant()`. Only the fields the mobile app needs are
/// mapped. Shape follows the control panel's `lib/types/merchant.ts`.
class Merchant {
  final String id;
  final String businessName;
  final String ownerName;
  final String? ownerEmail;
  final String ownerPhone;
  final String kycStatus; // verified | pending | flagged
  final int kybTier; // 1 | 2
  final String accountStatus; // active | suspended | pending_kyb | rejected | closed
  final String revenueTier; // starter | growth | scale
  final String businessCategory;
  final String? addressStreet;
  final String? addressCity;
  final String addressCountry;
  final DateTime? memberSince;
  final String? linkedProvider;
  final String? linkedAccountLast4;
  final String? suspendedReason;
  final DateTime? suspendedAt;

  const Merchant({
    required this.id,
    required this.businessName,
    required this.ownerName,
    this.ownerEmail,
    required this.ownerPhone,
    required this.kycStatus,
    required this.kybTier,
    required this.accountStatus,
    required this.revenueTier,
    required this.businessCategory,
    this.addressStreet,
    this.addressCity,
    this.addressCountry = 'Cameroon',
    this.memberSince,
    this.linkedProvider,
    this.linkedAccountLast4,
    this.suspendedReason,
    this.suspendedAt,
  });

  factory Merchant.fromMap(Map<String, dynamic> m) => Merchant(
        id: m['id'] as String,
        businessName: (m['business_name'] ?? '') as String,
        ownerName: (m['owner_name'] ?? '') as String,
        ownerEmail: m['owner_email'] as String?,
        ownerPhone: (m['owner_phone'] ?? '') as String,
        kycStatus: (m['kyc_status'] ?? 'pending') as String,
        kybTier: (m['kyb_tier'] as num?)?.toInt() ?? 1,
        accountStatus: (m['account_status'] ?? 'pending_kyb') as String,
        revenueTier: (m['revenue_tier'] ?? 'starter') as String,
        businessCategory: (m['business_category'] ?? 'Other') as String,
        addressStreet: m['address_street'] as String?,
        addressCity: m['address_city'] as String?,
        addressCountry: (m['address_country'] ?? 'Cameroon') as String,
        memberSince: m['member_since'] == null
            ? null
            : DateTime.tryParse(m['member_since'].toString()),
        linkedProvider: m['linked_provider'] as String?,
        linkedAccountLast4: m['linked_account_last4'] as String?,
        suspendedReason: m['suspended_reason'] as String?,
        suspendedAt: m['suspended_at'] == null
            ? null
            : DateTime.tryParse(m['suspended_at'].toString()),
      );

  bool get isVerified => kycStatus == 'verified';
  bool get isTier1 => kybTier == 1;
  bool get isActive => accountStatus == 'active';
  bool get isBlocked => accountStatus == 'rejected' ||
      accountStatus == 'suspended' ||
      accountStatus == 'closed';

  String get addressLine {
    final parts = [addressStreet, addressCity, addressCountry]
        .where((p) => p != null && p.trim().isNotEmpty)
        .toList();
    return parts.isEmpty ? '—' : parts.join(', ');
  }
}

/// `merchant_preferences` — one row per merchant.
class MerchantPreferences {
  final String merchantId;
  final String theme; // light | dark | system
  final String language; // en | fr
  final Map<String, dynamic> posSettings;
  final bool notifEmail;
  final bool notifPush;
  final bool notifSms;

  const MerchantPreferences({
    required this.merchantId,
    this.theme = 'system',
    this.language = 'en',
    this.posSettings = const {},
    this.notifEmail = true,
    this.notifPush = true,
    this.notifSms = false,
  });

  factory MerchantPreferences.fromMap(Map<String, dynamic> m) =>
      MerchantPreferences(
        merchantId: m['merchant_id'] as String,
        theme: (m['theme'] ?? 'system') as String,
        language: (m['language'] ?? 'en') as String,
        posSettings: (m['pos_settings'] as Map?)?.cast<String, dynamic>() ?? {},
        notifEmail: (m['notif_email'] ?? true) as bool,
        notifPush: (m['notif_push'] ?? true) as bool,
        notifSms: (m['notif_sms'] ?? false) as bool,
      );

  ThemeMode get themeMode => switch (theme) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  Locale get locale => Locale(language);

  MerchantPreferences copyWith({
    String? theme,
    String? language,
    Map<String, dynamic>? posSettings,
    bool? notifEmail,
    bool? notifPush,
    bool? notifSms,
  }) =>
      MerchantPreferences(
        merchantId: merchantId,
        theme: theme ?? this.theme,
        language: language ?? this.language,
        posSettings: posSettings ?? this.posSettings,
        notifEmail: notifEmail ?? this.notifEmail,
        notifPush: notifPush ?? this.notifPush,
        notifSms: notifSms ?? this.notifSms,
      );
}

/// `merchant_setup_checklist` — one row per merchant, four booleans.
class SetupChecklist {
  final bool verifyProfile;
  final bool connectPayments;
  final bool enableQr;
  final bool loadProducts;

  const SetupChecklist({
    this.verifyProfile = false,
    this.connectPayments = false,
    this.enableQr = false,
    this.loadProducts = false,
  });

  factory SetupChecklist.fromMap(Map<String, dynamic> m) => SetupChecklist(
        verifyProfile: (m['verify_profile'] ?? false) as bool,
        connectPayments: (m['connect_payments'] ?? false) as bool,
        enableQr: (m['enable_qr'] ?? false) as bool,
        loadProducts: (m['load_products'] ?? false) as bool,
      );

  // loadProducts is deliberately excluded from the checklist UI/progress —
  // Products/Inventory was removed from the app entirely (no backend table
  // ever existed for it). The DB column stays for now (harmless, unused).
  int get doneCount =>
      [verifyProfile, connectPayments, enableQr].where((b) => b).length;
  int get total => 3;
  double get progress => doneCount / total;
}
