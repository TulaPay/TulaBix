import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tulapay/authentication/verification_in_progress_page.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class IdVerification extends StatefulWidget {
  const IdVerification({super.key});

  @override
  State<IdVerification> createState() => _IdVerificationState();
}

class _IdVerificationState extends State<IdVerification> {
  String? _selectedDocument;
  XFile? _capturedFile;

  Future<void> _capturePhoto() async {
    final file = await showModalBottomSheet<XFile?>(
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
                    final picked = await ImagePicker()
                        .pickImage(source: ImageSource.camera, imageQuality: 85);
                    if (context.mounted) Navigator.pop(context, picked);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library_outlined, color: cs.primary),
                  title: const Text("Choose from gallery"),
                  onTap: () async {
                    final picked = await ImagePicker()
                        .pickImage(source: ImageSource.gallery, imageQuality: 85);
                    if (context.mounted) Navigator.pop(context, picked);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (file != null) {
      setState(() => _capturedFile = file);
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
                        "ID Verification",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "To ensure the security of your account, please provide a valid government-issued document.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.66),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildDocumentOption(
                        id: 'national_id',
                        title: "National ID Card (CNI)",
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 14),
                      _buildDocumentOption(
                        id: 'drivers_license',
                        title: "Driver's License",
                        icon: Icons.drive_eta_outlined,
                      ),
                      const SizedBox(height: 14),
                      _buildDocumentOption(
                        id: 'passport',
                        title: "International Passport",
                        icon: Icons.public_outlined,
                      ),
                      if (_selectedDocument != null) ...[
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: _capturePhoto,
                          borderRadius: BorderRadius.circular(18),
                          child: GlassSurface(
                            borderRadius: BorderRadius.circular(18),
                            opacity: 0.12,
                            blur: 12,
                            border: Border.all(
                              color: _capturedFile != null
                                  ? cs.primary
                                  : cs.outline.withValues(alpha: 0.16),
                              width: _capturedFile != null ? 2 : 1,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  _capturedFile != null
                                      ? Icons.check_circle_rounded
                                      : Icons.camera_alt_outlined,
                                  color: cs.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _capturedFile != null
                                        ? "Document captured — tap to retake"
                                        : "Take a photo or upload your document",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: (_selectedDocument == null || _capturedFile == null)
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VerificationInProgressPage(
                                      docType: _selectedDocument!,
                                      documentFile: _capturedFile!,
                                    ),
                                  ),
                                );
                              },
                        child: const Text("Next"),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline_rounded,
                              size: 14,
                              color: cs.onSurface.withValues(alpha: 0.42),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Secured by AES-256 encryption",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: cs.onSurface.withValues(alpha: 0.42),
                                fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }

  Widget _buildDocumentOption({
    required String id,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedDocument == id;
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => setState(() => _selectedDocument = id),
      borderRadius: BorderRadius.circular(18),
      child: GlassSurface(
        borderRadius: BorderRadius.circular(18),
        opacity: isSelected ? 0.18 : 0.12,
        blur: 12,
        border: Border.all(
          color: isSelected ? cs.primary : cs.outline.withValues(alpha: 0.16),
          width: isSelected ? 2 : 1,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: isSelected ? 0.24 : 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : cs.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
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
}
