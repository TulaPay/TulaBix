import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/screens/cash_receipts_screen.dart';
import 'package:tulapay/screens/more_actions_screen.dart';
import 'package:tulapay/screens/payment_links_screen.dart';
import 'package:tulapay/screens/scan_qr_screen.dart';
import 'package:tulapay/widgets/custom_drawer.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class Homepage extends StatefulWidget {
  final ValueChanged<bool>? onDrawerChanged;

  const Homepage({super.key, this.onDrawerChanged});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final balanceCardOpacity = isDark ? 0.18 : 0.10;
    final balanceCardBlur = isDark ? 18.0 : 12.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      onDrawerChanged: widget.onDrawerChanged,
      appBar: AppBar(
        title: Text(
          "TulaBiz",
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -1,
          ),
        ),
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.notes_rounded,
              color: colorScheme.onSurface,
              size: 28,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          _AppBarAction(icon: Icons.notifications_none_rounded, onTap: () {}),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: GlassSurface(
                borderRadius: BorderRadius.circular(30),
                opacity: balanceCardOpacity,
                blur: balanceCardBlur,
                tint: isDark
                    ? colorScheme.surface
                    : colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.14)
                      : colorScheme.outline.withValues(alpha: 0.10),
                ),
                padding: const EdgeInsets.all(1),
                child: RevenueCard(
                  colorScheme: colorScheme,
                  isBalanceVisible: _isBalanceVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isBalanceVisible = !_isBalanceVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
              child: _SectionHeader(
                title: "Quick Actions",
                action: "More",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MoreActionsScreen()),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildQuickAction(
                    context,
                    icon: Icons.link,
                    label: "Payment Links",
                    color: const Color(0xFF6366F1),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PaymentLinksScreen(),
                      ),
                    ),
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.qr_code_scanner_rounded,
                    label: "Scan Qr",
                    color: const Color(0xFFF59E0B),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScanQrScreen()),
                    ),
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.receipt_long_outlined,
                    label: "Cash Receipts",
                    color: const Color(0xFFEC4899),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CashReceiptsScreen(),
                      ),
                    ),
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.grid_view_rounded,
                    label: "More",
                    color: colorScheme.secondary,
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
              child: GlassSurface(
                borderRadius: BorderRadius.circular(24),
                opacity: 0.12,
                blur: 12,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: _SectionHeader(
                  title: "Recent Activity",
                  action: "All",
                  onTap: () {},
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            sliver: SliverList.separated(
              itemCount: _transactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final tx = _transactions[index];
                final isIncome = tx['isIncome'] as bool;
                return _ActivityCard(
                  title: tx['name'] as String,
                  date: tx['date'] as String,
                  amount: tx['amount'] as String,
                  image: tx['image'] as String,
                  isIncome: isIncome,
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 112)),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GlassSurface(
        borderRadius: BorderRadius.circular(20),
        opacity: 0.14,
        blur: 14,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.26),
                        color.withValues(alpha: 0.12),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 22, color: color),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RevenueCard extends StatelessWidget {
  const RevenueCard({
    super.key,
    required this.colorScheme,
    required this.isBalanceVisible,
    required this.onToggleVisibility,
  });

  final ColorScheme colorScheme;
  final bool isBalanceVisible;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.84),
            colorScheme.secondary.withValues(alpha: 0.74),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.14),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Main Balance",
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: onToggleVisibility,
                              child: Icon(
                                isBalanceVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white54,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "XAF",
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white60,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isBalanceVisible ? "2,450,000" : "••••••••",
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                letterSpacing: isBalanceVisible ? -1 : 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.wallet_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                GlassSurface(
                  borderRadius: BorderRadius.circular(20),
                  opacity: 0.12,
                  blur: 10,
                  padding: const EdgeInsets.all(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _MiniMetric(
                          title: "Today's Profit",
                          value: isBalanceVisible
                              ? "+ XAF 12,500"
                              : "+ XAF ••••",
                          valueColor: const Color(0xFFB6F2D3),
                        ),
                      ),
                      Container(height: 30, width: 1, color: Colors.white24),
                      Expanded(
                        child: _MiniMetric(
                          title: "Invoices Sent",
                          value: "24 Active",
                          valueColor: Colors.white,
                        ),
                      ),
                      Container(height: 30, width: 1, color: Colors.white24),
                      Expanded(
                        child: _MiniMetric(
                          title: "Avg. Ticket",
                          value: "XAF 8,200",
                          valueColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const _MiniMetric({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              color: valueColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;

  const _SectionHeader({required this.title, this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: -0.5,
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onTap,
            child: Text(
              action!,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final String image;
  final bool isIncome;

  const _ActivityCard({
    required this.title,
    required this.date,
    required this.amount,
    required this.image,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accent = isIncome ? const Color(0xFF10B981) : colorScheme.secondary;

    return GlassSurface(
      borderRadius: BorderRadius.circular(28),
      opacity: 0.15,
      blur: 18,
      padding: const EdgeInsets.all(14),
      border: Border.all(
        color: accent.withValues(alpha: 0.12),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -18,
            child: Container(
              height: 92,
              width: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accent.withValues(alpha: 0.14),
                    accent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0.28),
                      accent.withValues(alpha: 0.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.account_balance_wallet_rounded,
                      color: accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.68),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            isIncome ? 'Income' : 'Expense',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isIncome ? 'Completed' : 'Processed',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: isIncome ? accent : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Icon(
                    isIncome ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                    size: 18,
                    color: accent.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const _transactions = [
  {
    'name': 'MTN Mobile Money',
    'date': 'Today, 14:20',
    'amount': '+ XAF 25,000',
    'image': 'assets/images/mtn.jpeg',
    'isIncome': true,
  },
  {
    'name': 'Mastercard Payment',
    'date': 'Today, 12:45',
    'amount': '- XAF 4,500',
    'image': 'assets/images/mastercard.jpeg',
    'isIncome': false,
  },
  {
    'name': 'Subscription Refill',
    'date': 'Yesterday, 09:20',
    'amount': '- XAF 1,200',
    'image': 'assets/images/card.png',
    'isIncome': false,
  },
];

class _AppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AppBarAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.16),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: colorScheme.onSurface, size: 22),
        ),
      ),
    );
  }
}
