import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/models/ledger.dart';
import 'package:tulapay/screens/cash_receipts_screen.dart';
import 'package:tulapay/screens/more_actions_screen.dart';
import 'package:tulapay/screens/payment_links_screen.dart';
import 'package:tulapay/screens/scan_qr_screen.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/utils/money.dart';
import 'package:tulapay/widgets/custom_drawer.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/ui/ui.dart';

/// Bundles what the balance card + Recent Activity list need, so both can
/// come from one Future instead of loading twice.
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

  late final Future<_HomeData> _dataFuture = _loadHomeData();

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
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('TulaBiz', style: AppText.screenTitle(size: 22)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.notes_rounded, color: cs.onSurface, size: 26),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded, color: cs.onSurface),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 18,
                backgroundColor: cs.primary.withValues(alpha: 0.12),
                child: Icon(Icons.person_outline_rounded,
                    color: cs.primary, size: 22),
              ),
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        // physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, 0),
            sliver: SliverToBoxAdapter(
              child: FutureBuilder<_HomeData>(
                future: _dataFuture,
                builder: (context, snap) => _BalanceCard(
                  isVisible: _isBalanceVisible,
                  onToggle: () => setState(
                      () => _isBalanceVisible = !_isBalanceVisible),
                  summary: snap.data?.summary,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.huge, AppSpacing.xl, AppSpacing.md),
            sliver: SliverToBoxAdapter(
              child: SectionHeader(
                'Quick Actions',
                actionLabel: 'More',
                onAction: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MoreActionsScreen()),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverToBoxAdapter(
              child: GlassSurface(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _quickAction(context,
                        icon: Icons.link_rounded,
                        label: 'Payment Links',
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const PaymentLinksScreen()))),
                    _quickAction(context,
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Scan QR',
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const ScanQrScreen()))),
                    _quickAction(context,
                        icon: Icons.receipt_long_outlined,
                        label: 'Cash Receipts',
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const CashReceiptsScreen()))),
                    _quickAction(context,
                        icon: Icons.grid_view_rounded,
                        label: 'More',
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const MoreActionsScreen()))),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.huge, AppSpacing.xl, AppSpacing.md),
            sliver: SliverToBoxAdapter(
              child: SectionHeader('Recent Activity',
                  actionLabel: 'All', onAction: () {}),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
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
                      for (final tx in recent) ...[
                        ListRowCard(
                          icon: tx.isInflow
                              ? Icons.south_west_rounded
                              : Icons.north_east_rounded,
                          iconColor: tx.isInflow
                              ? const Color(0xFF10B981)
                              : cs.secondary,
                          title: tx.counterpartyName ?? tx.typeLabel,
                          subtitle: DateFormat('MMM d, h:mm a').format(tx.createdAt),
                          value: signedMoney(tx.signedAmount, currency: tx.amountCurrency),
                          secondaryValue: tx.status[0].toUpperCase() + tx.status.substring(1),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.section)),
        ],
      ),
    );
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
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: context.trackColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 19, color: cs.onSurface),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption(color: cs.onSurfaceVariant).copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.15,
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

  const _BalanceCard({required this.isVisible, required this.onToggle, this.summary});

  @override
  Widget build(BuildContext context) {
    return GradientHeroCard(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('MAIN BALANCE',
                      style: AppText.microLabel(
                          color: Colors.white.withValues(alpha: 0.75))),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: onToggle,
                    child: Icon(
                      isVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.wallet_rounded,
                    color: Colors.white, size: 22),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('XAF ',
                  style: AppText.cardTitle(
                      size: 15, color: Colors.white.withValues(alpha: 0.7))),
              Text(
                isVisible
                    ? (summary == null ? '••••••••' : amountOnly(summary!.balance))
                    : '••••••••',
                style: AppText.hero(size: 34, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                _miniMetric(
                  '30-Day Revenue',
                  isVisible
                      ? (summary == null ? '••••' : signedMoney(summary!.revenue30d))
                      : '+ XAF ••••',
                  const Color(0xFFB6F2D3),
                ),
                _divider(),
                _miniMetric(
                  'Transactions',
                  summary == null ? '••' : '${summary!.transactionCount30d} (30d)',
                  Colors.white,
                ),
                _divider(),
                _miniMetric(
                  'Avg. Ticket',
                  summary == null ? '••••' : money(summary!.avgTicket),
                  Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(height: 28, width: 1, color: Colors.white24);

  Widget _miniMetric(String title, String value, Color valueColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption(
                    color: Colors.white.withValues(alpha: 0.7))
                    .copyWith(fontSize: 10)),
            const SizedBox(height: 4),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.cardTitle(size: 13, color: valueColor)),
          ],
        ),
      ),
    );
  }
}
