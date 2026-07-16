import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class CashReceiptsScreen extends StatefulWidget {
  const CashReceiptsScreen({super.key});

  @override
  State<CashReceiptsScreen> createState() => _CashReceiptsScreenState();
}

class _CashReceiptsScreenState extends State<CashReceiptsScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedCategory = 'General';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'General', 'icon': Icons.grid_view_rounded},
    {'name': 'Food', 'icon': Icons.restaurant_rounded},
    {'name': 'Fashion', 'icon': Icons.checkroom_rounded},
    {'name': 'Services', 'icon': Icons.handyman_rounded},
    {'name': 'Other', 'icon': Icons.more_horiz_rounded},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _itemController.dispose();
    _customerController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Cash Receipt",
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.history_rounded),
            tooltip: "History",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: GlassSurface(
                borderRadius: BorderRadius.circular(30),
                opacity: 0.14,
                blur: 16,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Record a cash sale',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Create a clean receipt with a clear amount and item description.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GlassSurface(
                  borderRadius: BorderRadius.circular(28),
                  opacity: 0.14,
                  blur: 16,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total sale amount',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                          color: cs.onSurfaceVariant.withValues(alpha: 0.55),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'XAF',
                            style: GoogleFonts.plusJakartaSans(
                              color: cs.onSurfaceVariant,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1.2,
                              ),
                              decoration: InputDecoration(
                                hintText: '0',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  color: cs.onSurfaceVariant.withValues(
                                    alpha: 0.3,
                                  ),
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Category',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 88,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat['name'];
                      final accent = isSelected ? cs.primary : cs.secondary;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() => _selectedCategory = cat['name']);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: GlassSurface(
                            borderRadius: BorderRadius.circular(20),
                            opacity: isSelected ? 0.18 : 0.10,
                            blur: 12,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border: Border.all(
                              color: accent.withValues(alpha: 0.16),
                            ),
                            child: SizedBox(
                              width: 72,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 38,
                                    width: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: LinearGradient(
                                        colors: [
                                          accent.withValues(alpha: 0.22),
                                          accent.withValues(alpha: 0.10),
                                        ],
                                      ),
                                    ),
                                    child: Icon(
                                      cat['icon'],
                                      color: accent,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    cat['name'],
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: isSelected
                                          ? cs.onSurface
                                          : cs.onSurfaceVariant,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Receipt details',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),
                GlassSurface(
                  borderRadius: BorderRadius.circular(28),
                  opacity: 0.12,
                  blur: 14,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _FieldRow(
                        label: 'Item or service',
                        hint: 'e.g. Graphic design',
                        controller: _itemController,
                        icon: Icons.shopping_bag_outlined,
                      ),
                      const SizedBox(height: 14),
                      _FieldRow(
                        label: 'Customer name',
                        hint: 'Optional',
                        controller: _customerController,
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 14),
                      _FieldRow(
                        label: 'Note',
                        hint: 'Add a short receipt note',
                        controller: _noteController,
                        icon: Icons.sticky_note_2_outlined,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassSurface(
                  borderRadius: BorderRadius.circular(24),
                  opacity: 0.12,
                  blur: 12,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Receipt summary',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _SummaryRow(label: 'Category', value: _selectedCategory),
                      _SummaryRow(label: 'Payment mode', value: 'Cash'),
                      _SummaryRow(
                        label: 'Status',
                        value: 'Ready to generate',
                        valueColor: cs.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.receipt_long_rounded),
                    label: Text(
                      'Generate receipt',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final int maxLines;

  const _FieldRow({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: cs.primary.withValues(alpha: 0.75)),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: cs.onSurfaceVariant.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: cs.onSurfaceVariant.withValues(alpha: 0.35),
            ),
            filled: true,
            fillColor: cs.surface.withValues(alpha: 0.06),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.14),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.14),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: cs.primary, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: valueColor ?? cs.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
