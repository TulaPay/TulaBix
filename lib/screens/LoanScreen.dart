import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─── Custom Background Pattern ───────────────────────────────────────────────

class _GeometricPatternPainter extends CustomPainter {
  final Color color;
  _GeometricPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.015)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var i = 0.0; i < size.width; i += 50) {
      for (var j = 0.0; j < size.height; j += 50) {
        canvas.drawCircle(Offset(i, j), 1.5, paint);
        if ((i + j) % 100 == 0) {
          canvas.drawRect(Rect.fromLTWH(i, j, 12, 12), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class Loanscreen extends StatefulWidget {
  const Loanscreen({super.key});

  @override
  State<Loanscreen> createState() => _LoanscreenState();
}

class _LoanscreenState extends State<Loanscreen> {
  bool _hasActiveLoan = false; 
  bool _isSubmitting = false;

  // Controllers for hybrid inputs
  late TextEditingController _principalController;
  late TextEditingController _purposeController;
  late TextEditingController _durationController;
  late TextEditingController _mechanismController;

  @override
  void initState() {
    super.initState();
    _principalController = TextEditingController(text: '5,000,000 FCFA');
    _purposeController = TextEditingController(text: 'Stock Expansion (Pre-populate Inventory)');
    _durationController = TextEditingController(text: '12 Months');
    _mechanismController = TextEditingController(text: 'Daily Split Settlement (Automated 3.73%)');
  }

  @override
  void dispose() {
    _principalController.dispose();
    _purposeController.dispose();
    _durationController.dispose();
    _mechanismController.dispose();
    super.dispose();
  }

  void _simulateSubmission() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    
    setState(() => _isSubmitting = true);
    
    // Simulate high-end vetting process
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _hasActiveLoan = true;
      });
      _showSuccessFeedback();
    }
  }

  void _showSuccessFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Application Approved & Funded!', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.teal.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSelectionSheet({
    required String title,
    required List<String> options,
    required String currentValue,
    required Function(String) onSelect,
  }) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            ...options.map((opt) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(opt, style: GoogleFonts.plusJakartaSans(fontWeight: opt == currentValue ? FontWeight.w800 : FontWeight.w500)),
              trailing: opt == currentValue ? Icon(Icons.check_circle, color: cs.primary) : null,
              onTap: () {
                onSelect(opt);
                Navigator.pop(ctx);
              },
            )),
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
          Positioned.fill(
            child: CustomPaint(
              painter: _GeometricPatternPainter(cs.primary),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, cs),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: _isSubmitting 
                      ? _buildVettingState(cs)
                      : (_hasActiveLoan ? _buildActiveLoanView(cs) : _buildLoanApplicationView(cs)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: cs.onSurface),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          Text(
            _hasActiveLoan ? 'Loan Status' : 'Lending Gateway',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          if (!_isSubmitting)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _hasActiveLoan = !_hasActiveLoan),
                child: Text(
                  _hasActiveLoan ? 'Apply' : 'Status',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  // ─── Vetting/Processing State ──────────────────────────────────────────────

  Widget _buildVettingState(ColorScheme cs) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            strokeWidth: 8,
            color: cs.primary,
            backgroundColor: cs.primary.withValues(alpha: 0.1),
            strokeCap: StrokeCap.round,
          ),
        ).animate(onPlay: (controller) => controller.repeat())
         .shimmer(duration: 2000.ms, color: Colors.white24),
        const SizedBox(height: 40),
        Text(
          'Vetting Application...',
          style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: cs.onSurface),
        ),
        const SizedBox(height: 12),
        Text(
          'Our Institutional AI is analyzing your verified ledger performance for instant disbursement.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500, color: cs.onSurfaceVariant, height: 1.5),
        ),
      ],
    ).animate().fadeIn();
  }

  // ─── Loan Application View ─────────────────────────────────────────────────

  Widget _buildLoanApplicationView(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'GOODWILL LENDING GATEWAY',
              style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.teal, letterSpacing: 1.5),
            ),
            Text(
              '02:40 PM',
              style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: cs.onSurfaceVariant),
            ),
          ],
        ).animate().fadeIn(),
        const SizedBox(height: 16),
        Text('Alternative Credit Portal', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800, color: cs.onSurface, letterSpacing: -1.2)),
        const SizedBox(height: 8),
        Text(
          'Based on 3 months of verified ledger performance, you have unlocked access to immediate institutional backing.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500, color: cs.onSurfaceVariant, height: 1.5),
        ),
        const SizedBox(height: 32),
        
        _buildHybridField(
          label: 'REQUESTED LOAN PRINCIPAL',
          controller: _principalController,
          trailing: 'Eligible up to 5,000,000',
          sheetTitle: 'Loan Principal',
          options: ['1,000,000 FCFA', '2,500,000 FCFA', '5,000,000 FCFA'],
          cs: cs,
        ),
        
        const SizedBox(height: 24),
        _buildHybridField(
          label: 'LOAN ALLOCATION PURPOSE',
          controller: _purposeController,
          sheetTitle: 'Allocation Purpose',
          options: ['Stock Expansion', 'Equipment Purchase', 'Marketing Campaign', 'Operations'],
          cs: cs,
        ),

        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildHybridField(
                label: 'TERM DURATION',
                controller: _durationController,
                sheetTitle: 'Term Duration',
                options: ['3 Months', '6 Months', '12 Months', '24 Months'],
                cs: cs,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('INTEREST RATE', cs),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('1.2%', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w900, color: cs.onSurface)),
                        const SizedBox(width: 4),
                        Text('flat/mo', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
        _buildHybridField(
          label: 'REPAYMENT SETTLEMENT MECHANISM',
          controller: _mechanismController,
          sheetTitle: 'Repayment Mechanism',
          options: ['Daily Split (Automated 3.73%)', 'Weekly Split (Automated 12.5%)', 'Monthly Bulk (Automated)'],
          cs: cs,
        ),
        
        const SizedBox(height: 12),
        Text(
          '*TulaPay automatically deducts payments at swipe; no manual ledger friction!',
          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.teal),
        ),

        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.orange.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: ElevatedButton(
              onPressed: _simulateSubmission,
              style: ElevatedButton.styleFrom(
                backgroundColor:  Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: Text('Submit Loan Application', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  // ─── Active Loan View ──────────────────────────────────────────────────────

  Widget _buildActiveLoanView(ColorScheme cs) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.auto_awesome_outlined, color: Colors.teal, size: 40),
        ).animate().scale(duration: 400.ms, curve: Curves.bounceOut),
        const SizedBox(height: 24),
        Text('Congratulations!', style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w900, color: cs.onSurface, letterSpacing: -1.0)),
        const SizedBox(height: 8),
        Text(
          'Your financing application has been officially vetted and funded by Goodwill Financial House.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w500, color: cs.onSurfaceVariant, height: 1.5),
        ),
        const SizedBox(height: 40),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
            boxShadow: [BoxShadow(color: cs.shadow.withValues(alpha: 0.04), blurRadius: 24, offset: const Offset(0, 12))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('FINANCED FACILITY', cs),
                  _buildBadge('Active', Colors.green, cs),
                ],
              ),
              const SizedBox(height: 4),
              Text(_purposeController.text, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: cs.onSurface)),
              const SizedBox(height: 32),
              _buildLabel('LOAN PRINCIPAL', cs),
              const SizedBox(height: 8),
              Text(_principalController.text, style: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.teal.shade700, letterSpacing: -0.5)),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('OUTSTANDING BALANCE', cs),
                        const SizedBox(height: 4),
                        Text(_principalController.text, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('REPAYMENT MECHANISM', cs),
                        const SizedBox(height: 4),
                        Text(_mechanismController.text.split('(')[0], style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.orange.shade800)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05),

        const SizedBox(height: 24),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cs.primary.withValues(alpha: 0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.account_balance_outlined, color: Colors.teal, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Funds Disbursed to Mobile Wallet', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface)),
                    const SizedBox(height: 4),
                    Text(
                      'The ${_principalController.text} is ready in your mobile cash balance to purchase goods. Automated micro-settlements will begin seamlessly on your next sales transaction.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500, color: cs.onSurfaceVariant, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05),

        const SizedBox(height: 40),
        _buildActionLink('View Repayment Schedule', cs),
        const SizedBox(height: 40),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  // ─── Helper Widgets ────────────────────────────────────────────────────────

  Widget _buildLabel(String text, ColorScheme cs) {
    return Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w900, color: cs.onSurfaceVariant.withValues(alpha: 0.5), letterSpacing: 1.2));
  }

  Widget _buildBadge(String text, Color color, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, color: color, size: 14),
          const SizedBox(width: 4),
          Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }

  Widget _buildHybridField({
    required String label,
    required TextEditingController controller,
    String? trailing,
    required List<String> options,
    required String sheetTitle,
    required ColorScheme cs,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel(label, cs),
            if (trailing != null) 
              Text(trailing, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.teal)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: cs.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: cs.onSurfaceVariant),
              onPressed: () => _showSelectionSheet(
                title: sheetTitle,
                options: options,
                currentValue: controller.text,
                onSelect: (v) => setState(() => controller.text = v),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionLink(String text, ColorScheme cs) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: cs.primary)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_rounded, size: 16, color: cs.primary),
          ],
        ),
      ),
    );
  }
}
