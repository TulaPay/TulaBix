import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      _Tx(type: 'credit', description: 'Product Purchase', amount: 150000, date: 'Today, 10:24 AM'),
      _Tx(type: 'credit', description: 'Service Payment', amount: 85000, date: 'Yesterday, 3:12 PM'),
      _Tx(type: 'debit', description: 'Refund Issued', amount: 20000, date: 'Jul 9, 11:00 AM'),
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
      _Tx(type: 'credit', description: 'Product Purchase', amount: 220000, date: 'Today, 8:00 AM'),
      _Tx(type: 'credit', description: 'Bulk Order', amount: 780000, date: 'Jul 7, 9:30 AM'),
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
      _Tx(type: 'credit', description: 'Subscription Renewal', amount: 500000, date: 'Today, 12:00 PM'),
      _Tx(type: 'credit', description: 'Product Purchase', amount: 95000, date: 'Jul 9, 6:45 PM'),
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
      _Tx(type: 'credit', description: 'First Purchase', amount: 120000, date: 'Yesterday, 4:00 PM'),
      _Tx(type: 'credit', description: 'Second Purchase', amount: 200000, date: 'Jul 5, 2:00 PM'),
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
      _Tx(type: 'credit', description: 'First Purchase', amount: 45000, date: 'Jul 9, 11:00 AM'),
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
      _Tx(type: 'credit', description: 'Product Purchase', amount: 250000, date: 'Jul 7, 9:00 AM'),
      _Tx(type: 'debit', description: 'Refund Issued', amount: 30000, date: 'Jul 6, 3:00 PM'),
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
      _Tx(type: 'credit', description: 'Product Purchase', amount: 80000, date: 'Jun 23, 2:00 PM'),
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
      _Tx(type: 'credit', description: 'Bulk Order', amount: 900000, date: 'Apr 10, 9:00 AM'),
      _Tx(type: 'debit', description: 'Refund Issued', amount: 100000, date: 'Mar 30, 4:00 PM'),
    ],
  ),
];

// ─── Custom Background Pattern ───────────────────────────────────────────────

class _GeometricPatternPainter extends CustomPainter {
  final Color color;
  _GeometricPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var i = 0.0; i < size.width; i += 40) {
      for (var j = 0.0; j < size.height; j += 40) {
        canvas.drawCircle(Offset(i, j), 2, paint);
        if ((i + j) % 80 == 0) {
          canvas.drawRect(Rect.fromLTWH(i, j, 15, 15), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          // The Subtle Geometric Wallpaper
          Positioned.fill(child: CustomPaint(painter: _GeometricPatternPainter(cs.primary))),
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(cs),
                // _buildMetricStrip(cs),
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
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, i) {
                              final c = filtered[i];
                              return _CustomerRow(
                                customer: c,
                                onTap: () => _showDetail(context, c),
                              ).animate().fadeIn(delay: (i * 40).ms).slideX(begin: 0.02);
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showAddCustomerSheet(context),
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DIRECTORY',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 10, fontWeight: FontWeight.w800, color: cs.primary, letterSpacing: 1.5)),
              Text('Customers',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 28, fontWeight: FontWeight.w800, color: cs.onSurface, letterSpacing: -1)),
            ],
          ),
          Row(
            children: [
              _circleIconButton(Icons.ios_share_rounded, cs, () {}),
              const SizedBox(width: 12),
              _circleIconButton(Icons.tune_rounded, cs, () {}),
            ],
          )
        ],
      ),
    );
  }

  Widget _circleIconButton(IconData icon, ColorScheme cs, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        shape: BoxShape.circle,
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(color: cs.shadow.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: cs.onSurface),
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildMetricStrip(ColorScheme cs) {
    final totalRev = _customers.fold(0.0, (s, c) => s + c.totalSpent);
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          _StatCard(label: 'Customers', value: '${_customers.length}', icon: Icons.people_outline_rounded, color: Colors.blueAccent),
          _StatCard(label: 'Revenue', value: '₦${(totalRev / 1000000).toStringAsFixed(1)}M', icon: Icons.account_balance_wallet_outlined, color: Colors.teal),
          _StatCard(label: 'Growth', value: '+12.5%', icon: Icons.auto_graph_rounded, color: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: cs.shadow.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 8)),
              ],
              ),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: GoogleFonts.plusJakartaSans(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: Icon(Icons.search_rounded, color: cs.onSurfaceVariant, size: 20),
                filled: true,
                fillColor: cs.surfaceContainerHigh,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((f) {
                final sel = _selectedFilter == f;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = f),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? cs.onSurface : cs.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: sel ? null : Border.all(color: cs.outlineVariant),
                      boxShadow: sel ? [BoxShadow(color: cs.shadow.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))] : null,
                    ),
                    child: Text(f,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: sel ? cs.surface : cs.onSurfaceVariant,
                            fontWeight: sel ? FontWeight.w700 : FontWeight.w600)),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
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
                    decoration: BoxDecoration(color: cs.outlineVariant, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text('New Customer', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 24, color: cs.onSurface)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cs.outlineVariant)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cs.outlineVariant)),
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

