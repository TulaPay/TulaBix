import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/kyb_documents_screen.dart';
import 'package:tulapay/models/business_type.dart';
import 'package:tulapay/services/merchant_service.dart';
import 'package:tulapay/widgets/glass_effects.dart';

/// Step 3 of the redesigned onboarding flow — now comes *before* KYB
/// documents (kyb_documents_screen.dart), reversing the old order. This is
/// where the merchants/kyb_submissions rows actually get created (same
/// point in the flow as the old business_details.dart, just earlier in the
/// screen order) — everything here is real Supabase writes via
/// MerchantService, not just local state.
class BusinessInformationScreen extends StatefulWidget {
  final String businessName;
  final String businessType;
  final String country;

  const BusinessInformationScreen({
    super.key,
    required this.businessName,
    required this.businessType,
    required this.country,
  });

  @override
  State<BusinessInformationScreen> createState() =>
      _BusinessInformationScreenState();
}

class _BusinessInformationScreenState
    extends State<BusinessInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  late final TextEditingController _businessNameController =
      TextEditingController(text: widget.businessName);
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();
  final TextEditingController _businessPhoneController = TextEditingController();
  final TextEditingController _businessEmailController = TextEditingController();
  final TextEditingController _registrationNumberController = TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _estimatedVolumeController = TextEditingController();

  late String? _selectedBusinessType = businessTypeLabelFor(widget.businessType);
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
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _businessPhoneController.dispose();
    _businessEmailController.dispose();
    _registrationNumberController.dispose();
    _taxIdController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _estimatedVolumeController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final merchantId = await MerchantService.instance.createMerchantProfile(
        businessName: _businessNameController.text.trim(),
        ownerName: _ownerNameController.text.trim(),
        ownerPhone: _ownerPhoneController.text.trim(),
        businessCategory: _selectedCategory!,
        registrationNumber: _registrationNumberController.text.trim(),
        taxId: _taxIdController.text.trim(),
        addressStreet: _streetController.text.trim(),
        addressCity: _cityController.text.trim(),
        addressCountry: widget.country,
        businessType: businessTypeLabels[_selectedBusinessType],
        businessPhone: _businessPhoneController.text.trim(),
        businessEmail: _businessEmailController.text.trim(),
        estimatedMonthlyVolume: num.tryParse(_estimatedVolumeController.text.trim()),
      );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KybDocumentsScreen(merchantId: merchantId),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'), behavior: SnackBarBehavior.floating),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
                          "Business Information",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Collect the business details we need before KYB document review.",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.66),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle("Representative"),
                        _buildLabel("Owner / Representative Name"),
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
                        _buildLabel("Owner / Representative Phone"),
                        TextFormField(
                          controller: _ownerPhoneController,
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
                        _buildSectionTitle("Registered Business"),
                        Text(
                          "As it appears on your registration documents",
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("Registered Business Name"),
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
                        _buildLabel("Business Type"),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedBusinessType,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.category_outlined),
                          ),
                          hint: const Text("Select business type"),
                          items: businessTypeLabels.keys
                              .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                              .toList(),
                          onChanged: (val) => setState(() => _selectedBusinessType = val),
                          validator: (val) => (val == null) ? "Select a business type" : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("Industry / Sector"),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.storefront_outlined),
                          ),
                          hint: const Text("Select industry"),
                          items: _categories
                              .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                              .toList(),
                          onChanged: (val) => setState(() => _selectedCategory = val),
                          validator: (val) => (val == null) ? "Select an industry" : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("Business Phone"),
                        TextFormField(
                          controller: _businessPhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: "Dedicated business line, if different",
                            prefixIcon: Icon(Icons.call_outlined),
                          ),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? "Business phone is required" : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("Business Email"),
                        TextFormField(
                          controller: _businessEmailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "contact@business.cm",
                            prefixIcon: Icon(Icons.alternate_email_rounded),
                          ),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? "Business email is required" : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("RCCM / Business Registration Number"),
                        TextFormField(
                          controller: _registrationNumberController,
                          decoration: const InputDecoration(
                            hintText: "RCCM number",
                            prefixIcon: Icon(Icons.confirmation_number_outlined),
                          ),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? "RCCM number is required" : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("NIU (Tax Identification Number)"),
                        TextFormField(
                          controller: _taxIdController,
                          decoration: const InputDecoration(
                            hintText: "Tax identification number",
                            prefixIcon: Icon(Icons.receipt_long_outlined),
                          ),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? "NIU is required" : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("Estimated Monthly Transaction Volume (XAF)"),
                        TextFormField(
                          controller: _estimatedVolumeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "e.g. 500000",
                            prefixIcon: Icon(Icons.trending_up_rounded),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Estimated volume is required";
                            }
                            if (num.tryParse(val) == null) {
                              return "Enter a number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("Street Address"),
                        TextFormField(
                          controller: _streetController,
                          decoration: const InputDecoration(
                            hintText: "e.g. 12 Rue de la Paix",
                            prefixIcon: Icon(Icons.location_on_outlined),
                          ),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? "Street address is required" : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel("City"),
                        TextFormField(
                          controller: _cityController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            hintText: "e.g. Douala",
                            prefixIcon: Icon(Icons.location_city_outlined),
                          ),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? "City is required" : null,
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
                                  "Next, you'll upload your RCCM, tax, and ID documents for KYB review.",
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
                          onPressed: _isSubmitting ? null : _handleContinue,
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text("Continue to KYB"),
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
