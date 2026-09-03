import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/ui/ui.dart';

// ─── Data Models ─────────────────────────────────────────────────────────────

class _Customer {
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String tier;
  final double totalSpent;
  final int totalTransactions;
  final DateTime lastPaymentDate;
  final List<_Tx> transactions;

  const _Customer({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.tier,
    required this.totalSpent,
    required this.totalTransactions,
    required this.lastPaymentDate,
    required this.transactions,
  });

  String get lastSeenLabel {
    final d = DateTime.now().difference(lastPaymentDate);
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    if (d.inDays == 1) return 'Yesterday';
    if (d.inDays < 7) return '${d.inDays}d ago';
    if (d.inDays < 30) return '${(d.inDays / 7).floor()}w ago';
    if (d.inDays < 365) return '${(d.inDays / 30).floor()}mo ago';
    return '${(d.inDays / 365).floor()}yr ago';
  }

  String get recencyBucket {
    final d = DateTime.now().difference(lastPaymentDate);
    if (d.inHours < 24) return 'Today';
    if (d.inDays < 7) return 'This Week';
    if (d.inDays < 30) return 'This Month';
    return 'Older';
  }
}

class _Tx {
  final String type;
  final String description;
  final double amount;
  final String date;
  const _Tx({
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
  });
}

// ─── Data ─────────────────────────────────────────────────────────────────────

final _now = DateTime.now();

