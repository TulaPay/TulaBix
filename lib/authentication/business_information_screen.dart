import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/kyb_documents_screen.dart';
import 'package:tulapay/models/business_type.dart';
import 'package:tulapay/services/merchant_service.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

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

class _BusinessInformationScreenState extends State<BusinessInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  late final TextEditingController _businessNameController =
      TextEditingController(text: widget.businessName);
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();
  final TextEditingController _businessPhoneController =
      TextEditingController();
  final TextEditingController _businessEmailController =
      TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _estimatedVolumeController =
      TextEditingController();

  late String? _selectedBusinessType = businessTypeLabelFor(
    widget.businessType,
  );
  String? _selectedCategory;

  // Only a 'registered_business' is expected to have RCCM/tax documents —
  // informal/association/other businesses skip both the fields here and
  // the matching document uploads in KybDocumentsScreen.
  bool get _isRegisteredBusiness =>
      businessTypeLabels[_selectedBusinessType] == 'registered_business';
  // Stored as-is in `businessCategory` (shared enum literals) — only the
  // dropdown display is localized, see _categoryLabel.
  static const List<String> _categories = [
    "Retail & Wholesale",
    "Food & Beverage",
    "Professional Services",
    "Transportation & Logistics",
    "Technology",
    "Health & Beauty",
    "Construction",
    "Other",
  ];

  String _categoryLabel(String c) {
    final l = context.l10n;
    return switch (c) {
      "Retail & Wholesale" => l.retailWholesale,
      "Food & Beverage" => l.foodBeverage,
      "Professional Services" => l.professionalServices,
      "Transportation & Logistics" => l.transportationLogistics,
      "Technology" => l.technology,
      "Health & Beauty" => l.healthBeauty,
      "Construction" => l.construction,
      _ => l.otherLabel,
    };
  }

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
        registrationNumber: _registrationNumberController.text.trim().isEmpty
            ? null
            : _registrationNumberController.text.trim(),
        taxId: _taxIdController.text.trim().isEmpty
            ? null
            : _taxIdController.text.trim(),
        addressStreet: _streetController.text.trim(),
        addressCity: _cityController.text.trim(),
        addressCountry: widget.country,
        businessType: businessTypeLabels[_selectedBusinessType],
        businessPhone: _businessPhoneController.text.trim(),
        businessEmail: _businessEmailController.text.trim(),
        estimatedMonthlyVolume: num.tryParse(
          _estimatedVolumeController.text.trim(),
        ),
      );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KybDocumentsScreen(
            merchantId: merchantId,
            businessType: businessTypeLabels[_selectedBusinessType],
          ),
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
          icon: Icon(Icons.chevron_left_rounded, color: cs.onSurface),
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
                  borderRadius: BorderRadius.circular(12),
                  opacity: 0.16,
                  blur: 18,
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.businessInformation,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.8,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.collectTheBusinessDetailsWe,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.66),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle(context.l10n.representative),
                        _buildLabel(context.l10n.ownerRepresentativeName),
                        TextFormField(
                          controller: _ownerNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            hintText: context.l10n.enterFullName,
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (val) => (val == null || val.isEmpty)
                              ? context.l10n.ownerNameIsRequired
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel(context.l10n.ownerRepresentativePhone),
                        TextFormField(
                          controller: _ownerPhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: context.l10n.eG2376xxXxx,
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          validator: (val) => (val == null || val.isEmpty)
                              ? context.l10n.phoneNumberIsRequired
                              : null,
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        _buildSectionTitle(context.l10n.registeredBusiness),
                        Text(
                          context.l10n.asItAppearsOnYour,
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildLabel(context.l10n.registeredBusinessName),
                        TextFormField(
                          controller: _businessNameController,
                          decoration: InputDecoration(
                            hintText: context.l10n.legalBusinessName,
                            prefixIcon: Icon(Icons.business_outlined),
                          ),
                          validator: (val) => (val == null || val.isEmpty)
                              ? context.l10n.businessNameIsRequired
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel(context.l10n.businessType),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedBusinessType,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.category_outlined),
                          ),
                          hint: Text(context.l10n.selectBusinessType),
                          items: businessTypeLabels.keys
                              .map(
                                (label) => DropdownMenuItem(
                                  value: label,
                                  child: Text(context.businessTypeName(label)),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedBusinessType = val),
                          validator: (val) =>
                              (val == null) ? context.l10n.selectABusinessType : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel(context.l10n.industrySector),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.storefront_outlined),
                          ),
                          hint: Text(context.l10n.selectIndustry),
                          items: _categories
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(_categoryLabel(category)),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedCategory = val),
                          validator: (val) =>
                              (val == null) ? context.l10n.selectAnIndustry : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel(context.l10n.businessPhone),
                        TextFormField(
                          controller: _businessPhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: context.l10n.dedicatedBusinessLineIfDifferent,
                            prefixIcon: Icon(Icons.call_outlined),
                          ),
                          validator: (val) => (val == null || val.isEmpty)
                              ? context.l10n.businessPhoneIsRequired
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel(context.l10n.businessEmail),
                        TextFormField(
                          controller: _businessEmailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "contact@business.cm",
                            prefixIcon: Icon(Icons.alternate_email_rounded),
                          ),
                          validator: (val) => (val == null || val.isEmpty)
                              ? context.l10n.businessEmailIsRequired
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel(
                          _isRegisteredBusiness
                              ? context.l10n.rccmBusinessRegistrationNumber
                              : context.l10n.rccmBusinessRegistrationNumberIf,
                        ),
                        TextFormField(
                          controller: _registrationNumberController,
                          decoration: InputDecoration(
                            hintText: context.l10n.rccmNumber,
                            prefixIcon: Icon(
                              Icons.confirmation_number_outlined,
                            ),
                          ),
                          validator: (val) {
                            if (!_isRegisteredBusiness) return null;
                            return (val == null || val.isEmpty)
                                ? context.l10n.rccmNumberIsRequired
                                : null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildLabel(
                          _isRegisteredBusiness
                              ? context.l10n.niuTaxIdentificationNumber
                              : context.l10n.niuTaxIdentificationNumberIf,
                        ),
                        TextFormField(
                          controller: _taxIdController,
                          decoration: InputDecoration(
                            hintText: context.l10n.taxIdentificationNumber,
                            prefixIcon: Icon(Icons.receipt_long_outlined),
                          ),
                          validator: (val) {
                            if (!_isRegisteredBusiness) return null;
                            return (val == null || val.isEmpty)
                                ? context.l10n.niuIsRequired
                                : null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildLabel(
                          context.l10n.estimatedMonthlyTransactionVolumeXaf,
                        ),
                        TextFormField(
                          controller: _estimatedVolumeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: context.l10n.eG500000,
                            prefixIcon: Icon(Icons.trending_up_rounded),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return context.l10n.estimatedVolumeIsRequired;
                            }
                            if (num.tryParse(val) == null) {
                              return context.l10n.enterANumber;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildLabel(context.l10n.streetAddress),
                        TextFormField(
                          controller: _streetController,
                          decoration: InputDecoration(
                            hintText: context.l10n.eG12RueDe,
                            prefixIcon: Icon(Icons.location_on_outlined),
                          ),
                          validator: (val) => (val == null || val.isEmpty)
                              ? context.l10n.streetAddressIsRequired
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel(context.l10n.city),
                        TextFormField(
                          controller: _cityController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            hintText: context.l10n.eGDouala,
                            prefixIcon: Icon(Icons.location_city_outlined),
                          ),
                          validator: (val) => (val == null || val.isEmpty)
                              ? context.l10n.cityIsRequired
                              : null,
                        ),
                        const SizedBox(height: 20),
                        GlassSurface(
                          borderRadius: BorderRadius.circular(12),
                          opacity: 0.12,
                          blur: 12,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 20,
                                color: cs.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  context.l10n.nextYouLlUploadYour,
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
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(context.l10n.continueToKyb),
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
        title.toUpperCase(),
        style: AppText.microLabel(color: context.textTertiary)
            .copyWith(letterSpacing: 1.6),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: context.textTertiary,
        ),
      ),
    );
  }
}
