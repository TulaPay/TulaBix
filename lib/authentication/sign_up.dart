import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/OTP_Verification_Screen.dart';
import 'package:tulapay/authentication/sign_in.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class Country {
  final String name;
  final String flag;
  final String code;

  Country({required this.name, required this.flag, required this.code});
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _acceptTerms = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<Country> _countries = [
    Country(name: "Cameroon", flag: '🇨🇲', code: '+237'),
    Country(name: 'Uganda', flag: '🇺🇬', code: '+256'),
    Country(name: 'Kenya', flag: '🇰🇪', code: '+254'),
    Country(name: 'Rwanda', flag: '🇷🇼', code: '+250'),
    Country(name: 'Tanzania', flag: '🇹🇿', code: '+255'),
    Country(name: 'Nigeria', flag: '🇳🇬', code: '+234'),
    Country(name: 'Ghana', flag: '🇬🇭', code: '+233'),
  ];
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countries[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                  child: ListView.separated(
                    itemCount: _countries.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: cs.onSurface.withValues(alpha: 0.08),
                    ),
                    itemBuilder: (context, index) {
                      final country = _countries[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Text(
                          country.flag,
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(
                          country.name,
                          style: GoogleFonts.plusJakartaSans(),
                        ),
                        trailing: Text(
                          country.code,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedCountry = country;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the Terms and Conditions to proceed'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      // Route to OTP verification immediately after basic registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            phoneNumber: "${_selectedCountry.code} ${_phoneController.text}",
            isSignUp: true,
          ),
        ),
      );
      debugPrint("Registering with: ${_selectedCountry.code}${_phoneController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: AppBackdrop(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Form(
              key: _formKey,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GlassSurface(
                        borderRadius: BorderRadius.circular(28),
                        opacity: 0.16,
                        blur: 18,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    colorScheme.primary.withValues(alpha: 0.26),
                                    colorScheme.secondary.withValues(alpha: 0.12),
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.person_add_alt_1_rounded,
                                color: colorScheme.primary,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Join TulaPay",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.8,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Create your account to start managing payments in one liquid workspace.",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.66),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),

                            _buildLabel("Full Name"),
                            TextFormField(
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                hintText: "Jean Dupont",
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Full name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            _buildLabel("Phone Number"),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: "700 000 000",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 8.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: _showCountryPicker,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _selectedCountry.flag,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _selectedCountry.code,
                                          style: TextStyle(
                                            color: colorScheme.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: colorScheme.onSurface,
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          height: 24,
                                          width: 1,
                                          color: colorScheme.outline.withValues(alpha: 0.24),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (value.length < 8) {
                                  return 'Enter a valid mobile number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            _buildLabel("Email Address (Optional)"),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: "jean.dupont@example.com",
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final emailRegex = RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  );
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Enter a valid email address';
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            _buildLabel("Password"),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: "Minimum 8 characters",
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                if (!value.contains(RegExp(r'[0-9]'))) {
                                  return 'Include at least one number';
                                }
                                if (!value.contains(RegExp(r'[A-Z]'))) {
                                  return 'Include at least one uppercase letter';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: _acceptTerms,
                                    activeColor: colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (value) => setState(
                                      () => _acceptTerms = value ?? false,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => _acceptTerms = !_acceptTerms,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: colorScheme.onSurface
                                                  .withValues(alpha: 0.72),
                                            ),
                                        children: [
                                          const TextSpan(text: "I agree to the "),
                                          TextSpan(
                                            text: "Terms of Service",
                                            style: TextStyle(
                                              color: colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const TextSpan(text: " and "),
                                          TextSpan(
                                            text: "Privacy Policy",
                                            style: TextStyle(
                                              color: colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),

                            ElevatedButton(
                              onPressed: _handleSignUp,
                              child: const Text("Create Account"),
                            ),
                            const SizedBox(height: 14),

                            Center(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account? ",
                                    style: TextStyle(
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.64,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SignIn(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Log In",
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
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

  Widget _buildLabel(String text) {
    return Padding(
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
}