final _customers = <_Customer>[
  _Customer(
    name: 'Amina Okafor',
    email: 'amina.okafor@gmail.com',
    phone: '+234 812 345 6789',
    avatar: 'AO',
    tier: 'Gold',
    totalSpent: 4500000,
    totalTransactions: 42,
    lastPaymentDate: _now.subtract(const Duration(minutes: 12)),
    transactions: const [
      _Tx(
        type: 'credit',
        description: 'Product Purchase',
        amount: 150000,
        date: 'Today, 10:24 AM',
      ),
      _Tx(
        type: 'credit',
        description: 'Service Payment',
        amount: 85000,
        date: 'Yesterday, 3:12 PM',
      ),
      _Tx(
        type: 'debit',
        description: 'Refund Issued',
        amount: 20000,
        date: 'Jul 9, 11:00 AM',
      ),
    ],
  ),
  _Customer(
    name: 'Chidi Nwachukwu',
    email: 'chidi.nw@yahoo.com',
    phone: '+234 803 987 6543',
    avatar: 'CN',
    tier: 'Silver',
    totalSpent: 1800000,
    totalTransactions: 18,
    lastPaymentDate: _now.subtract(const Duration(hours: 1)),
    transactions: const [
      _Tx(
        type: 'credit',
        description: 'Product Purchase',
        amount: 220000,
        date: 'Today, 8:00 AM',
      ),
      _Tx(
        type: 'credit',
        description: 'Bulk Order',
        amount: 780000,
        date: 'Jul 7, 9:30 AM',
      ),
    ],
  ),
  _Customer(
    name: 'Fatima Bello',
    email: 'fatima.b@outlook.com',
    phone: '+234 706 111 2233',
    avatar: 'FB',
    tier: 'Gold',
    totalSpent: 6200000,
    totalTransactions: 67,
    lastPaymentDate: _now.subtract(const Duration(hours: 3)),
    transactions: const [
      _Tx(
        type: 'credit',
        description: 'Subscription Renewal',
        amount: 500000,
        date: 'Today, 12:00 PM',
      ),
      _Tx(
        type: 'credit',
        description: 'Product Purchase',
        amount: 95000,
        date: 'Jul 9, 6:45 PM',
      ),
    ],
  ),
  _Customer(
    name: 'Emeka Adeyemi',
    email: 'emeka.adeyemi@gmail.com',
    phone: '+234 905 444 5566',
    avatar: 'EA',
    tier: 'Bronze',
    totalSpent: 320000,
    totalTransactions: 5,
    lastPaymentDate: _now.subtract(const Duration(days: 1, hours: 6)),
    transactions: const [
      _Tx(
        type: 'credit',
        description: 'First Purchase',
        amount: 120000,
        date: 'Yesterday, 4:00 PM',
      ),
      _Tx(
        type: 'credit',
        description: 'Second Purchase',
        amount: 200000,
        date: 'Jul 5, 2:00 PM',
      ),
    ],
  ),
  _Customer(
    name: 'Ngozi Eze',
    email: 'ngozi.eze@proton.me',
    phone: '+234 816 777 8899',
    avatar: 'NE',
    tier: 'New',
    totalSpent: 45000,
    totalTransactions: 1,
    lastPaymentDate: _now.subtract(const Duration(days: 2)),
    transactions: const [
      _Tx(
        type: 'credit',
        description: 'First Purchase',
        amount: 45000,
        date: 'Jul 9, 11:00 AM',
      ),
    ],
  ),
  _Customer(
    name: 'Taiwo Hassan',
    email: 'taiwo.h@gmail.com',
    phone: '+234 802 333 4455',
    avatar: 'TH',
    tier: 'Silver',
    totalSpent: 950000,
    totalTransactions: 12,
    lastPaymentDate: _now.subtract(const Duration(days: 4)),
    transactions: const [
      _Tx(
        type: 'credit',
        description: 'Product Purchase',
        amount: 250000,
        date: 'Jul 7, 9:00 AM',
      ),
      _Tx(
        type: 'debit',
        description: 'Refund Issued',
        amount: 30000,
        date: 'Jul 6, 3:00 PM',
      ),
    ],
  ),
  _Customer(
    name: 'Blessing Okonkwo',
    email: 'blessing.ok@gmail.com',
    phone: '+234 811 222 3344',
    avatar: 'BO',
    tier: 'Bronze',
    totalSpent: 180000,
    totalTransactions: 3,
    lastPaymentDate: _now.subtract(const Duration(days: 18)),
    transactions: const [
      _Tx(
        type: 'credit',
        description: 'Product Purchase',
        amount: 80000,
        date: 'Jun 23, 2:00 PM',
      ),
    ],
  ),
  _Customer(
    name: 'Kunle Adeleye',
    email: 'kunle.a@proton.me',
    phone: '+234 809 111 5566',
    avatar: 'KA',
    tier: 'Silver',
    totalSpent: 3100000,
    totalTransactions: 29,
    lastPaymentDate: _now.subtract(const Duration(days: 92)),
    transactions: const [
      _Tx(
        type: 'credit',
        description: 'Bulk Order',
        amount: 900000,
        date: 'Apr 10, 9:00 AM',
      ),
      _Tx(
        type: 'debit',
        description: 'Refund Issued',
        amount: 100000,
        date: 'Mar 30, 4:00 PM',
      ),
    ],
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});
  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  static const _filters = ['All', 'Today', 'This Week', 'This Month', 'Older'];

  List<_Customer> get _filtered {
    final sorted = [..._customers]
      ..sort((a, b) => b.lastPaymentDate.compareTo(a.lastPaymentDate));
    return sorted.where((c) {
      final q = _searchQuery.toLowerCase();
      final matchSearch =
          q.isEmpty ||
          c.name.toLowerCase().contains(q) ||
          c.email.toLowerCase().contains(q);
      final matchBucket =
          _selectedFilter == 'All' || c.recencyBucket == _selectedFilter;
      return matchSearch && matchBucket;
    }).toList();
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {});
  }

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
                child: filtered.isEmpty
                    ? _buildEmptyState(cs)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_search_rounded, size: 64, color: cs.outlineVariant),
          const SizedBox(height: 16),
          Text(
            'No customers found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCustomerSheet(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
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
            _sheetField('Full Name', Icons.person_outline_rounded, cs),
            const SizedBox(height: 16),
            _sheetField('Email Address', Icons.email_outlined, cs),
            const SizedBox(height: 16),
            _sheetField('Phone Number', Icons.phone_outlined, cs),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Save Customer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetField(String label, IconData icon, ColorScheme cs) {
    return TextField(
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

  void _showDetail(BuildContext context, _Customer c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CustomerDetailSheet(customer: c),
    );
  }
}

// ─── Metallic Tier Indicator ─────────────────────────────────────────────────

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

// ─── Premium Customer Row ────────────────────────────────────────────────────

class _CustomerRow extends StatelessWidget {
  final _Customer customer;
  final VoidCallback onTap;
  const _CustomerRow({required this.customer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tc = _getTierColor(customer.tier);

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
                        customer.avatar,
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
                        customer.email,
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
                      '₦${(customer.totalSpent / 1000).toStringAsFixed(0)}k',
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

  Color _getTierColor(String tier) {
    if (tier == 'Gold') return const Color(0xFFE6A817);
    if (tier == 'Silver') return const Color(0xFF8E9AAB);
    return const Color(0xFFB87333);
  }
}

// ─── Customer Detail Sheet ─────────────────────────────────────────────────────

class _CustomerDetailSheet extends StatefulWidget {
  final _Customer customer;
  const _CustomerDetailSheet({required this.customer});
  @override
  State<_CustomerDetailSheet> createState() => _CustomerDetailSheetState();
}

class _CustomerDetailSheetState extends State<_CustomerDetailSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
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
                    c.avatar,
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
                        c.email,
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
              children: [_history(c, cs), _info(c, cs)],
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

  Widget _history(_Customer c, ColorScheme cs) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: c.transactions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final tx = c.transactions[i];
        final isCredit = tx.type == 'credit';
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
                      tx.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      tx.date,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₦${tx.amount.toStringAsFixed(0)}',
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

  Widget _info(_Customer c, ColorScheme cs) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _infoRow('Phone Number', c.phone, cs),
        _infoRow('Customer Tier', c.tier, cs),
        _infoRow('Total Transactions', '${c.totalTransactions} items', cs),
        _infoRow(
          'Account Balance',
          '₦${(c.totalSpent / 10).toStringAsFixed(0)}',
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
