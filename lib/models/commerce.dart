import 'package:tulapay/models/ledger.dart' show CashReceiptLike;

/// `merchant_promo_codes` — merchant-authored discount codes.
class PromoCode {
  final String id;
  final String code;
  final String title;
  final String? body;
  final int? discountPercent;
  final bool active;
  final DateTime startsAt;
  final DateTime? endsAt;
  final int redemptionCount;
  final DateTime createdAt;

  const PromoCode({
    required this.id,
    required this.code,
    required this.title,
    this.body,
    this.discountPercent,
    this.active = true,
    required this.startsAt,
    this.endsAt,
    this.redemptionCount = 0,
    required this.createdAt,
  });

  factory PromoCode.fromMap(Map<String, dynamic> m) => PromoCode(
        id: m['id'] as String,
        code: m['code'] as String,
        title: (m['title'] ?? '') as String,
        body: m['body'] as String?,
        discountPercent: (m['discount_percent'] as num?)?.toInt(),
        active: (m['active'] ?? true) as bool,
        startsAt: DateTime.parse(m['starts_at'].toString()),
        endsAt: m['ends_at'] == null
            ? null
            : DateTime.tryParse(m['ends_at'].toString()),
        redemptionCount: (m['redemption_count'] as num?)?.toInt() ?? 0,
        createdAt: DateTime.parse(m['created_at'].toString()),
      );

  bool get isLive {
    final now = DateTime.now();
    if (!active) return false;
    if (now.isBefore(startsAt)) return false;
    if (endsAt != null && now.isAfter(endsAt!)) return false;
    return true;
  }
}

/// `merchant_payment_links`.
class PaymentLink {
  final String id;
  final num amount;
  final String currency;
  final String description;
  final String? reference;
  final String slug;
  final String status; // active | paid | expired | disabled
  final DateTime createdAt;
  final DateTime? expiresAt;

  const PaymentLink({
    required this.id,
    required this.amount,
    this.currency = 'XAF',
    required this.description,
    this.reference,
    required this.slug,
    this.status = 'active',
    required this.createdAt,
    this.expiresAt,
  });

  factory PaymentLink.fromMap(Map<String, dynamic> m) => PaymentLink(
        id: m['id'] as String,
        amount: (m['amount'] as num?) ?? 0,
        currency: (m['currency'] ?? 'XAF') as String,
        description: (m['description'] ?? '') as String,
        reference: m['reference'] as String?,
        slug: m['slug'] as String,
        status: (m['status'] ?? 'active') as String,
        createdAt: DateTime.parse(m['created_at'].toString()),
        expiresAt: m['expires_at'] == null
            ? null
            : DateTime.tryParse(m['expires_at'].toString()),
      );

  static const _base = 'https://pay.tulabix.com';
  String get url => '$_base/$slug';
}

/// `cash_receipts` — append-only.
class CashReceipt implements CashReceiptLike {
  final String id;
  @override
  final num amount;
  final String currency;
  final String category;
  final String? customerName;
  final String? note;
  final String paymentMode; // cash | mobile_money | card | bank_transfer
  @override
  final DateTime createdAt;

  const CashReceipt({
    required this.id,
    required this.amount,
    this.currency = 'XAF',
    this.category = 'General',
    this.customerName,
    this.note,
    this.paymentMode = 'cash',
    required this.createdAt,
  });

  factory CashReceipt.fromMap(Map<String, dynamic> m) => CashReceipt(
        id: m['id'] as String,
        amount: (m['amount'] as num?) ?? 0,
        currency: (m['currency'] ?? 'XAF') as String,
        category: (m['category'] ?? 'General') as String,
        customerName: m['customer_name'] as String?,
        note: m['note'] as String?,
        paymentMode: (m['payment_mode'] ?? 'cash') as String,
        createdAt: DateTime.parse(m['created_at'].toString()),
      );

  String get paymentModeLabel => switch (paymentMode) {
        'cash' => 'Cash',
        'mobile_money' => 'Mobile money',
        'card' => 'Card',
        'bank_transfer' => 'Bank transfer',
        _ => paymentMode,
      };
}
