/// Engagement / feed models — `merchant_notifications`, `merchant_growth_goals`,
/// `merchant_favorites`.

class AppNotification {
  final String id;
  final String category; // payment | promo | action | system | settlement
  final String title;
  final String body;
  final String? route;
  final bool read;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    this.route,
    this.read = false,
    required this.createdAt,
  });

  factory AppNotification.fromMap(Map<String, dynamic> m) => AppNotification(
        id: m['id'] as String,
        category: m['category'] as String,
        title: (m['title'] ?? '') as String,
        body: (m['body'] ?? '') as String,
        route: m['route'] as String?,
        read: (m['read'] ?? false) as bool,
        createdAt: DateTime.parse(m['created_at'].toString()),
      );
}

class GrowthGoal {
  final String id;
  final String title;
  final String kind; // revenue | customers | orders | custom
  final num targetAmount;
  final num currentAmount;
  final String currency;
  final DateTime createdAt;

  const GrowthGoal({
    required this.id,
    required this.title,
    this.kind = 'revenue',
    required this.targetAmount,
    this.currentAmount = 0,
    this.currency = 'XAF',
    required this.createdAt,
  });

  factory GrowthGoal.fromMap(Map<String, dynamic> m) => GrowthGoal(
        id: m['id'] as String,
        title: (m['title'] ?? '') as String,
        kind: (m['kind'] ?? 'revenue') as String,
        targetAmount: (m['target_amount'] as num?) ?? 0,
        currentAmount: (m['current_amount'] as num?) ?? 0,
        currency: (m['currency'] ?? 'XAF') as String,
        createdAt: DateTime.parse(m['created_at'].toString()),
      );

  double get progress =>
      targetAmount <= 0 ? 0 : (currentAmount / targetAmount).clamp(0.0, 1.0);
  int get progressPercent => (progress * 100).round();
  bool get isMonetary => kind == 'revenue' || kind == 'custom';
}

class MerchantFavorite {
  final String id;
  final String settingKey;
  final String label;
  final String? route;

  const MerchantFavorite({
    required this.id,
    required this.settingKey,
    required this.label,
    this.route,
  });

  factory MerchantFavorite.fromMap(Map<String, dynamic> m) => MerchantFavorite(
        id: m['id'] as String,
        settingKey: m['setting_key'] as String,
        label: (m['label'] ?? '') as String,
        route: m['route'] as String?,
      );
}
