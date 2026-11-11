import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/settlement_account_screen.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

// Brief reassurance screen shown right after KybDocumentsScreen uploads
// everything — was between ID capture and Business Details in the old flow
// order; now sits after all KYB documents are captured (the "we're
// reviewing your documents" copy only makes sense once documents actually
// exist), right before the final Settlement Account step.
class VerificationInProgressPage extends StatefulWidget {
  final String merchantId;

  const VerificationInProgressPage({super.key, required this.merchantId});

  @override
  State<VerificationInProgressPage> createState() =>
      _VerificationInProgressPageState();
}

class _VerificationInProgressPageState
    extends State<VerificationInProgressPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: AppBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        children: [
                          GlassSurface(
                            borderRadius: BorderRadius.circular(12),
                            opacity: 0.16,
                            blur: 18,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: const BoxDecoration(),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: AppColors.primary,
                                        child: const Icon(
                                          Icons.description_outlined,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        context.l10n.verificationInProgress,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: cs.onSurface,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        context.l10n.weReReviewingYourDocuments,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: cs.primary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        context.l10n.yourBusinessIsCurrentlyIn,
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: cs.onSurface.withValues(
                                                alpha: 0.66,
                                              ),
                                              height: 1.5,
                                            ),
                                      ),
                                      const SizedBox(height: 20),
                                      const Divider(),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.timer_outlined,
                                            size: 20,
                                            color: cs.primary,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            context.l10n.estimatedTime,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w600,
                                              color: cs.onSurface,
                                            ),
                                          ),
                                          Text(
                                            context.l10n.n24Hours,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w700,
                                              color: cs.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildInfoCard(
                                  context,
                                  icon: Icons.notifications_active_outlined,
                                  title: context.l10n.getNotified,
                                  description:
                                      context.l10n.weLlSendAnSms,
                                ),
                                _buildInfoCard(
                                  context,
                                  icon: Icons.verified_user_outlined,
                                  title: context.l10n.bankGradeSecurity,
                                  description:
                                      context.l10n.yourDataIsEncryptedAnd,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: GlassSurface(
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SettlementAccountScreen(
                                merchantId: widget.merchantId,
                              ),
                            ),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.account_balance_outlined),
                        label: Text(context.l10n.continueLabel),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.support_agent_rounded),
                        label: Text(context.l10n.contactSupport),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final cs = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.hairlineColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.primaryTintColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: cs.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.cardTitle(size: 15, color: cs.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppText.caption(
                      color: context.textSecondary,
                    ).copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
