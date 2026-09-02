import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/models/engagement.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/ui/ui.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<AppNotification>> _future;

  @override
  void initState() {
    super.initState();
    _future = MerchantRepository.instance.notifications();
  }

  Future<void> _refresh() async {
    setState(() => _future = MerchantRepository.instance.notifications());
    await _future;
  }

  Future<void> _markAll() async {
    await MerchantRepository.instance.markAllNotificationsRead();
    if (mounted) _refresh();
  }

  Future<void> _open(AppNotification n) async {
    if (!n.read) {
      await MerchantRepository.instance.markNotificationRead(n.id);
      if (mounted) _refresh();
    }
  }

  IconData _icon(String category) => switch (category) {
        'payment' => Icons.payments_rounded,
        'settlement' => Icons.account_balance_rounded,
        'promo' => Icons.local_offer_rounded,
        'action' => Icons.task_alt_rounded,
        _ => Icons.notifications_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppScaffold(
      title: 'Notifications',
      actions: [
        TextButton(onPressed: _markAll, child: const Text('Mark all read')),
      ],
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<AppNotification>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final rows = snap.data ?? const [];
            if (rows.isEmpty) {
              return ListView(children: [
                const SizedBox(height: 120),
                Icon(Icons.notifications_none_rounded,
                    size: 56, color: cs.outlineVariant),
                const SizedBox(height: 12),
                Center(
                  child: Text('You\'re all caught up',
                      style: AppText.body(color: cs.onSurfaceVariant)),
                ),
              ]);
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.section),
              itemCount: rows.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, i) {
                final n = rows[i];
                return GlassSurface(
                  padding: EdgeInsets.zero,
                  tint: n.read ? null : cs.primary.withValues(alpha: 0.06),
                  child: ListRowCard(
                    floating: false,
                    icon: _icon(n.category),
                    iconColor: n.read ? cs.onSurfaceVariant : cs.primary,
                    title: n.title,
                    subtitle: n.body,
                    onTap: () => _open(n),
                    trailing: Text(
                      DateFormat.MMMd().format(n.createdAt),
                      style: AppText.caption(color: cs.onSurfaceVariant),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
