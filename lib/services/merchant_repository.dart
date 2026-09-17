import 'package:tulapay/models/commerce.dart';
import 'package:tulapay/models/crm_customer.dart';
import 'package:tulapay/models/engagement.dart';
import 'package:tulapay/models/ledger.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/services/supabase_client.dart';

/// Rolled-up 30-day figures for the Home + Business dashboards, computed
/// client-side from the transaction ledger (mirrors the control panel's
/// `MerchantBusinessSummary`).
class MerchantBusinessSummary {
  final num tpv30d; // completed payment volume
  final num revenue30d; // payments - refunds
  final int transactionCount30d;
  final num avgTicket;
  final num balance; // net of all completed inflows/outflows, all-time

  const MerchantBusinessSummary({
    required this.tpv30d,
    required this.revenue30d,
    required this.transactionCount30d,
    required this.avgTicket,
    required this.balance,
  });

  static const empty = MerchantBusinessSummary(
    tpv30d: 0,
    revenue30d: 0,
    transactionCount30d: 0,
    avgTicket: 0,
    balance: 0,
  );
}

/// Single entry point for every merchant-scoped read/write the app does after
/// onboarding. Backed by the tables/RPCs in migrations 0012–0016. Singleton,
/// matching `AuthService.instance` / `MerchantService.instance`.
class MerchantRepository {
  MerchantRepository._();
  static final MerchantRepository instance = MerchantRepository._();

  Merchant? _merchant;

  /// Resolve (and cache) the current user's merchant row. Every screen that
  /// needs `merchantId` goes through here. Throws [StateError] if the signed-in
  /// user has no merchant profile (shouldn't happen post-onboarding).
  Future<Merchant> myMerchant({bool refresh = false}) async {
    if (_merchant != null && !refresh) return _merchant!;
    final uid = supabase.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    final row = await supabase
        .from('merchants')
        .select()
        .eq('owner_user_id', uid)
        .maybeSingle();
    if (row == null) {
      throw StateError('No merchant profile for the current user');
    }
    return _merchant = Merchant.fromMap(row);
  }

  Future<String> requireMerchantId() async => (await myMerchant()).id;

  /// Clear cached state on sign-out.
  void clearCache() => _merchant = null;

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------
  Future<List<AppNotification>> notifications({int limit = 50}) async {
    final mid = await requireMerchantId();
    final rows = await supabase
        .from('merchant_notifications')
        .select()
        .eq('merchant_id', mid)
        .order('created_at', ascending: false)
        .limit(limit);
    return rows.map<AppNotification>((r) => AppNotification.fromMap(r)).toList();
  }

  Future<int> unreadNotificationCount() async {
    final mid = await requireMerchantId();
    final rows = await supabase
        .from('merchant_notifications')
        .select('id')
        .eq('merchant_id', mid)
        .eq('read', false);
    return (rows as List).length;
  }

  Future<void> markNotificationRead(String id) async {
    await supabase
        .from('merchant_notifications')
        .update({'read': true}).eq('id', id);
  }

  Future<int> markAllNotificationsRead() async {
    final res = await supabase.rpc('mark_all_notifications_read');
    return (res as num?)?.toInt() ?? 0;
  }

