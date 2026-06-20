import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IdVerification extends StatefulWidget {
  const IdVerification({super.key});

  @override
  State<IdVerification> createState() => _IdVerificationState();
}

class _IdVerificationState extends State<IdVerification> {
  String? _selectedDocument;

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "ID Verification",
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "To ensure the security of your account, please provide a valid government-issued document.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              
              // Document Options
              _buildDocumentOption(
                id: 'national_id',
                title: "National ID Card (CNI)",
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 16),
              _buildDocumentOption(
                id: 'drivers_license',
                title: "Driver's License",
                icon: Icons.drive_eta_outlined,
              ),
              const SizedBox(height: 16),
              _buildDocumentOption(
                id: 'passport',
                title: "International Passport",
                icon: Icons.public_outlined,
              ),
              
              const Spacer(),
              
              // Next Button
              ElevatedButton(
                onPressed: _selectedDocument == null 
                  ? null 
                  : () {
                      // TODO: Navigate to Camera/Upload Screen
                      debugPrint("Proceeding with: $_selectedDocument");
                    },
                child: const Text("Next"),
              ),
              
              const SizedBox(height: 24),
              
              // Security Footer
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Secured by AES-256 encryption",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
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
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => setState(() => _selectedDocument = id),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withValues(alpha: 0.05) : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Radio<String>(
              value: id,
              groupValue: _selectedDocument,
              activeColor: colorScheme.primary,
              onChanged: (val) => setState(() => _selectedDocument = val),
            ),
          ],
        ),
      ),
    );
  }
}
