import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tulapay/authentication/verification_in_progress_page.dart';
import 'package:tulapay/services/merchant_service.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class _BeneficialOwnerDraft {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController percentController = TextEditingController();
  XFile? file;

  void dispose() {
    nameController.dispose();
    percentController.dispose();
  }
}

/// Step 4 (replaces the old id_verification.dart) — Level 1 KYB: RCCM, tax
/// document, the director/representative's ID, a selfie, and beneficial
/// ownership. Everything uploads together on submit, tagged to
/// [merchantId] (already created by BusinessInformationScreen).
class KybDocumentsScreen extends StatefulWidget {
  final String merchantId;
  // The merchants.business_type literal (migration 0037) — RCCM/tax
  // documents are only required when this is 'registered_business';
  // informal/association/other businesses skip both entirely.
  final String? businessType;

  const KybDocumentsScreen({
    super.key,
    required this.merchantId,
    required this.businessType,
  });

  @override
  State<KybDocumentsScreen> createState() => _KybDocumentsScreenState();
}

class _KybDocumentsScreenState extends State<KybDocumentsScreen> {
  String? _idDocType;
  XFile? _idFile;
  XFile? _rccmFile;
  XFile? _taxFile;
  XFile? _selfieFile;
  final List<_BeneficialOwnerDraft> _owners = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    for (final owner in _owners) {
      owner.dispose();
    }
    super.dispose();
  }

  /// Camera + gallery always offered; a direct file upload (for a PDF RCCM/
  /// tax document, per the KYB spec's "Document upload PDF" requirement) is
  /// only offered when [allowFile] is true — the selfie and beneficial-owner
  /// ID photos have no PDF use case, so they stay camera/gallery-only.
  Future<XFile?> _pickDocument({bool allowFile = true, bool front = false}) {
    return showModalBottomSheet<XFile?>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        return SafeArea(
          child: GlassSurface(
            borderRadius: BorderRadius.circular(24),
            opacity: 0.18,
            blur: 18,
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.photo_camera_outlined, color: cs.primary),
                  title: const Text("Take a photo"),
                  onTap: () async {
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      imageQuality: 85,
                      preferredCameraDevice:
                          front ? CameraDevice.front : CameraDevice.rear,
                    );
                    if (context.mounted) Navigator.pop(context, picked);
                  },
                ),
                if (!front) ...[
                  ListTile(
                    leading: Icon(Icons.photo_library_outlined, color: cs.primary),
                    title: const Text("Choose from gallery"),
                    onTap: () async {
                      final picked = await ImagePicker()
                          .pickImage(source: ImageSource.gallery, imageQuality: 85);
                      if (context.mounted) Navigator.pop(context, picked);
                    },
                  ),
                  if (allowFile)
                    ListTile(
                      leading: Icon(Icons.upload_file_outlined, color: cs.primary),
                      title: const Text("Upload a file (PDF or image)"),
                      onTap: () async {
                        final result = await FilePicker.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                        );
                        if (context.mounted) {
                          Navigator.pop(
                            context,
                            result.isNotEmpty ? result.first.xFile : null,
                          );
                        }
                      },
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  bool get _requiresRegistrationDocs => widget.businessType == 'registered_business';

  bool get _canSubmit =>
      _idDocType != null &&
      _idFile != null &&
      (!_requiresRegistrationDocs || (_rccmFile != null && _taxFile != null)) &&
      _selfieFile != null &&
      _owners.every((o) =>
          o.nameController.text.trim().isNotEmpty &&
          num.tryParse(o.percentController.text.trim()) != null);

  Future<void> _handleSubmit() async {
    if (!_canSubmit) return;

    setState(() => _isSubmitting = true);
    try {
      final service = MerchantService.instance;
      await service.uploadKybDocument(
        merchantId: widget.merchantId,
        docType: _idDocType!,
        file: _idFile!,
      );
      if (_requiresRegistrationDocs) {
        await service.uploadKybDocument(
          merchantId: widget.merchantId,
          docType: 'rccm',
          file: _rccmFile!,
        );
        await service.uploadKybDocument(
          merchantId: widget.merchantId,
          docType: 'tax_document',
          file: _taxFile!,
        );
      }
      await service.uploadKybDocument(
        merchantId: widget.merchantId,
        docType: 'selfie',
        file: _selfieFile!,
      );

      for (final owner in _owners) {
        final ownerId = await service.addBeneficialOwner(
          merchantId: widget.merchantId,
          fullName: owner.nameController.text.trim(),
          ownershipPercent: num.parse(owner.percentController.text.trim()),
        );
        if (owner.file != null) {
          await service.uploadKybDocument(
            merchantId: widget.merchantId,
            docType: 'national_id',
            file: owner.file!,
            beneficialOwnerId: ownerId,
          );
        }
      }

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationInProgressPage(merchantId: widget.merchantId),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "KYB Verification (Level 1)",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Upload the documents below — take a photo or upload a file directly.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.66),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildSectionTitle("Identity document"),
                      _buildDocTypeOption('national_id', "National ID Card (CNI)", Icons.badge_outlined),
                      const SizedBox(height: 10),
                      _buildDocTypeOption('drivers_license', "Driver's License", Icons.drive_eta_outlined),
                      const SizedBox(height: 10),
                      _buildDocTypeOption('passport', "International Passport", Icons.public_outlined),
                      if (_idDocType != null) ...[
                        const SizedBox(height: 12),
                        _buildUploadTile(
                          label: _idFile != null ? "ID document captured — tap to retake" : "Take a photo or upload your ID",
                          done: _idFile != null,
                          onTap: () async {
                            final file = await _pickDocument();
                            if (file != null) setState(() => _idFile = file);
                          },
                        ),
                      ],
                      const SizedBox(height: 20),

                      if (_requiresRegistrationDocs) ...[
                        _buildSectionTitle("RCCM / Business Registration"),
                        _buildUploadTile(
                          label: _rccmFile != null ? "RCCM document uploaded — tap to replace" : "Upload your RCCM document",
                          done: _rccmFile != null,
                          onTap: () async {
                            final file = await _pickDocument();
                            if (file != null) setState(() => _rccmFile = file);
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildSectionTitle("Tax Identification (NIU)"),
                        _buildUploadTile(
                          label: _taxFile != null ? "Tax document uploaded — tap to replace" : "Upload your tax document",
                          done: _taxFile != null,
                          onTap: () async {
                            final file = await _pickDocument();
                            if (file != null) setState(() => _taxFile = file);
                          },
                        ),
                        const SizedBox(height: 20),
                      ] else ...[
                        GlassSurface(
                          borderRadius: BorderRadius.circular(16),
                          opacity: 0.1,
                          blur: 10,
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline_rounded, size: 20, color: cs.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "RCCM and tax documents aren't required for your business type.",
                                  style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      _buildSectionTitle("Selfie"),
                      Text(
                        "A clear photo of the representative's face, matched against the ID above.",
                        style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 10),
                      _buildUploadTile(
                        label: _selfieFile != null ? "Selfie captured — tap to retake" : "Take a selfie",
                        done: _selfieFile != null,
                        onTap: () async {
                          final file = await _pickDocument(allowFile: false, front: true);
                          if (file != null) setState(() => _selfieFile = file);
                        },
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),

                      _buildSectionTitle("Beneficial owners"),
                      Text(
                        "Anyone who owns or controls 25% or more of the business. Leave empty for a sole proprietorship — that collapses into the representative above.",
                        style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant, height: 1.4),
                      ),
                      const SizedBox(height: 12),
                      for (int i = 0; i < _owners.length; i++) ...[
                        _buildOwnerCard(i),
                        const SizedBox(height: 12),
                      ],
                      OutlinedButton.icon(
                        onPressed: () => setState(() => _owners.add(_BeneficialOwnerDraft())),
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                        label: const Text("Add beneficial owner"),
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: (_isSubmitting || !_canSubmit) ? null : _handleSubmit,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text("Submit for review"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerCard(int index) {
    final owner = _owners[index];
    final cs = Theme.of(context).colorScheme;
    return GlassSurface(
      borderRadius: BorderRadius.circular(18),
      opacity: 0.12,
      blur: 12,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Owner ${index + 1}",
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: cs.onSurface),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, color: cs.onSurfaceVariant, size: 20),
                onPressed: () => setState(() {
                  owner.dispose();
                  _owners.removeAt(index);
                }),
              ),
            ],
          ),
          TextFormField(
            controller: owner.nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: "Full name",
              prefixIcon: Icon(Icons.person_outline),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: owner.percentController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Ownership %",
              prefixIcon: Icon(Icons.pie_chart_outline_rounded),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          _buildUploadTile(
            label: owner.file != null ? "ID document added — tap to replace" : "Upload their ID document (optional)",
            done: owner.file != null,
            onTap: () async {
              final file = await _pickDocument();
              if (file != null) setState(() => owner.file = file);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildDocTypeOption(String id, String title, IconData icon) {
    final isSelected = _idDocType == id;
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => setState(() {
        _idDocType = id;
        _idFile = null;
      }),
      borderRadius: BorderRadius.circular(16),
      child: GlassSurface(
        borderRadius: BorderRadius.circular(16),
        opacity: isSelected ? 0.18 : 0.12,
        blur: 12,
        border: Border.all(
          color: isSelected ? cs.primary : cs.outline.withValues(alpha: 0.16),
          width: isSelected ? 2 : 1,
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? cs.primary : cs.onSurfaceVariant, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: cs.onSurface),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_off,
              color: isSelected ? cs.primary : cs.outline.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadTile({required String label, required bool done, required VoidCallback onTap}) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: GlassSurface(
        borderRadius: BorderRadius.circular(16),
        opacity: 0.12,
        blur: 12,
        border: Border.all(
          color: done ? cs.primary : cs.outline.withValues(alpha: 0.16),
          width: done ? 2 : 1,
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(done ? Icons.check_circle_rounded : Icons.camera_alt_outlined, color: cs.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: cs.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
