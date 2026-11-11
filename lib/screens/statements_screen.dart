import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tulapay/format.dart';
import 'package:tulapay/models/ledger.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/services/supabase_client.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/utils/csv_export.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

/// Real statement screen — backs the "Statements" tile in More Actions.
/// Calls the already-existing [MerchantRepository.statement].
class StatementsScreen extends StatelessWidget {
  const StatementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StatementsView();
  }
}

class _StatementsView extends StatefulWidget {
  const _StatementsView();

  @override
  State<_StatementsView> createState() => _StatementsViewState();
}

class _StatementsViewState extends State<_StatementsView> {
  late DateTimeRange _range;
  Future<StatementPeriod>? _future;
  RealtimeChannel? _transactionsChannel;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _range = DateTimeRange(start: DateTime(now.year, now.month, 1), end: now);
    _load();
    _subscribeToTransactions();
  }

  @override
  void dispose() {
    final channel = _transactionsChannel;
    if (channel != null) supabase.removeChannel(channel);
    super.dispose();
  }

  // Previously only reloaded on an explicit date-range change — a
  // transaction landing while this screen was already open (e.g. a payment
  // completing via webhook) never showed up without leaving and
  // re-entering. Same pattern as Homepage.dart's balance fix.
  void _subscribeToTransactions() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    _transactionsChannel = supabase
        .channel('statements-transactions-$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'transactions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'owner_user_id',
            value: userId,
          ),
          callback: (_) => setState(_load),
        )
        .subscribe();
  }

  // `_range.end` is the last INCLUSIVE day the user picked; the repository/
  // compute layer treats `to` as exclusive, so the day boundary is added
  // once, here, and nowhere else — this is what keeps the summary and the
  // exported CSV detail rows from disagreeing on what "the end date" means.
  DateTime get _queryEnd => DateTime(
    _range.end.year,
    _range.end.month,
    _range.end.day,
  ).add(const Duration(days: 1));

  void _load() {
    _future = MerchantRepository.instance.statement(_range.start, _queryEnd);
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: _range,
    );
    if (picked == null) return;
    setState(() {
      _range = picked;
      _load();
    });
  }

  Future<void> _export(StatementPeriod s) async {
    final fmt = DateFormat('MMM d, yyyy');
    final rangeLabel =
        context.l10n.dateRangeTo(fmt.format(_range.start), fmt.format(_range.end));

    final rows = <List<Object?>>[
      [context.l10n.tulabizStatement, rangeLabel],
      [],
      [context.l10n.grossRevenue, s.grossRevenue],
      [context.l10n.refunds, s.refunds],
      [context.l10n.netRevenue, s.netRevenue],
      [context.l10n.feesCharged, s.feesCharged],
      [context.l10n.payoutsReceived, s.payoutsReceived],
      [context.l10n.transactionCount, s.transactionCount],
      [],
      [
        context.l10n.date,
        context.l10n.type,
        context.l10n.channel,
        context.l10n.status,
        context.l10n.counterparty,
        context.l10n.amount,
        context.l10n.currency,
        context.l10n.fee,
        context.l10n.reference,
      ],
    ];

    try {
      final inRange = await MerchantRepository.instance.transactions(
        from: _range.start,
        to: _queryEnd,
        limit: 5000,
      );
      for (final t in inRange) {
        rows.add([
          DateFormat('yyyy-MM-dd HH:mm').format(t.createdAt),
          t.typeLabel,
          t.channelLabel,
          t.status,
          t.counterpartyName ?? '',
          t.amount,
          t.amountCurrency,
          t.feeAmount,
          t.reference ?? '',
        ]);
      }
    } catch (_) {
      // Summary section is still useful on its own if the detail fetch
      // fails — export what we have rather than blocking the whole thing.
    }

    if (!mounted) return;
    try {
      await shareAsCsv(
        'tulabiz-statement-${DateFormat('yyyyMMdd').format(s.periodStart)}.csv',
        rows,
        subject: context.l10n.tulabizStatement,
      );
    } catch (_) {
      if (mounted) AppFeedback.toast(context, context.l10n.couldNotExportTheStatement);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fmt = DateFormat('MMM d, yyyy');

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          context.l10n.statements,
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(_load);
          await _future;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: context.hairlineColor),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.date_range_rounded, color: cs.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${fmt.format(_range.start)} — ${fmt.format(_range.end)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _pickRange,
                            style: TextButton.styleFrom(
                              foregroundColor: cs.secondary,
                            ),
                            child: Text(context.l10n.change),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<StatementPeriod>(
                    future: _future,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snap.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            context.l10n.couldNotLoadThisStatement,
                            style: GoogleFonts.plusJakartaSans(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        );
                      }
                      final s = snap.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlassSurface(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.summary,
                                  style: AppText.microLabel(
                                    color: context.textTertiary,
                                  ).copyWith(letterSpacing: 1.6),
                                ),
                                const SizedBox(height: 14),
                                _Row(
                                  context.l10n.grossRevenue,
                                  money(s.grossRevenue),
                                  cs,
                                ),
                                _Row(context.l10n.refunds, '- ${money(s.refunds)}', cs),
                                const Divider(height: 24),
                                _Row(
                                  context.l10n.netRevenue,
                                  money(s.netRevenue),
                                  cs,
                                  emphasize: true,
                                ),
                                const SizedBox(height: 12),
                                _Row(context.l10n.feesCharged, money(s.feesCharged), cs),
                                _Row(
                                  context.l10n.payoutsReceived,
                                  money(s.payoutsReceived),
                                  cs,
                                ),
                                _Row(
                                  context.l10n.transactions,
                                  '${s.transactionCount}',
                                  cs,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton.icon(
                              onPressed: () => _export(s),
                              icon: const Icon(Icons.ios_share_rounded),
                              label: Text(context.l10n.shareSummary),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme cs;
  final bool emphasize;

  const _Row(this.label, this.value, this.cs, {this.emphasize = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: emphasize ? 15 : 13,
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w600,
              color: emphasize ? cs.onSurface : context.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: emphasize ? 18 : 14,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