  // ---------------------------------------------------------------------------
  // CRM customers
  // ---------------------------------------------------------------------------
  Future<List<CrmCustomer>> customers({String? query}) async {
    final mid = await requireMerchantId();
    final rows = await supabase
        .from('merchant_customers')
        .select()
        .eq('merchant_id', mid)
        .order('last_payment_at', ascending: false, nullsFirst: false);
    var list =
        rows.map<CrmCustomer>((r) => CrmCustomer.fromMap(r)).toList();
    final q = query?.trim().toLowerCase();
    if (q != null && q.isNotEmpty) {
      list = list
          .where((c) =>
              c.name.toLowerCase().contains(q) ||
              (c.phone ?? '').toLowerCase().contains(q) ||
              (c.email ?? '').toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  Future<CrmCustomer> upsertCustomer({
    String? id,
    required String name,
    String? phone,
    String? email,
    String tier = 'starter',
    String? note,
  }) async {
    final mid = await requireMerchantId();
    final payload = {
      'merchant_id': mid,
      'name': name,
      'phone': phone,
      'email': email,
      'tier': tier,
      'note': note,
    };
    final Map<String, dynamic> row;
    if (id == null) {
      row = await supabase
          .from('merchant_customers')
          .insert(payload)
          .select()
          .single();
    } else {
      row = await supabase
          .from('merchant_customers')
          .update(payload)
          .eq('id', id)
          .select()
          .single();
    }
    return CrmCustomer.fromMap(row);
  }

  Future<void> deleteCustomer(String id) async {
    await supabase.from('merchant_customers').delete().eq('id', id);
  }

  Future<List<LedgerTransaction>> customerTransactions(String customerId) async {
    final rows = await supabase
        .from('transactions')
        .select()
        .eq('counterparty_customer_id', customerId)
        .order('created_at', ascending: false);
    return rows
        .map<LedgerTransaction>((r) => LedgerTransaction.fromMap(r))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Promo codes
  // ---------------------------------------------------------------------------
  Future<List<MerchantExpense>> expenses({DateTime? since}) async {
    final mid = await requireMerchantId();
    var req = supabase.from('merchant_expenses').select().eq('merchant_id', mid);
    if (since != null) req = req.gte('incurred_at', since.toIso8601String());
    final rows = await req.order('incurred_at', ascending: false);
    return rows.map<MerchantExpense>((r) => MerchantExpense.fromMap(r)).toList();
  }

  Future<List<MerchantBudget>> budgets({DateTime? activeOn}) async {
    final mid = await requireMerchantId();
    var req = supabase.from('merchant_budgets').select().eq('merchant_id', mid);
    if (activeOn != null) {
      final d = activeOn.toIso8601String().substring(0, 10);
      req = req.lte('period_start', d).gte('period_end', d);
    }
    final rows = await req.order('period_start', ascending: false);
    return rows.map<MerchantBudget>((r) => MerchantBudget.fromMap(r)).toList();
  }

  Future<List<PromoCode>> promoCodes() async {
    final mid = await requireMerchantId();
    final rows = await supabase
        .from('merchant_promo_codes')
        .select()
        .eq('merchant_id', mid)
        .order('created_at', ascending: false);
    return rows.map<PromoCode>((r) => PromoCode.fromMap(r)).toList();
  }

  Future<PromoCode> savePromoCode({
    String? id,
    required String code,
    required String title,
    String? body,
    int? discountPercent,
    bool active = true,
    DateTime? endsAt,
  }) async {
    final mid = await requireMerchantId();
    final payload = {
      'merchant_id': mid,
      'code': code.toUpperCase().trim(),
      'title': title,
      'body': body,
      'discount_percent': discountPercent,
      'active': active,
      'ends_at': endsAt?.toIso8601String(),
    };
    final Map<String, dynamic> row;
    if (id == null) {
      row = await supabase
          .from('merchant_promo_codes')
          .insert(payload)
          .select()
          .single();
    } else {
      row = await supabase
          .from('merchant_promo_codes')
          .update(payload)
          .eq('id', id)
          .select()
          .single();
    }
    return PromoCode.fromMap(row);
  }

  Future<void> setPromoActive(String id, bool active) async {
    await supabase
        .from('merchant_promo_codes')
        .update({'active': active}).eq('id', id);
  }

  Future<void> deletePromoCode(String id) async {
    await supabase.from('merchant_promo_codes').delete().eq('id', id);
  }

  // ---------------------------------------------------------------------------
  // Payment links
  // ---------------------------------------------------------------------------
  Future<List<PaymentLink>> paymentLinks() async {
    final mid = await requireMerchantId();
    final rows = await supabase
        .from('merchant_payment_links')
        .select()
        .eq('merchant_id', mid)
        .order('created_at', ascending: false);
    return rows.map<PaymentLink>((r) => PaymentLink.fromMap(r)).toList();
  }

  Future<PaymentLink> createPaymentLink({
    required num amount,
    required String description,
    String? reference,
  }) async {
    final res = await supabase.rpc('create_payment_link', params: {
      'p_amount': amount,
      'p_description': description,
      'p_reference': reference,
    });
    return PaymentLink.fromMap(_firstRow(res));
  }

  Future<void> setLinkStatus(String id, String status) async {
    await supabase
        .from('merchant_payment_links')
        .update({'status': status}).eq('id', id);
  }

  // ---------------------------------------------------------------------------
  // Cash receipts
  // ---------------------------------------------------------------------------
  Future<List<CashReceipt>> cashReceipts({int limit = 100}) async {
    final mid = await requireMerchantId();
    final rows = await supabase
        .from('cash_receipts')
        .select()
        .eq('merchant_id', mid)
        .order('created_at', ascending: false)
        .limit(limit);
    return rows.map<CashReceipt>((r) => CashReceipt.fromMap(r)).toList();
  }

  Future<CashReceipt> recordCashReceipt({
    required num amount,
    String category = 'General',
    String? customerName,
    String? note,
    String paymentMode = 'cash',
  }) async {
    final res = await supabase.rpc('record_cash_receipt', params: {
      'p_amount': amount,
      'p_category': category,
      'p_customer_name': customerName,
      'p_note': note,
      'p_payment_mode': paymentMode,
    });
    return CashReceipt.fromMap(_firstRow(res));
  }

  // ---------------------------------------------------------------------------
  // Ledger: transactions / settlements / transfers / statements / summary
  // ---------------------------------------------------------------------------
  Future<List<LedgerTransaction>> transactions({
    int limit = 50,
    String? typeFilter,
    String? statusFilter,
  }) async {
    final mid = await requireMerchantId();
    var req = supabase.from('transactions').select().eq('merchant_id', mid);
    if (typeFilter != null) req = req.eq('type', typeFilter);
    if (statusFilter != null) req = req.eq('status', statusFilter);
    final rows =
        await req.order('created_at', ascending: false).limit(limit);
    return rows
        .map<LedgerTransaction>((r) => LedgerTransaction.fromMap(r))
        .toList();
  }

  Future<List<SettlementBatch>> settlements() async {
    final mid = await requireMerchantId();
    final rows = await supabase
        .from('settlement_batches')
        .select()
        .eq('merchant_id', mid)
        .order('period_end', ascending: false);
    return rows.map<SettlementBatch>((r) => SettlementBatch.fromMap(r)).toList();
  }

  Future<List<MerchantTransfer>> transfers() async {
    final mid = await requireMerchantId();
    final rows = await supabase
        .from('merchant_transfers')
        .select()
        .eq('merchant_id', mid)
        .order('created_at', ascending: false);
    return rows
        .map<MerchantTransfer>((r) => MerchantTransfer.fromMap(r))
        .toList();
  }

  Future<MerchantTransfer> initiateTransfer({
    required String kind, // bank | internal
    required String source,
    required String destination,
    required num amount,
    String? note,
  }) async {
    final res = await supabase.rpc('initiate_transfer', params: {
      'p_kind': kind,
      'p_source': source,
      'p_destination': destination,
      'p_amount': amount,
      'p_note': note,
    });
    return MerchantTransfer.fromMap(_firstRow(res));
  }

  Future<List<FeeRate>> feeRates() async {
    final rows = await supabase.from('fee_rates').select().order('channel');
    return rows.map<FeeRate>((r) => FeeRate.fromMap(r)).toList();
  }

  /// The merchant's payout destination (`merchant_settlement_accounts`), or
  /// null if none recorded yet.
  Future<Map<String, dynamic>?> settlementAccount() async {
    final mid = await requireMerchantId();
    return supabase
        .from('merchant_settlement_accounts')
        .select()
        .eq('merchant_id', mid)
        .maybeSingle();
  }

  Future<StatementPeriod> statement(DateTime from, DateTime to) async {
    final results = await Future.wait([
      transactions(limit: 1000),
      cashReceipts(limit: 1000),
    ]);
    return StatementPeriod.compute(
      from: from,
      to: to,
      transactions: results[0] as List<LedgerTransaction>,
      cashReceipts: results[1] as List<CashReceipt>,
    );
  }

  Future<MerchantBusinessSummary> businessSummary() async {
    final txns = await transactions(limit: 1000);
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    num tpv = 0, rev = 0, balance = 0;
    var count = 0;
    for (final t in txns) {
      if (t.status == 'completed') {
        balance += t.signedAmount - t.feeAmount;
      }
      if (t.createdAt.isBefore(cutoff) || t.status != 'completed') continue;
      switch (t.type) {
        case 'payment':
          tpv += t.amount;
          rev += t.amount;
          count++;
        case 'refund':
          rev -= t.amount;
        default:
          break;
      }
    }
    return MerchantBusinessSummary(
      tpv30d: tpv,
      revenue30d: rev,
      transactionCount30d: count,
      avgTicket: count == 0 ? 0 : tpv / count,
      balance: balance,
    );
  }

  // ---------------------------------------------------------------------------
  // Setup checklist
  // ---------------------------------------------------------------------------
  Future<SetupChecklist> checklist() async {
    final mid = await requireMerchantId();
    final row = await supabase
        .from('merchant_setup_checklist')
        .select()
        .eq('merchant_id', mid)
        .maybeSingle();
    if (row == null) {
      await supabase
          .from('merchant_setup_checklist')
          .insert({'merchant_id': mid});
      return const SetupChecklist();
    }
    return SetupChecklist.fromMap(row);
  }

  Future<void> setChecklistItem(String key, bool value) async {
    final mid = await requireMerchantId();
    await supabase.from('merchant_setup_checklist').upsert({
      'merchant_id': mid,
      key: value,
    });
  }

  // ---------------------------------------------------------------------------
  // Favorites
  // ---------------------------------------------------------------------------
  Future<List<MerchantFavorite>> favorites() async {
    final mid = await requireMerchantId();
    final rows = await supabase
        .from('merchant_favorites')
        .select()
        .eq('merchant_id', mid)
        .order('created_at');
    return rows.map<MerchantFavorite>((r) => MerchantFavorite.fromMap(r)).toList();
  }

  Future<void> addFavorite(String key, String label, {String? route}) async {
    final mid = await requireMerchantId();
    await supabase.from('merchant_favorites').upsert({
      'merchant_id': mid,
      'setting_key': key,
      'label': label,
      'route': route,
    }, onConflict: 'merchant_id,setting_key');
  }

  Future<void> removeFavorite(String key) async {
    final mid = await requireMerchantId();
    await supabase
        .from('merchant_favorites')
        .delete()
        .eq('merchant_id', mid)
        .eq('setting_key', key);
  }

  // ---------------------------------------------------------------------------
  // Growth goals
  // ---------------------------------------------------------------------------
  Future<List<GrowthGoal>> growthGoals() async {
    final mid = await requireMerchantId();
    final rows = await supabase
        .from('merchant_growth_goals')
        .select()
        .eq('merchant_id', mid)
        .order('created_at');
    return rows.map<GrowthGoal>((r) => GrowthGoal.fromMap(r)).toList();
  }

  Future<GrowthGoal> saveGoal({
    String? id,
    required String title,
    String kind = 'revenue',
    required num targetAmount,
    num currentAmount = 0,
  }) async {
    final mid = await requireMerchantId();
    final payload = {
      'merchant_id': mid,
      'title': title,
      'kind': kind,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
    };
    final Map<String, dynamic> row;
    if (id == null) {
      row = await supabase
          .from('merchant_growth_goals')
          .insert(payload)
          .select()
          .single();
    } else {
      row = await supabase
          .from('merchant_growth_goals')
          .update(payload)
          .eq('id', id)
          .select()
          .single();
    }
    return GrowthGoal.fromMap(row);
  }

  Future<void> deleteGoal(String id) async {
    await supabase.from('merchant_growth_goals').delete().eq('id', id);
  }

  // ---------------------------------------------------------------------------
  // Preferences
  // ---------------------------------------------------------------------------
  Future<MerchantPreferences> preferences() async {
    final mid = await requireMerchantId();
    final row = await supabase
        .from('merchant_preferences')
        .select()
        .eq('merchant_id', mid)
        .maybeSingle();
    if (row == null) {
      await supabase.from('merchant_preferences').insert({'merchant_id': mid});
      return MerchantPreferences(merchantId: mid);
    }
    return MerchantPreferences.fromMap(row);
  }

  Future<void> savePreferences(Map<String, dynamic> patch) async {
    final mid = await requireMerchantId();
    await supabase.from('merchant_preferences').upsert({
      'merchant_id': mid,
      ...patch,
    });
  }

  // ---------------------------------------------------------------------------
  // Account
  // ---------------------------------------------------------------------------
  Future<Merchant> updateContact({
    String? ownerName,
    String? ownerEmail,
    String? addressStreet,
    String? addressCity,
  }) async {
    final res = await supabase.rpc('update_merchant_contact', params: {
      'p_owner_name': ownerName,
      'p_owner_email': ownerEmail,
      'p_address_street': addressStreet,
      'p_address_city': addressCity,
    });
    return _merchant = Merchant.fromMap(_firstRow(res));
  }

  Future<void> requestTier2Upgrade({String? note}) async {
    await supabase.rpc('request_tier2_upgrade', params: {'p_note': note});
    await myMerchant(refresh: true);
  }

  /// Supabase returns a single-row RPC result either as a Map or as a
  /// one-element List depending on the function's return type.
  Map<String, dynamic> _firstRow(dynamic res) {
    if (res is Map<String, dynamic>) return res;
    if (res is List && res.isNotEmpty) {
      return (res.first as Map).cast<String, dynamic>();
    }
    throw StateError('Unexpected RPC result shape: $res');
  }
}
