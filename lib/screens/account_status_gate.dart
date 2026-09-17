import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/services/auth_service.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/widgets/glass_effects.dart';

/// Waiting-for-review screen shown while `merchant.accountStatus ==
/// 'pending_kyb'`. Pull-to-refresh re-fetches the merchant row so an admin
/// approval in the Control Panel is reflected without forcing a re-login.
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
                GlassSurface(
                  borderRadius: BorderRadius.circular(28),
                  opacity: 0.16,
                  blur: 18,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: cs.primary,
                        child: const Icon(Icons.hourglass_top_rounded,
                            color: Colors.white, size: 32),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Verification in progress',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "We're reviewing your documents",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "You'll get full access to TulaBiz as soon as our team "
                        "approves your submission. Pull down to check again.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          color: cs.onSurface.withValues(alpha: 0.66),
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
                    child: const Text('Sign out'),
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

/// Blocked screen shown for `rejected` / `suspended` / `closed` account
/// status, surfacing the real reason from `merchants.suspended_reason` when
/// present.
class AccountBlockedScreen extends StatelessWidget {
  final Merchant merchant;
  const AccountBlockedScreen({super.key, required this.merchant});

  String get _title => switch (merchant.accountStatus) {
        'rejected' => 'Verification rejected',
        'suspended' => 'Account suspended',
        _ => 'Account closed',
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
              GlassSurface(
                borderRadius: BorderRadius.circular(28),
                opacity: 0.16,
                blur: 18,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: cs.error,
                      child: const Icon(Icons.block_rounded,
                          color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
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
                          color: cs.onSurface.withValues(alpha: 0.66),
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
                      'Contact support if you believe this is a mistake.',
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
                  child: const Text('Sign out'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wraps [child] (the normal app shell) and only renders it once the
/// signed-in merchant's `accountStatus` is `active`. Shows a pending-review
/// or blocked screen otherwise. Fails open (shows [child]) on a fetch
/// error — this is a UX signal, not the security boundary; RLS and the
/// SECURITY DEFINER RPCs are what actually enforce access server-side.
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
      final merchant =
          await MerchantRepository.instance.myMerchant(refresh: refresh);
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
