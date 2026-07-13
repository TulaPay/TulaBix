import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tulapay/models/product_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _skuCtrl = TextEditingController();
  final _skuAliasCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  final _priceLabelCtrl = TextEditingController(text: 'Base Price');
  final _priceAmountCtrl = TextEditingController(text: '0');

  String _selectedCategory = 'Select Categories';
  final List<String> _categories = [
    'Select Categories',
    'Electronics',
    'Food & Drinks',
    'Clothing',
    'Home & Office',
  ];

  bool _hasSecondaryUnit = false;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _image = image);
    }
  }

  void _submit({bool createAgain = false}) {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == 'Select Categories') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      final newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameCtrl.text.trim(),
        description: '', // Omitted from new UI
        category: _selectedCategory,
        sku: _skuCtrl.text.trim(),
        skuAlias: _skuAliasCtrl.text.trim().isEmpty ? null : _skuAliasCtrl.text.trim(),
        costPrice: double.tryParse(_costCtrl.text) ?? 0,
        price: double.tryParse(_priceAmountCtrl.text) ?? 0,
        currentStock: 0, // Omitted from new UI
        reorderThreshold: 5,
        unit: _unitCtrl.text.trim().isEmpty ? 'pcs' : _unitCtrl.text.trim(),
        hasSecondaryUnit: _hasSecondaryUnit,
        multiplePrices: [
          ProductPrice(
            label: _priceLabelCtrl.text.trim(),
            amount: double.tryParse(_priceAmountCtrl.text) ?? 0,
          )
        ],
        variants: [], // Placeholder for UI
        imagePath: _image?.path,
        imageEmoji: '📦',
        lastUpdated: DateTime.now(),
      );

      if (createAgain) {
        setState(() {
          _formKey.currentState?.reset();
          _skuCtrl.clear();
          _skuAliasCtrl.clear();
          _nameCtrl.clear();
          _costCtrl.clear();
          _unitCtrl.clear();
          _priceLabelCtrl.text = 'Base Price';
          _priceAmountCtrl.text = '0';
          _selectedCategory = 'Select Categories';
          _hasSecondaryUnit = false;
          _image = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added. Ready for next.')),
        );
      } else {
        Navigator.pop(context, newProduct);
      }
    }
  }

  @override
  void dispose() {
    _skuCtrl.dispose();
    _skuAliasCtrl.dispose();
    _nameCtrl.dispose();
    _costCtrl.dispose();
    _unitCtrl.dispose();
    _priceLabelCtrl.dispose();
    _priceAmountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    
    // Light gray background for light mode to match mockup, deep dark for dark mode
    final bgColor = isDark ? colorScheme.surface : const Color(0xFFF5F6F8);
    final cardColor = isDark ? colorScheme.surfaceContainerHighest : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add Product',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          physics: const BouncingScrollPhysics(),
          children: [
            // CARD 1: Basic Info
            _buildCard(
              cardColor: cardColor,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Image Picker
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: isDark ? colorScheme.surface : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                          image: _image != null
                              ? DecorationImage(
                                  image: FileImage(File(_image!.path)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _image == null
                            ? Icon(Icons.add, size: 32, color: colorScheme.primary)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildInlineFieldRow('SKU*', 'Enter SKU', _skuCtrl, true, theme, trailingIcon: Icons.qr_code_scanner),
                  _buildDivider(theme),
                  _buildInlineFieldRow('SKU Alias', 'Enter SKU Alias', _skuAliasCtrl, false, theme, trailingIcon: Icons.qr_code_scanner),
                  _buildDivider(theme),
                  _buildInlineFieldRow('Product Name*', 'Enter Product Name', _nameCtrl, true, theme),
                  _buildDivider(theme),
                  _buildInlineFieldRow('Cost Price', 'Enter cost price', _costCtrl, false, theme, isNumber: true),
                  _buildDivider(theme),
                  
                  // Category Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: Text(
                            'Category',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCategory,
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down, color: colorScheme.onSurface.withValues(alpha: 0.3)),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                color: _selectedCategory == 'Select Categories' 
                                    ? colorScheme.onSurface.withValues(alpha: 0.4) 
                                    : colorScheme.onSurface,
                              ),
                              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                              onChanged: (v) => setState(() => _selectedCategory = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // CARD 2: Units
            _buildCard(
              cardColor: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Units',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Add Secondary unit?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: _hasSecondaryUnit,
                          onChanged: (v) => setState(() => _hasSecondaryUnit = v),
                          activeThumbColor: colorScheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            'Units',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.15)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextFormField(
                              controller: _unitCtrl,
                              style: GoogleFonts.plusJakartaSans(fontSize: 14, color: colorScheme.onSurface),
                              decoration: InputDecoration(
                                hintText: 'Select Unit',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // CARD 3: Selling Price
            _buildCard(
              cardColor: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selling Price',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Each price needs a label and an amount, both are required',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? colorScheme.surface : const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Label',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.15)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextFormField(
                                    controller: _priceLabelCtrl,
                                    style: GoogleFonts.plusJakartaSans(fontSize: 14, color: colorScheme.onSurface),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Amount',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.15)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextFormField(
                                    controller: _priceAmountCtrl,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.plusJakartaSans(fontSize: 14, color: colorScheme.onSurface),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Required';
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Placeholder for adding multiple prices
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(
                          'Add Multiple Price',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // CARD 4: Product Variants
            _buildCard(
              cardColor: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Variants',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? colorScheme.surface : const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '1. Add size, color, or material variants.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100), // padding for bottom bar
          ],
        ),
      ),
      
      // Fixed Bottom Actions
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _submit(createAgain: false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _submit(createAgain: true),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Save & Create Again',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child, required Color cardColor}) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)),
      ),
      child: child,
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      thickness: 1,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
    );
  }

  Widget _buildInlineFieldRow(
    String label,
    String hint,
    TextEditingController controller,
    bool isRequired,
    ThemeData theme, {
    IconData? trailingIcon,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: RichText(
              text: TextSpan(
                text: label.replaceAll('*', ''),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
                children: [
                  if (label.contains('*'))
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              validator: isRequired ? (v) => v!.isEmpty ? 'Required' : null : null,
            ),
          ),
          if (trailingIcon != null)
            Icon(
              trailingIcon,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              size: 20,
            ),
        ],
      ),
    );
  }
}
