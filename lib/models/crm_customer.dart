/// `merchant_customers` — the merchant-side CRM. Replaces the hardcoded
/// in-file `_customers` list in `Customer_Screen.dart`.
class CrmCustomer {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String tier; // starter | growth | scale
  final String? note;
  final num totalSpent;
  final int totalTransactions;
  final DateTime? lastPaymentAt;
  final DateTime createdAt;

  const CrmCustomer({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.tier = 'starter',
    this.note,
    this.totalSpent = 0,
    this.totalTransactions = 0,
    this.lastPaymentAt,
    required this.createdAt,
  });

  factory CrmCustomer.fromMap(Map<String, dynamic> m) => CrmCustomer(
        id: m['id'] as String,
        name: (m['name'] ?? '') as String,
        phone: m['phone'] as String?,
        email: m['email'] as String?,
        tier: (m['tier'] ?? 'starter') as String,
        note: m['note'] as String?,
        totalSpent: (m['total_spent'] as num?) ?? 0,
        totalTransactions: (m['total_transactions'] as num?)?.toInt() ?? 0,
        lastPaymentAt: m['last_payment_at'] == null
            ? null
            : DateTime.tryParse(m['last_payment_at'].toString()),
        createdAt: DateTime.parse(m['created_at'].toString()),
      );

  String get initials {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  /// "Today", "3d ago", "2w ago", "—".
  String get lastSeenLabel {
    final at = lastPaymentAt;
    if (at == null) return '—';
    final d = DateTime.now().difference(at);
    if (d.inHours < 24) return 'Today';
    if (d.inDays < 7) return '${d.inDays}d ago';
    if (d.inDays < 30) return '${(d.inDays / 7).floor()}w ago';
    return '${(d.inDays / 30).floor()}mo ago';
  }

  /// Buckets used by the Customers screen filter chips.
  String get recencyBucket {
    final at = lastPaymentAt;
    if (at == null) return 'Dormant';
    final days = DateTime.now().difference(at).inDays;
    if (days <= 7) return 'Active';
    if (days <= 30) return 'Recent';
    return 'Dormant';
  }
}
