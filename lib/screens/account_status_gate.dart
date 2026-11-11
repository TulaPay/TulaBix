import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/services/auth_service.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/themes/app_tokens.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

class PendingReviewScreen extends StatelessWidget {
  final VoidCallback onRefresh;
  const PendingReviewScreen({super.key, required this.onRefresh});

  Future<void> _handleRefresh() async => onRefresh();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: AppBackdrop(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.hourglass_top_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.l10n.verificationInProgress,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.weReReviewingYourDocuments,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        context.l10n.youLlGetFullAccess2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: cs.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => AuthService.instance.signOut(),
                    child: Text(context.l10n.signOut),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountBlockedScreen extends StatelessWidget {
  final Merchant merchant;
  const AccountBlockedScreen({super.key, required this.merchant});

  String _title(BuildContext context) => switch (merchant.accountStatus) {
    'rejected' => context.l10n.verificationRejected,
    'suspended' => context.l10n.accountSuspended,
    _ => context.l10n.accountClosed,
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: AppBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.negative,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.block_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _title(context),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (merchant.suspendedReason != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        merchant.suspendedReason!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: cs.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                    if (merchant.suspendedAt != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('MMM d, yyyy').format(merchant.suspendedAt!),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.contactSupportIfYouBelieve,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => AuthService.instance.signOut(),
                  child: Text(context.l10n.signOut),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountStatusGate extends StatefulWidget {
  final Widget child;
  const AccountStatusGate({super.key, required this.child});

  @override
  State<AccountStatusGate> createState() => _AccountStatusGateState();
}

class _AccountStatusGateState extends State<AccountStatusGate> {
  Merchant? _merchant;
  bool _loading = true;
  bool _failedOpen = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool refresh = false}) async {
    if (mounted) setState(() => _loading = true);
    try {
      final merchant = await MerchantRepository.instance.myMerchant(
        refresh: refresh,
      );
      if (!mounted) return;
      setState(() {
        _merchant = merchant;
        _loading = false;
        _failedOpen = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failedOpen = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final merchant = _merchant;
    if (merchant == null || _failedOpen || merchant.isActive) {
      return widget.child;
    }
    if (merchant.isBlocked) {
      return AccountBlockedScreen(merchant: merchant);
    }
    return PendingReviewScreen(onRefresh: () => _load(refresh: true));
  }
}
