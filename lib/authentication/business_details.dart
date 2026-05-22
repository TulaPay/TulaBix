import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/id_verification.dart';

class BusinessDetails extends StatefulWidget {
  const BusinessDetails({super.key});

  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = [
    "Retail & Wholesale",
    "Food & Beverage",
    "Professional Services",
    "Transportation & Logistics",
    "Technology",
    "Health & Beauty",
    "Construction",
    "Other"
  ];

  @override
  void dispose() {
    _ownerNameController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      // TODO: Proceed with Business Registration logic
      debugPrint("Business Name: ${_businessNameController.text}");
      Navigator.push(context, MaterialPageRoute(builder: (_)=> const IdVerification()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Business Details",
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tell us a bit about yourself and your business to get started",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 32),

                // SECTION: Business Owner
                _buildSectionTitle("Personal Details"),
                _buildLabel("Business Owner Name"),
                TextFormField(
                  controller: _ownerNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: "Enter full name",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? "Owner name is required" : null,
                ),
                const SizedBox(height: 20),

                _buildLabel("Business Phone Number"),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: "e.g. +237 6XX XXX XXX",
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? "Phone number is required" : null,
                ),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 24),

                // SECTION: Company Info
                _buildSectionTitle("Company Information"),
                Text(
                  "As it appears on your registration documents",
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5), fontSize: 13),
                ),
                const SizedBox(height: 20),

                _buildLabel("Business Name"),
                TextFormField(
                  controller: _businessNameController,
                  decoration: const InputDecoration(
                    hintText: "Legal business name",
                    prefixIcon: Icon(Icons.business_outlined),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? "Business name is required" : null,
                ),
                const SizedBox(height: 20),

                _buildLabel("Business Address"),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    hintText: "Street, City, Country",
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? "Address is required" : null,
                ),
                const SizedBox(height: 20),

                _buildLabel("Business Category"),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  hint: const Text("Select category"),
                  items: _categories.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val),
                  validator: (val) => (val == null) ? "Please select a category" : null,
                ),

                const SizedBox(height: 32),

                // KYC Hint Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, size: 20, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Ensure your business name matches your official documents to avoid delays during the KYC verification process.",
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Continue Button
                ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: const Text("Continue"),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
    );
  }
}