import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/format.dart';
import 'package:tulapay/models/crm_customer.dart';
import 'package:tulapay/models/ledger.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/ui/ui.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────
//
// Backed by `merchant_customers` (via MerchantRepository.customers()) — no
// more hardcoded/fake customer list. A fresh merchant with no CRM entries
// yet just sees the empty state below.

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});
  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  static const _filters = ['All', 'Active', 'Recent', 'Dormant'];

  bool _loading = true;
  String? _error;
  List<CrmCustomer> _customers = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final customers = await MerchantRepository.instance.customers();
      if (!mounted) return;
      setState(() {
        _customers = customers;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load customers. Pull to try again.';
        _loading = false;
      });
    }
  }

  List<CrmCustomer> get _filtered {
    return _customers.where((c) {
      final q = _searchQuery.toLowerCase();
      final matchSearch =
          q.isEmpty ||
          c.name.toLowerCase().contains(q) ||
          (c.email ?? '').toLowerCase().contains(q) ||
          (c.phone ?? '').toLowerCase().contains(q);
      final matchBucket =
          _selectedFilter == 'All' || c.recencyBucket == _selectedFilter;
      return matchSearch && matchBucket;
    }).toList();
  }

  Future<void> _refresh() => _load();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(cs),
            _buildSearchAndFilters(cs),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                color: cs.primary,
                child: _loading
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 140),
                          Center(child: CircularProgressIndicator()),
                        ],
                      )
                    : _error != null
                        ? _buildErrorState(cs)
                        : filtered.isEmpty
                            ? _buildEmptyState(cs)
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  16,
                                  24,
                                  100,
                                ),
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, i) {
                                  final c = filtered[i];
                                  return _CustomerRow(
                                        customer: c,
                                        onTap: () => _showDetail(context, c),
                                      )
                                      .animate()
                                      .fadeIn(delay: (i * 40).ms)
                                      .slideX(begin: 0.02);
                                },
                              ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCustomerSheet(context),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildHeader(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MicroLabel('Directory'),
              const SizedBox(height: 2),
              Text('Customers', style: AppText.screenTitle(size: 28)),
            ],
          ),
          Row(
            children: [
              CircleIconButton(Icons.ios_share_rounded, onTap: () {}),
              const SizedBox(width: 10),
              CircleIconButton(Icons.tune_rounded, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Search customers...',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: cs.onSurfaceVariant,
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((f) {
                final sel = _selectedFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilter = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: sel
                            ? cs.primary.withValues(alpha: 0.12)
                            : context.trackColor,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        f,
                        style: AppText.caption(
                          color: sel ? cs.primary : cs.onSurfaceVariant,
                        ).copyWith(
                            fontWeight:
                                sel ? FontWeight.w700 : FontWeight.w600),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme cs) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 100),
        Icon(Icons.person_search_rounded, size: 64, color: cs.outlineVariant),
        const SizedBox(height: 16),
        Center(
          child: Text(
            _customers.isEmpty ? 'No customers yet' : 'No customers found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(ColorScheme cs) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 100),
        Icon(Icons.cloud_off_rounded, size: 48, color: cs.outlineVariant),
        const SizedBox(height: 16),
        Center(
          child: Text(
            _error!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  void _showAddCustomerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _AddCustomerSheet(onSaved: _load),
    );
  }

  void _showDetail(BuildContext context, CrmCustomer c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CustomerDetailSheet(customer: c),
    );
  }
}

// ─── Tier styling ───────────────────────────────────────────────────────────

Color _tierColor(String tier) => switch (tier) {
      'scale' => const Color(0xFFE6A817),
      'growth' => const Color(0xFF8E9AAB),
      _ => const Color(0xFFB87333), // starter
    };

String _tierLabel(String tier) =>
    tier.isEmpty ? 'Starter' : tier[0].toUpperCase() + tier.substring(1);

class _TierDot extends StatelessWidget {
  final Color color;
  const _TierDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

// ─── Customer row ────────────────────────────────────────────────────────────

class _CustomerRow extends StatelessWidget {
  final CrmCustomer customer;
  final VoidCallback onTap;
  const _CustomerRow({required this.customer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tc = _tierColor(customer.tier);

    return GlassSurface(
      borderRadius: BorderRadius.circular(20),
      opacity: 0.14,
      blur: 12,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: tc.withValues(alpha: 0.1),
                      child: Text(
                        customer.initials,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          color: tc,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Positioned(right: 0, bottom: 0, child: _TierDot(color: tc)),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: cs.onSurface,
                        ),
                      ),
                      Text(
                        customer.email ?? customer.phone ?? 'No contact info',
                        style: GoogleFonts.plusJakartaSans(
                          color: cs.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      money(customer.totalSpent, compact: true),
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      customer.lastSeenLabel,
                      style: GoogleFonts.plusJakartaSans(
                        color: cs.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Add customer sheet ──────────────────────────────────────────────────────

class _AddCustomerSheet extends StatefulWidget {
  final VoidCallback onSaved;
  const _AddCustomerSheet({required this.onSaved});

  @override
  State<_AddCustomerSheet> createState() => _AddCustomerSheetState();
}

class _AddCustomerSheetState extends State<_AddCustomerSheet> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Name is required.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await MerchantRepository.instance.upsertCustomer(
        name: _name.text.trim(),
        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      );
      widget.onSaved();
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Could not save this customer. Try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'New Customer',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          _field(_name, 'Full Name', Icons.person_outline_rounded, cs),
          const SizedBox(height: 16),
          _field(_email, 'Email Address', Icons.email_outlined, cs),
          const SizedBox(height: 16),
          _field(_phone, 'Phone Number', Icons.phone_outlined, cs),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(color: cs.error, fontSize: 13),
            ),
          ],
          const SizedBox(height: 32),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Save Customer'),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon,
    ColorScheme cs,
  ) {
    return TextField(
      controller: controller,
      style: TextStyle(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: cs.onSurfaceVariant),
        prefixIcon: Icon(icon, size: 20, color: cs.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
      ),
    );
  }
}

// ─── Customer detail sheet ───────────────────────────────────────────────────

class _CustomerDetailSheet extends StatefulWidget {
  final CrmCustomer customer;
  const _CustomerDetailSheet({required this.customer});
  @override
  State<_CustomerDetailSheet> createState() => _CustomerDetailSheetState();
}

class _CustomerDetailSheetState extends State<_CustomerDetailSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  bool _loadingTxns = true;
  List<LedgerTransaction> _txns = const [];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _loadTxns();
  }

  Future<void> _loadTxns() async {
    try {
      final txns = await MerchantRepository.instance.customerTransactions(
        widget.customer.id,
      );
      if (!mounted) return;
      setState(() {
        _txns = txns;
        _loadingTxns = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingTxns = false);
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = widget.customer;

    return GlassSurface(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      opacity: 0.14,
      blur: 16,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: cs.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: cs.surfaceContainerHigh,
                  child: Text(
                    c.initials,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: cs.onSurface,
                        ),
                      ),
                      Text(
                        c.email ?? c.phone ?? 'No contact info',
                        style: GoogleFonts.plusJakartaSans(
                          color: cs.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _action('Message', Icons.chat_bubble_outline_rounded, cs),
                const SizedBox(width: 12),
                _action('Invoice', Icons.receipt_long_rounded, cs),
                const SizedBox(width: 12),
                _circleAction(Icons.more_horiz_rounded, cs),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TabBar(
            controller: _tab,
            dividerColor: cs.outlineVariant,
            indicatorColor: cs.primary,
            labelColor: cs.onSurface,
            unselectedLabelColor: cs.onSurfaceVariant,
            labelStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
            tabs: const [
              Tab(text: 'Transactions'),
              Tab(text: 'Customer Info'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [_history(cs), _info(c, cs)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _action(String label, IconData icon, ColorScheme cs) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.onSurface,
          side: BorderSide(color: cs.outlineVariant),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _circleAction(IconData icon, ColorScheme cs) {
    return GlassSurface(
      borderRadius: BorderRadius.circular(999),
      opacity: 0.14,
      blur: 12,
      child: IconButton(
        icon: Icon(icon, color: cs.onSurface),
        onPressed: () {},
      ),
    );
  }

  Widget _history(ColorScheme cs) {
    if (_loadingTxns) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_txns.isEmpty) {
      return Center(
        child: Text(
          'No transactions with this customer yet.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: cs.onSurfaceVariant,
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _txns.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final tx = _txns[i];
        final isCredit = tx.isInflow;
        return GlassSurface(
          borderRadius: BorderRadius.circular(16),
          opacity: 0.12,
          blur: 10,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                isCredit
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: isCredit ? Colors.green : Colors.redAccent,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${tx.typeLabel} · ${tx.channelLabel}',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      DateFormat('MMM d, h:mm a').format(tx.createdAt),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                money(tx.amount),
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _info(CrmCustomer c, ColorScheme cs) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _infoRow('Phone Number', c.phone ?? '—', cs),
        _infoRow('Customer Tier', _tierLabel(c.tier), cs),
        _infoRow('Total Transactions', '${c.totalTransactions} items', cs),
        _infoRow('Total Spent', money(c.totalSpent), cs),
        _infoRow(
          'Customer Since',
          DateFormat('MMM d, yyyy').format(c.createdAt),
          cs,
        ),
        const SizedBox(height: 24),
        Text(
          'Internal Notes',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          maxLines: 3,
          style: TextStyle(color: cs.onSurface),
          controller: TextEditingController(text: c.note ?? ''),
          decoration: InputDecoration(
            hintText: 'Add a private note about this customer...',
            hintStyle: TextStyle(
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: cs.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (v) {
            MerchantRepository.instance.upsertCustomer(
              id: c.id,
              name: c.name,
              phone: c.phone,
              email: c.email,
              tier: c.tier,
              note: v.trim().isEmpty ? null : v.trim(),
            );
          },
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: cs.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: cs.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
