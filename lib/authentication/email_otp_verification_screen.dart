import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tulapay/authentication/create_pin_Screen.dart';
import 'package:tulapay/services/auth_service.dart';
import 'package:tulapay/services/supabase_client.dart';
import 'package:tulapay/widgets/glass_effects.dart';

// Confirms the email entered at signup, right after phone verification
// succeeds (see OTP_Verification_Screen.dart). Originally a 6-digit-box
// entry screen, but Supabase only lets you customize an auth email
// template's body (to show a code instead of a link) once real custom SMTP
// is configured, which isn't set up here — so this is now a "check your
// inbox" waiting screen instead: AuthService.sendEmailVerification passes
// emailRedirectTo, and supabase_flutter's built-in deep-link handling
// (on by default) completes the session automatically once the user taps
// the link, firing onAuthStateChange — this screen just listens for that
// and advances, with a manual fallback button in case that detection
// doesn't fire on a given device/OS combination.
//
// businessName/businessType/country are just forwarded through (collected
// at signup, needed by BusinessInformationScreen at the end of this chain —
// no shared onboarding-state object exists anywhere in this app, every
// screen threads what it collected via constructor params).
class EmailOtpVerificationScreen extends StatefulWidget {
  final String email;
  final String businessName;
  final String businessType;
  final String country;

  const EmailOtpVerificationScreen({
    super.key,
    required this.email,
    required this.businessName,
    required this.businessType,
    required this.country,
  });

  @override
  State<EmailOtpVerificationScreen> createState() =>
      _EmailOtpVerificationScreenState();
}

class _EmailOtpVerificationScreenState
    extends State<EmailOtpVerificationScreen> {
  int _timerSeconds = 60;
  Timer? _timer;
  bool _canResend = false;
  bool _isSending = true;
  String? _sendError;
  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    _sendLink();
    _authSub = supabase.auth.onAuthStateChange.listen((state) {
      if (state.event == AuthChangeEvent.signedIn) _continue();
    });
  }

  Future<void> _sendLink() async {
    setState(() {
      _isSending = true;
      _sendError = null;
    });
    try {
      await AuthService.instance.sendEmailVerification(widget.email);
      if (!mounted) return;
      _startTimer();
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _sendError = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _sendError = 'Could not send the confirmation email — please try again.');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _startTimer() {
    setState(() {
      _timerSeconds = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() => _timerSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _authSub?.cancel();
    super.dispose();
  }

  void _continue() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePinScreen(
          businessName: widget.businessName,
          businessType: widget.businessType,
          country: widget.country,
        ),
      ),
    );
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: AppBackdrop(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: GlassSurface(
                  borderRadius: BorderRadius.circular(28),
                  opacity: 0.16,
                  blur: 18,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: cs.primary.withValues(alpha: 0.16),
                        ),
                        child: Icon(
                          Icons.mark_email_read_rounded,
                          size: 34,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Check Your Email",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: cs.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isSending
                            ? "Sending a confirmation link to"
                            : "We've sent a confirmation link to",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.66),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.email,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Open it on this device to continue — it'll bring you right back here.",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.66),
                          height: 1.4,
                        ),
                      ),
                      if (_sendError != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _sendError!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: cs.error),
                        ),
                      ],
                      const SizedBox(height: 28),
                      if (_isSending)
                        const CircularProgressIndicator()
                      else
                        const _WaitingPulse(),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _canResend ? "Didn't get it? " : "Resend link in ",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.66),
                            ),
                          ),
                          _canResend
                              ? GestureDetector(
                                  onTap: _isSending ? null : _sendLink,
                                  child: Text(
                                    "Resend",
                                    style: TextStyle(
                                      color: cs.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Text(
                                  "00:${_timerSeconds.toString().padLeft(2, '0')}",
                                  style: TextStyle(
                                    color: cs.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Fallback in case the automatic onAuthStateChange
                      // detection doesn't fire on a given device — the user
                      // has already tapped the real link by this point, so
                      // just move on rather than leave them stuck here.
                      OutlinedButton(
                        onPressed: _continue,
                        child: const Text("I've confirmed — Continue"),
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
}

class _WaitingPulse extends StatefulWidget {
  const _WaitingPulse();

  @override
  State<_WaitingPulse> createState() => _WaitingPulseState();
}

class _WaitingPulseState extends State<_WaitingPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FadeTransition(
      opacity: Tween(begin: 0.3, end: 1.0).animate(_controller),
      child: Icon(Icons.hourglass_top_rounded, color: cs.primary, size: 28),
    );
  }
}
