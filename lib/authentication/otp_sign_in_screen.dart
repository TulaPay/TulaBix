import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tulapay/authentication/sign_in.dart';
import 'package:tulapay/screens/Navigation_bar.dart';
import 'package:tulapay/services/auth_service.dart';
import 'package:tulapay/widgets/glass_effects.dart';

/// Alternate sign-in path: phone + OTP instead of phone + password.
/// Password sign-in ([SignIn]) stays the default/primary path — this is
/// additive. Reuses the same session-establishing OTP mechanic already
/// proven in the account-recovery flow (AuthService.sendRecoveryOtp/
/// verifyRecoveryOtp), just entered from login instead of recovery.
class OtpSignInScreen extends StatefulWidget {
  const OtpSignInScreen({super.key});

  @override
  State<OtpSignInScreen> createState() => _OtpSignInScreenState();
}

class _OtpSignInScreenState extends State<OtpSignInScreen> {
  int _currentStep = 0; // 0: Phone, 1: OTP
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final List<Country> _countries = [
    Country(name: 'Cameroon', flag: '🇨🇲', code: '+237'),
    Country(name: 'Uganda', flag: '🇺🇬', code: '+256'),
    Country(name: 'Kenya', flag: '🇰🇪', code: '+254'),
    Country(name: 'Rwanda', flag: '🇷🇼', code: '+250'),
    Country(name: 'Tanzania', flag: '🇹🇿', code: '+255'),
    Country(name: 'Nigeria', flag: '🇳🇬', code: '+234'),
    Country(name: 'Ghana', flag: '🇬🇭', code: '+233'),
  ];
  late Country _selectedCountry;

  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  bool _isSubmitting = false;

  String get _fullPhone => "${_selectedCountry.code}${_phoneController.text}";

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countries[0];
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      await AuthService.instance.sendRecoveryOtp(phone: _fullPhone);
      if (!mounted) return;
      setState(() {
        _currentStep = 1;
        _isSubmitting = false;
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showError(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showError('Something went wrong — please try again.');
    }
  }

  Future<void> _verifyAndSignIn() async {
    final otp = _otpControllers.map((e) => e.text).join();
    if (otp.length != 6) return;

    setState(() => _isSubmitting = true);
    try {
      await AuthService.instance.verifyRecoveryOtp(phone: _fullPhone, token: otp);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Navigation_Bar()),
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showError(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showError('Something went wrong — please try again.');
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
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_currentStep == 0) _buildPhoneStep(theme),
                        if (_currentStep == 1) _buildOtpStep(theme),
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

  Widget _buildPhoneStep(ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sign In with OTP",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "We'll text a 6-digit code to your registered phone number.",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.66),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        _buildLabel("Phone Number"),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "700 000 000",
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 8.0),
              child: GestureDetector(
                onTap: _showCountryPicker,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_selectedCountry.flag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 4),
                    Text(
                      _selectedCountry.code,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: cs.onSurface),
                    const SizedBox(width: 4),
                    Container(
                      height: 24,
                      width: 1,
                      color: cs.outline.withValues(alpha: 0.24),
                    ),
                  ],
                ),
              ),
            ),
          ),
          validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _sendCode,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Send Code"),
        ),
      ],
    );
  }

  Widget _buildOtpStep(ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.mark_email_read_outlined, size: 80, color: cs.primary),
        const SizedBox(height: 24),
        Text(
          "Enter Your Code",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "We've sent a 6-digit code to ${_selectedCountry.code} ${_phoneController.text}",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.66),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) => _buildOtpBox(index, cs)),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _verifyAndSignIn,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Sign In"),
        ),
      ],
    );
  }

  Widget _buildOtpBox(int index, ColorScheme cs) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _otpControllers[index].text.isNotEmpty
              ? cs.primary
              : cs.outline.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _otpControllers[index],
          focusNode: _otpFocusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              _otpFocusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _otpFocusNodes[index - 1].requestFocus();
            }
            setState(() {});
          },
        ),
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: GlassSurface(
            borderRadius: BorderRadius.circular(28),
            opacity: 0.18,
            blur: 18,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Select Country",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.42,
                  child: ListView.builder(
                    itemCount: _countries.length,
                    itemBuilder: (context, index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text(
                        _countries[index].flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        _countries[index].name,
                        style: GoogleFonts.plusJakartaSans(),
                      ),
                      trailing: Text(
                        _countries[index].code,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onTap: () {
                        setState(() => _selectedCountry = _countries[index]);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
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
