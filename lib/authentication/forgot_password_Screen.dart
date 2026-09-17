import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tulapay/authentication/sign_in.dart';
import 'package:tulapay/services/auth_service.dart';
import 'package:tulapay/widgets/glass_effects.dart';

/// Account-recovery flow — verify phone ownership via OTP, then choose to
/// reset either the Auth password (real "forgot password", previously
/// missing entirely — this screen used to claim to do this but only ever
/// reset the PIN) or the 6-digit transaction PIN. Both share the same OTP
/// step since it's the same underlying proof-of-ownership.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

enum _ResetChoice { password, pin }

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // 0: Phone, 1: OTP, 2: Choice, 3: Reset
  int _currentStep = 0;
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

  _ResetChoice? _choice;

  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _obscurePin = true;
  bool _obscureConfirmPin = true;

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

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
    _pinController.dispose();
    _confirmPinController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _sendResetOtp() async {
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

  Future<void> _verifyResetOtp() async {
    final otp = _otpControllers.map((e) => e.text).join();
    if (otp.length != 6) return;

    setState(() => _isSubmitting = true);
    try {
      await AuthService.instance.verifyRecoveryOtp(phone: _fullPhone, token: otp);
      if (!mounted) return;
      setState(() {
        _currentStep = 2;
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

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      if (_choice == _ResetChoice.password) {
        await AuthService.instance.resetPassword(_newPasswordController.text);
      } else {
        await AuthService.instance.setTransactionPin(_pinController.text);
      }
      await AuthService.instance.signOut();
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showError(e.message);
      return;
    } on PostgrestException catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showError(e.message);
      return;
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showError('Something went wrong — please try again.');
      return;
    }
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    final isPassword = _choice == _ResetChoice.password;
    showDialog(
      context: context,
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          content: GlassSurface(
            borderRadius: BorderRadius.circular(24),
            opacity: 0.18,
            blur: 18,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: cs.primary, size: 64),
                const SizedBox(height: 16),
                Text(
                  isPassword ? "Password Reset Successful" : "PIN Reset Successful",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isPassword
                      ? "Your password has been reset. Sign in with your new password."
                      : "Your PIN has been reset. Sign in with your password as usual.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurface.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const SignIn()),
                      (route) => false,
                    );
                  },
                  child: const Text("Go to Login"),
                ),
              ],
            ),
          ),
        );
      },
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
                        if (_currentStep == 2) _buildChoiceStep(theme),
                        if (_currentStep == 3) _buildResetStep(theme),
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
          "Account Recovery",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Verify your phone to reset your password or PIN.",
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
          onPressed: _isSubmitting ? null : _sendResetOtp,
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
          "Verify Your Phone",
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
          onPressed: _isSubmitting ? null : _verifyResetOtp,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Verify Code"),
        ),
      ],
    );
  }

  Widget _buildChoiceStep(ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What would you like to reset?",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Your phone is verified — choose one to continue.",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.66),
          ),
        ),
        const SizedBox(height: 24),
        _ChoiceTile(
          icon: Icons.password_rounded,
          title: 'Reset password',
          subtitle: 'Change the password you use to sign in.',
          onTap: () => setState(() {
            _choice = _ResetChoice.password;
            _currentStep = 3;
          }),
        ),
        const SizedBox(height: 12),
        _ChoiceTile(
          icon: Icons.lock_outline_rounded,
          title: 'Reset PIN',
          subtitle: 'Change your 6-digit transaction PIN.',
          onTap: () => setState(() {
            _choice = _ResetChoice.pin;
            _currentStep = 3;
          }),
        ),
      ],
    );
  }

  Widget _buildResetStep(ThemeData theme) {
    return _choice == _ResetChoice.password
        ? _buildPasswordFields(theme)
        : _buildPinFields(theme);
  }

  Widget _buildPasswordFields(ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reset Password",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Create a new password for your TulaBiz account.",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.66),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        _buildLabel("New Password"),
        TextFormField(
          controller: _newPasswordController,
          obscureText: _obscureNewPassword,
          decoration: InputDecoration(
            hintText: "Minimum 8 characters",
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscureNewPassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
            ),
          ),
          validator: (value) =>
              (value == null || value.length < 8) ? 'Must be at least 8 characters' : null,
        ),
        const SizedBox(height: 16),
        _buildLabel("Confirm New Password"),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            hintText: "Re-enter your new password",
            prefixIcon: const Icon(Icons.lock_reset),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
          ),
          validator: (value) {
            if (value != _newPasswordController.text) return 'Passwords do not match';
            return null;
          },
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _handleReset,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Reset Password"),
        ),
      ],
    );
  }

  Widget _buildPinFields(ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reset PIN",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Create a new 6-digit PIN for your TulaBiz account.",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.66),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        _buildLabel("New PIN"),
        TextFormField(
          controller: _pinController,
          obscureText: _obscurePin,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            hintText: "Enter 6-digit PIN",
            counterText: "",
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscurePin ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePin = !_obscurePin),
            ),
          ),
          validator: (value) => (value == null || value.length < 6) ? 'Must be 6 digits' : null,
        ),
        const SizedBox(height: 16),
        _buildLabel("Confirm New PIN"),
        TextFormField(
          controller: _confirmPinController,
          obscureText: _obscureConfirmPin,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            hintText: "Confirm 6-digit PIN",
            counterText: "",
            prefixIcon: const Icon(Icons.lock_reset),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPin ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () => setState(() => _obscureConfirmPin = !_obscureConfirmPin),
            ),
          ),
          validator: (value) {
            if (value != _pinController.text) return 'PINs do not match';
            return null;
          },
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _handleReset,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Reset PIN"),
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

class _ChoiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: cs.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
