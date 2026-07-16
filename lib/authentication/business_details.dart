import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/screens/Navigation_bar.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class BusinessDetails extends StatefulWidget {
  const BusinessDetails({super.key});

  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _registrationNumberController = TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();
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
    "Other",
  ];

  @override
  void dispose() {
    _ownerNameController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _registrationNumberController.dispose();
    _taxIdController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Navigation_Bar()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AppBackdrop(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: GlassSurface(
                  borderRadius: BorderRadius.circular(28),
                  opacity: 0.16,
                  blur: 18,
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "KYB - Business Information",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Collect the business details we need before activating the account.",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.66),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle("Personal Details"),
                        _buildLabel("Business Owner Name"),
                        TextFormField(
                          controller: _ownerNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            hintText: "Enter full name",
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? "Owner name is required" : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("Business Phone Number"),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: "e.g. +237 6XX XXX XXX",
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? "Phone number is required" : null,
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        _buildSectionTitle("Company Information"),
                        Text(
                          "As it appears on your registration documents",
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.56),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("Business Name"),
                        TextFormField(
                          controller: _businessNameController,
                          decoration: const InputDecoration(
                            hintText: "Legal business name",
                            prefixIcon: Icon(Icons.business_outlined),
                          ),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? "Business name is required" : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("Registration Number"),
                        TextFormField(
                          controller: _registrationNumberController,
                          decoration: const InputDecoration(
                            hintText: "Business registration number",
                            prefixIcon: Icon(Icons.confirmation_number_outlined),
                          ),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? "Registration number is required" : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("Tax ID / NIF"),
                        TextFormField(
                          controller: _taxIdController,
                          decoration: const InputDecoration(
                            hintText: "Tax identification number",
                            prefixIcon: Icon(Icons.receipt_long_outlined),
                          ),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? "Tax ID is required" : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("Business Address"),
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            hintText: "Street, City, Country",
                            prefixIcon: Icon(Icons.location_on_outlined),
                          ),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? "Address is required" : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("Business Category"),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.category_outlined),
                          ),
                          hint: const Text("Select category"),
                          items: _categories
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => setState(() => _selectedCategory = val),
                          validator: (val) => (val == null) ? "Please select a category" : null,
                        ),
                        const SizedBox(height: 20),
                        GlassSurface(
                          borderRadius: BorderRadius.circular(20),
                          opacity: 0.12,
                          blur: 12,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline_rounded, size: 20, color: cs.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Make sure the registration and tax details match your official business documents. This KYB step unlocks the main app once approved.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: cs.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _handleContinue,
                          child: const Text("Continue"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
