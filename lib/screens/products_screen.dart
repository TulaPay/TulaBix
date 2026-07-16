import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/models/product_model.dart'; // Ensure your model is imported
import 'package:tulapay/widgets/product_detail_sheet.dart';
import 'package:tulapay/screens/add_product_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with SingleTickerProviderStateMixin {
  late List<Product> _all;
  late List<Product> _filteredProducts;
  String _activeCategory = 'All';
  String _searchQuery = '';
  bool _isGrid = true;
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _categories = [
    'All',
    'Electronics',
    'Food & Drinks',
    'Clothing',
    'Home & Office',
  ];

  @override
  void initState() {
    super.initState();
    _all = List.from(mockProducts);
    _updateFilters();
  }

  void _updateFilters() {
    _filteredProducts = _all.where((p) {
      final catOk = _activeCategory == 'All' || p.category == _activeCategory;
      final searchOk =
          _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return catOk && searchOk;
    }).toList();
  }

  // Formatting helpers
  String _formatCurrency(double value) {
    return NumberFormat.currency(
      symbol: 'XAF ',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Premium Background Branded Decorations
          Positioned(
            top: 150,
            right: -80,
            child: Opacity(
              opacity: 0.06,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Image.asset(
                  'assets/images/TULAPAYICON_SVG.png',
                  width: 350,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -60,
            child: Opacity(
              opacity: 0.04,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Image.asset(
                  'assets/images/TULAPAYICON_SVG.png',
                  width: 250,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              _buildAppBar(context, theme),
              _buildSearchBar(context, theme),
              _buildTopStats(context, theme),
              _buildAlertsHeader(context, theme),
              _buildHorizontalAlerts(context, theme),
              _buildFilterBar(context, theme),
              _buildProductSection(context, theme),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ],
      ),
      floatingActionButton: _buildFab(context, theme),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 1. Premium Sliver App Bar
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return SliverAppBar(
      expandedHeight: 140,
      collapsedHeight: 70,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
      leadingWidth: 60,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: _CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onPressed: () => Navigator.of(context).pop(),
            theme: theme,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1.2,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16, right: 20),
        background: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Stack(
              children: [
                Positioned(
                  right: 20,
                  bottom: 40,
                  child: Opacity(
                    opacity: 0.08,
                    child: Image.asset(
                      'assets/images/TULAPAYICON_SVG.png',
                      width: 120,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            final isExpanded = constraints.maxHeight > 100;
            return Padding(
              padding: EdgeInsets.only(left: isExpanded ? 0 : 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isExpanded) ...[
                        Image.asset(
                          'assets/images/TULAPAYICON_SVG.png',
                          height: 20,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        'Products',
                        style: GoogleFonts.plusJakartaSans(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_all.length} Products tracking',
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: const [],
    );
  }

  Widget _buildSearchBar(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: TextField(
          controller: _searchCtrl,
          onChanged: (val) => setState(() {
            _searchQuery = val;
            _updateFilters();
          }),
          style: GoogleFonts.plusJakartaSans(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Search products by name...',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() {
                        _searchQuery = '';
                        _updateFilters();
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: theme.colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 2. High-Density Stats Layout
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildTopStats(BuildContext context, ThemeData theme) {
    final successColor = const Color(0xFF10B981);
    final errorColor = theme.colorScheme.error;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            _StatCard(
              label: 'In Stock',
              value: _all.where((p) => p.currentStock > 10).length.toString(),
              color: successColor,
              icon: Icons.check_circle_outline,
              theme: theme,
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: 'Low/Out',
              value: _all.where((p) => p.currentStock <= 10).length.toString(),
              color: errorColor,
              icon: Icons.error_outline,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 3. Horizontal Critical Alerts
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildAlertsHeader(BuildContext context, ThemeData theme) {
    final alerts = _all.where((p) => p.currentStock < 5).toList();
    if (alerts.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'CRITICAL ALERTS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
            Text(
              '${alerts.length} ITEMS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalAlerts(BuildContext context, ThemeData theme) {
    final alerts = _all.where((p) => p.currentStock < 5).toList();
    final errorColor = theme.colorScheme.error;
    final isDark = theme.brightness == Brightness.dark;

    if (alerts.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            final p = alerts[index];
            return Container(
              width: 240,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: errorColor.withValues(alpha: 0.15),
                  width: 1,
                ),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: errorColor.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => showProductDetailSheet(context, p),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: errorColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _ProductImage(
                            imagePath: p.imagePath,
                            imageEmoji: p.imageEmoji,
                            emojiSize: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                p.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: errorColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${p.currentStock} left',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: errorColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
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
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 4. Modern Filter Chip Bar
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildFilterBar(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return SliverPersistentHeader(
      pinned: true,
      delegate: _PremiumFilterDelegate(
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, i) {
                  final isSelected = _activeCategory == _categories[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: ChoiceChip(
                          label: Text(_categories[i]),
                          selected: isSelected,
                          onSelected: (v) => setState(() {
                            _activeCategory = _categories[i];
                            _updateFilters();
                          }),
                          selectedColor: theme.colorScheme.primary,
                          backgroundColor: isDark
                              ? theme.colorScheme.surface
                              : Colors.white,
                          labelStyle: GoogleFonts.plusJakartaSans(
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            fontSize: 12,
                          ),
                          elevation: 0,
                          pressElevation: 0,
                          side: BorderSide(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.1,
                                  ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 5. Product Grid/List
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildProductSection(BuildContext context, ThemeData theme) {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: _filteredProducts.isEmpty
          ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: Text(
                    'No products found.',
                    style: GoogleFonts.plusJakartaSans(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          : SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate((context, i) {
                final product = _filteredProducts[i];
                return TweenAnimationBuilder<double>(
                  key: ValueKey('${product.id}_$_activeCategory'),
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.9 + (0.1 * value),
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: _ProductProCard(
                    product: product,
                    onTap: () => showProductDetailSheet(context, product),
                    priceLabel: _formatCurrency(product.price),
                    theme: theme,
                  ),
                );
              }, childCount: _filteredProducts.length),
            ),
    );
  }

  Widget _buildFab(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
          if (newProduct != null && newProduct is Product) {
            setState(() {
              mockProducts.insert(0, newProduct);
              _all = List.from(mockProducts);
              _updateFilters();
            });
          }
        },
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.add_rounded, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UI COMPONENT: PRO PRODUCT CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ProductImage extends StatelessWidget {
  final String? imagePath;
  final String imageEmoji;
  final double emojiSize;
  final BoxFit fit;

  const _ProductImage({
    this.imagePath,
    required this.imageEmoji,
    this.emojiSize = 24,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return Center(
        child: Text(imageEmoji, style: TextStyle(fontSize: emojiSize)),
      );
    }

    final bool isAsset = imagePath!.startsWith('assets/');

    return Image(
      image: isAsset
          ? AssetImage(imagePath!) as ImageProvider
          : FileImage(File(imagePath!)),
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Center(
        child: Text(imageEmoji, style: TextStyle(fontSize: emojiSize)),
      ),
    );
  }
}

class _ProductProCard extends StatelessWidget {
  // ...
  final Product product;
  final VoidCallback onTap;
  final String priceLabel;
  final ThemeData theme;

  const _ProductProCard({
    required this.product,
    required this.onTap,
    required this.priceLabel,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    bool isLow = product.currentStock <= 5;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.05),
                            theme.colorScheme.surface,
                          ],
                        ),
                      ),
                      child: _ProductImage(
                        imagePath: product.imagePath,
                        imageEmoji: product.imageEmoji,
                        emojiSize: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: _StockBadge(
                        count: product.currentStock,
                        isLow: isLow,
                        theme: theme,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.category.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      priceLabel,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUPPORTING UI COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  final ThemeData theme;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: color.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final int count;
  final bool isLow;
  final ThemeData theme;
  const _StockBadge({
    required this.count,
    required this.isLow,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final successColor = const Color(0xFF10B981);
    final errorColor = theme.colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isLow ? errorColor : successColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$count',
        style: GoogleFonts.plusJakartaSans(
          color: isLow ? theme.colorScheme.onError : successColor,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final ThemeData theme;
  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: theme.colorScheme.onSurface, size: 20),
          ),
        ),
      ),
    );
  }
}

class _PremiumFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _PremiumFilterDelegate({required this.child});

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _PremiumFilterDelegate oldDelegate) => true;
}