// ─── Premium Metric Card ─────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 156,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(color: cs.shadow.withValues(alpha: 0.04), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10, bottom: -10,
            child: Icon(icon, size: 80, color: color.withValues(alpha: 0.03)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Spacer(),
                Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: cs.onSurface)),
                Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: cs.onSurfaceVariant, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
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
      width: 14, height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color, color.withValues(alpha: 0.8), color.withValues(alpha: 0.6)],
        ),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4, offset: const Offset(0, 2)),
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
    
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: cs.shadow.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
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
                      child: Text(customer.avatar, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: tc, fontSize: 13)),
                    ),
                    Positioned(right: 0, bottom: 0, child: _TierDot(color: tc)),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customer.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 15, color: cs.onSurface)),
                      Text(customer.email, style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontSize: 13)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('₦${(customer.totalSpent / 1000).toStringAsFixed(0)}k', 
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 15, color: cs.onSurface)),
                    Text(customer.lastSeenLabel, 
                      style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w600)),
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

class _CustomerDetailSheetState extends State<_CustomerDetailSheet> with SingleTickerProviderStateMixin {
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

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: cs.outlineVariant, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 32,
                    backgroundColor: cs.surfaceContainerHigh,
                    child: Text(c.avatar,
                        style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w800, color: cs.onSurface))),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name,
                          style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: cs.onSurface)),
                      Text(c.email, style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontSize: 14)),
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
            labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13),
            tabs: const [Tab(text: 'Transactions'), Tab(text: 'Customer Info')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _history(c, cs),
                _info(c, cs),
              ],
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),
    );
  }

  Widget _circleAction(IconData icon, ColorScheme cs) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        shape: BoxShape.circle,
        border: Border.all(color: cs.outlineVariant),
      ),
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
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Icon(isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: isCredit ? Colors.green : Colors.redAccent, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx.description,
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14, color: cs.onSurface)),
                    Text(tx.date, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
              Text(
                '₦${tx.amount.toStringAsFixed(0)}',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, color: cs.onSurface),
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
        _infoRow('Account Balance', '₦${(c.totalSpent / 10).toStringAsFixed(0)}', cs),
        const SizedBox(height: 24),
        Text('Internal Notes', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14, color: cs.onSurface)),
        const SizedBox(height: 12),
        TextField(
          maxLines: 3,
          style: TextStyle(color: cs.onSurface),
          decoration: InputDecoration(
            hintText: 'Add a private note about this customer...',
            hintStyle: TextStyle(color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
            filled: true,
            fillColor: cs.surfaceContainerLow,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
          Text(label, style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.w600)),
          Text(value, style: GoogleFonts.plusJakartaSans(color: cs.onSurface, fontSize: 13, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
