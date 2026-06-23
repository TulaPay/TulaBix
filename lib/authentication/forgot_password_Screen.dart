import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/sign_in.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _currentStep = 0; // 0: Phone, 1: OTP, 2: New PIN
  final _formKey = GlobalKey<FormState>();

  // Phone Step
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

  // OTP Step
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  // PIN Step
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _obscurePin = true;
  bool _obscureConfirmPin = true;

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countries[0];
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      _resetPassword();
    }
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      // Simulate Success
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text(
                "Password Reset Successful",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text("Your password has been reset successfully. You can now login with your new PIN."),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SignIn()),
                    (route) => false,
                  );
                },
                child: const Text("Go to Login"),
              )
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_currentStep == 0) _buildPhoneStep(colorScheme),
                if (_currentStep == 1) _buildOtpStep(colorScheme),
                if (_currentStep == 2) _buildPinStep(colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneStep(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text("Forgot Password", style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: colorScheme.primary)),
        const SizedBox(height: 8),
        Text("Enter your phone number to receive a verification code.", style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6))),
        const SizedBox(height: 48),
        _buildLabel("Phone Number"),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "700 000 000",
            prefixIcon: GestureDetector(
              onTap: _showCountryPicker,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 12),
                  Text(_selectedCountry.flag, style: const TextStyle(fontSize: 20)),
                  const Icon(Icons.arrow_drop_down),
                  Text(_selectedCountry.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(width: 1, height: 24, color: colorScheme.outline.withValues(alpha: 0.3)),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) _nextStep();
          },
          child: const Text("Send Code"),
        ),
      ],
    );
  }

  Widget _buildOtpStep(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Icon(Icons.mark_email_read_outlined, size: 80, color: colorScheme.primary),
        const SizedBox(height: 32),
        Text("Verify Your Phone", style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text("We've sent a 6-digit code to ${_selectedCountry.code} ${_phoneController.text}", textAlign: TextAlign.center, style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6))),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) => _buildOtpBox(index, colorScheme)),
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () {
            String otp = _otpControllers.map((e) => e.text).join();
            if (otp.length == 6) _nextStep();
          },
          child: const Text("Verify Code"),
        ),
      ],
    );
  }

  Widget _buildPinStep(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text("Reset PIN", style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: colorScheme.primary)),
        const SizedBox(height: 8),
        Text("Create a new 6-digit PIN for your TulaPay account.", style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6))),
        const SizedBox(height: 40),
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
        const SizedBox(height: 20),
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
              icon: Icon(_obscureConfirmPin ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscureConfirmPin = !_obscureConfirmPin),
            ),
          ),
          validator: (value) {
            if (value != _pinController.text) return 'PINs do not match';
            return null;
          },
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: _resetPassword,
          child: const Text("Reset Password"),
        ),
      ],
    );
  }

  // Inside forgot_password_Screen.dart - _buildOtpBox method

  Widget _buildOtpBox(int index, ColorScheme colorScheme) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _otpControllers[index].text.isNotEmpty
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.2),
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
            color: colorScheme.onSurface, // Added color for visibility
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Country", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _countries.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Text(_countries[index].flag, style: const TextStyle(fontSize: 24)),
                  title: Text(_countries[index].name),
                  trailing: Text(_countries[index].code, style: const TextStyle(fontWeight: FontWeight.bold)),
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
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
        child: Text(text, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
      );
}
