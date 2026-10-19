import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tulapay/models/ledger.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/screens/cash_receipts_screen.dart';
import 'package:tulapay/screens/collect_payment_screen.dart';
import 'package:tulapay/screens/more_actions_screen.dart';
import 'package:tulapay/screens/notification_screen.dart';
import 'package:tulapay/screens/payment_links_screen.dart';
import 'package:tulapay/screens/statements_screen.dart';
import 'package:tulapay/screens/transfer_screen.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/services/supabase_client.dart';
import 'package:tulapay/utils/money.dart';
import 'package:tulapay/widgets/custom_drawer.dart';
import 'package:tulapay/widgets/ui/ui.dart';

class _HomeData {
  final MerchantBusinessSummary summary;
  final List<LedgerTransaction> recent;
  const _HomeData(this.summary, this.recent);
}

class Homepage extends StatefulWidget {
  final ValueChanged<bool>? onDrawerChanged;

  const Homepage({super.key, this.onDrawerChanged});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _isBalanceVisible = true;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late final Future<Merchant> _merchantFuture =
      MerchantRepository.instance.myMerchant();
  late Future<_HomeData> _dataFuture;
  RealtimeChannel? _transactionsChannel;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadHomeData();
    _subscribeToTransactions();
  }

  @override
  void dispose() {
    final channel = _transactionsChannel;
    if (channel != null) supabase.removeChannel(channel);
    super.dispose();
  }

  void _subscribeToTransactions() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    _transactionsChannel = supabase
        .channel('home-transactions-$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'transactions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'owner_user_id',
            value: userId,
          ),
          callback: (_) => setState(() {
            _dataFuture = _loadHomeData();
          }),
        )
        .subscribe();
  }

  Future<_HomeData> _loadHomeData() async {
    final summary = await MerchantRepository.instance.businessSummary();
    final recent = await MerchantRepository.instance.transactions(limit: 5);
    return _HomeData(summary, recent);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      onDrawerChanged: widget.onDrawerChanged,
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 68,
        titleSpacing: AppSpacing.xxl,
        title: FutureBuilder<Merchant>(
          future: _merchantFuture,
          builder: (context, snap) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TULABIX',
                style: AppText.microLabel(color: context.textTertiary)
                    .copyWith(letterSpacing: 1.6),
              ),
              const SizedBox(height: 4),
              Text(
                snap.data?.businessName ?? 'Merchant Dashboard',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.screenTitle(size: 18, color: cs.onSurface)
                    .copyWith(letterSpacing: -0.3),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            ),
            icon: Icon(Icons.notifications_none_rounded,
                color: cs.onSurface, size: 22),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: AppSpacing.xs, right: AppSpacing.xxl),
            child: GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: FutureBuilder<Merchant>(
                future: _merchantFuture,
                builder: (context, snap) => CircleAvatar(
                  radius: 17,
                  backgroundColor: context.primaryTintColor,
                  child: Text(
                    _initials(snap.data?.businessName ?? 'TulaBix'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          final next = _loadHomeData();
          setState(() {
            _dataFuture = next;
          });
          await next;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                AppSpacing.md,
                AppSpacing.xxl,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: FutureBuilder<_HomeData>(
                  future: _dataFuture,
                  builder: (context, snap) => _BalanceCard(
                    isVisible: _isBalanceVisible,
                    onToggle: () =>
                        setState(() => _isBalanceVisible = !_isBalanceVisible),
                    summary: snap.data?.summary,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                24,
                AppSpacing.xxl,
                AppSpacing.md,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'QUICK ACTIONS',
                      style: AppText.microLabel(color: context.textTertiary)
                          .copyWith(letterSpacing: 1.6),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              sliver: SliverToBoxAdapter(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _quickAction(
                      context,
                      icon: Icons.phone_android_rounded,
                      label: 'Collect',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CollectPaymentScreen(),
                        ),
                      ),
                    ),
                    _quickAction(
                      context,
                      icon: Icons.link_rounded,
                      label: 'Link',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentLinksScreen(),
                        ),
                      ),
                    ),
                    _quickAction(
                      context,
                      icon: Icons.account_balance_rounded,
                      label: 'Transfer',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransferScreen(kind: 'bank'),
                        ),
                      ),
                    ),
                    _quickAction(
                      context,
                      icon: Icons.receipt_long_outlined,
                      label: 'Receipt',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CashReceiptsScreen(),
                        ),
                      ),
                    ),
                    _quickAction(
                      context,
                      icon: Icons.description_outlined,
                      label: 'Statement',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StatementsScreen(),
                        ),
                      ),
                    ),
                    _quickAction(
                      context,
                      icon: Icons.more_horiz_rounded,
                      label: 'More',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MoreActionsScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                28,
                AppSpacing.xxl,
                AppSpacing.md,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RECENT ACTIVITY',
                      style: AppText.microLabel(color: context.textTertiary)
                          .copyWith(letterSpacing: 1.6),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'See all',
                        style: AppText.caption(color: cs.secondary).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              sliver: SliverToBoxAdapter(
                child: FutureBuilder<_HomeData>(
                  future: _dataFuture,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final recent = snap.data?.recent ?? const [];
                    if (recent.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No activity yet — payments will show up here.',
                          style: AppText.caption(color: cs.onSurfaceVariant),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        for (final tx in recent)
                          ListRowCard(
                            floating: false,
                            icon: tx.isInflow
                                ? Icons.south_west_rounded
                                : Icons.north_east_rounded,
                            iconColor: tx.isInflow
                                ? AppColors.positive
                                : cs.secondary,
                            title: tx.counterpartyName ?? tx.typeLabel,
                            subtitle: DateFormat(
                              'MMM d, h:mm a',
                            ).format(tx.createdAt),
                            value: signedMoney(
                              tx.signedAmount,
                              currency: tx.amountCurrency,
                            ),
                            secondaryValue:
                                tx.status[0].toUpperCase() +
                                tx.status.substring(1),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.section),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'TB';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts[1][0]).toUpperCase();
  }

  Widget _quickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: context.primaryTintColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: cs.primary),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption(color: context.textSecondary).copyWith(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onToggle;
  final MerchantBusinessSummary? summary;

  const _BalanceCard({
    required this.isVisible,
    required this.onToggle,
    this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: context.primaryTintColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AVAILABLE BALANCE',
                style: AppText.microLabel(color: cs.primary)
                    .copyWith(letterSpacing: 1.6),
              ),
              GestureDetector(
                onTap: onToggle,
                child: Icon(
                  isVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isVisible
                ? (summary == null
                      ? 'XAF ••••••••'
                      : money(summary!.balance))
                : 'XAF ••••••••',
            style: AppText.hero(size: 36, color: cs.onSurface).copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -1.0,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '▲ 4.2% ',
                style: AppText.caption(color: AppColors.positive).copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              Text(
                'vs last week · 30d TPV: ${summary == null ? '••••' : money(summary!.revenue30d)}',
                style: AppText.caption(color: cs.onSurfaceVariant).copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
