import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';

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

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({super.key});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  void _showInsightBottomSheet(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      backgroundColor: cs.surface,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 32, height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lightbulb_rounded, color: cs.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  'Cost Reduction Tip',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800, fontSize: 20, letterSpacing: -0.5,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'You are sending SMS notifications for every transaction. Switching to push notifications (in-app) would reduce SMS costs by approximately ₦12,000 per month.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15, color: cs.onSurfaceVariant, height: 1.6, fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                style: FilledButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Got it',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          // The Subtle Geometric Wallpaper
          Positioned.fill(child: CustomPaint(painter: _GeometricPatternPainter(cs.primary))),
          
          // Premium Background Branded Decorations (Refined)
          Positioned(
            top: 50, right: -80,
            child: Opacity(
              opacity: 0.05,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Image.asset('assets/images/TULAPAYICON_SVG.png', width: 350, color: cs.primary),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(cs),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    color: cs.primary,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHealthScoreCard(context)
                              .animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, curve: Curves.easeOut),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildMonthlyGrowthCard(context)
                                    .animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.05),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _buildRetentionCard(context)
                                    .animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.05),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildProfitabilityCard(context)
                              .animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.05),
                          const SizedBox(height: 40),
                          Text(
                            'Operational Efficiency',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              color: cs.onSurface,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                          const SizedBox(height: 16),
                          _buildOperationalEfficiencyCard(context)
                              .animate().fadeIn(duration: 400.ms, delay: 450.ms).slideY(begin: 0.05),
                          const SizedBox(height: 40),
                          Text(
                            'Top Channels',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              color: cs.onSurface,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
                          const SizedBox(height: 16),
                          _buildTopChannelsCard(context)
                              .animate().fadeIn(duration: 400.ms, delay: 550.ms).slideY(begin: 0.05),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
              Text('ANALYTICS',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 10, fontWeight: FontWeight.w800, color: cs.primary, letterSpacing: 1.5)),
              Text('Business',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 28, fontWeight: FontWeight.w800, color: cs.onSurface, letterSpacing: -1)),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: cs.surface,
              shape: BoxShape.circle,
              border: Border.all(color: cs.outlineVariant),
              boxShadow: [
                BoxShadow(color: cs.shadow.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.ios_share_rounded, size: 20),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting Business Report...'), behavior: SnackBarBehavior.floating),
                );
              },
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              padding: EdgeInsets.zero,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child, IconData? watermarkIcon}) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
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
          if (watermarkIcon != null)
            Positioned(
              right: -10, bottom: -10,
              child: Icon(watermarkIcon, size: 100, color: cs.primary.withValues(alpha: 0.02)),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthScoreCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return _buildCard(
      context,
      watermarkIcon: Icons.health_and_safety_outlined,
      child: Column(
        children: [
          Text(
            'HEALTH SCORE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: cs.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: 270,
                    sectionsSpace: 0,
                    centerSpaceRadius: 58,
                    sections: [
                      PieChartSectionData(color: cs.primary, value: 85, title: '', radius: 12),
                      PieChartSectionData(color: cs.primary.withValues(alpha: 0.1), value: 15, title: '', radius: 12),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '85',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 40,
                          color: cs.primary,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'Excellent',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your business is in the top 12% of\nmerchants in your region.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyGrowthCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return _buildCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: cs.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(Icons.trending_up_rounded, color: cs.primary, size: 16),
              ),
              Text(
                '+14.2%',
                style: GoogleFonts.plusJakartaSans(color: cs.primary, fontWeight: FontWeight.w800, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 30,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [FlSpot(0, 1), FlSpot(1, 1.5), FlSpot(2, 1.2), FlSpot(3, 2.5), FlSpot(4, 2.2), FlSpot(5, 3.5)],
                    isCurved: true,
                    color: cs.primary,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: cs.primary.withValues(alpha: 0.1)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'GROWTH',
            style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontWeight: FontWeight.w700, letterSpacing: 0.5, fontSize: 10),
          ),
          Text(
            '₦ 2.4M',
            style: GoogleFonts.plusJakartaSans(color: cs.onSurface, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildRetentionCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return _buildCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: cs.secondary.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(Icons.people_outline_rounded, color: cs.secondary, size: 16),
              ),
              Text(
                '92%',
                style: GoogleFonts.plusJakartaSans(color: cs.secondary, fontWeight: FontWeight.w800, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 30,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [FlSpot(0, 3), FlSpot(1, 2.8), FlSpot(2, 3.2), FlSpot(3, 3.5), FlSpot(4, 3.9), FlSpot(5, 4.0)],
                    isCurved: true,
                    color: cs.secondary,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: cs.secondary.withValues(alpha: 0.1)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'RETENTION',
            style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontWeight: FontWeight.w700, letterSpacing: 0.5, fontSize: 10),
          ),
          Text(
            'Loyal',
            style: GoogleFonts.plusJakartaSans(color: cs.onSurface, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildProfitabilityCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return _buildCard(
      context,
      watermarkIcon: Icons.account_balance_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profitability',
            style: GoogleFonts.plusJakartaSans(color: cs.onSurface, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: -0.5),
          ),
          const SizedBox(height: 24),
          _buildProgressRow(context, 'Net Margin', '28% Target met', 0.65, cs.primary),
          const SizedBox(height: 20),
          _buildProgressRow(context, 'Operating Costs', '₦ 450K', 0.4, cs.secondary),
          const SizedBox(height: 32),
          InkWell(
            onTap: () => _showInsightBottomSheet(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.primary.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded, color: cs.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Reducing SMS alerts could save you ₦ 12k monthly. Tap for info.',
                      style: GoogleFonts.plusJakartaSans(color: cs.onSurface, fontSize: 12, fontWeight: FontWeight.w600, height: 1.4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded, color: cs.primary, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(BuildContext context, String label, String valueLabel, double value, Color activeColor) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.w600)),
            Text(valueLabel, style: GoogleFonts.plusJakartaSans(color: cs.onSurface, fontSize: 12, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: activeColor.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(activeColor),
          ),
        ),
      ],
    );
  }

  Widget _buildOperationalEfficiencyCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final barHeights = [20.0, 30.0, 25.0, 40.0, 25.0, 25.0, 25.0];

    return _buildCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROCESSING SPEED',
            style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontWeight: FontWeight.w700, letterSpacing: 0.5, fontSize: 10),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '1.2s',
                style: GoogleFonts.plusJakartaSans(color: cs.onSurface, fontWeight: FontWeight.w900, fontSize: 28, letterSpacing: -1),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text('avg.', style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontWeight: FontWeight.w600, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 60,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: false),
                barGroups: List.generate(barHeights.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: barHeights[index],
                        color: cs.primary,
                        width: 24,
                        borderRadius: BorderRadius.circular(6),
                        backDrawRodData: BackgroundBarChartRodData(show: true, toY: 40, color: cs.primary.withValues(alpha: 0.05)),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopChannelsCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(color: cs.shadow.withValues(alpha: 0.04), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCC00),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFFFCC00).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Center(
                    child: Text('MTN', style: GoogleFonts.plusJakartaSans(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MTN Mobile Money', style: GoogleFonts.plusJakartaSans(color: cs.onSurface, fontWeight: FontWeight.w800, fontSize: 16)),
                      Text('428 transactions this month', style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontWeight: FontWeight.w500, fontSize: 13)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('54%', style: GoogleFonts.plusJakartaSans(color: cs.primary, fontWeight: FontWeight.w900, fontSize: 20)),
                    Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant.withValues(alpha: 0.4), size: 20),
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
