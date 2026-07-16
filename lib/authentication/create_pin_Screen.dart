import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/kyc_onboarding.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  String _pin = "";
  String _confirmPin = "";
  bool _isConfirming = false;
  String _errorMessage = "";

  void _onKeyTap(String val) {
    setState(() {
      _errorMessage = "";
      if (!_isConfirming) {
        if (_pin.length < 6) {
          _pin += val;
        }
        if (_pin.length == 6) {
          Future.delayed(const Duration(milliseconds: 250), () {
            if (mounted) {
              setState(() => _isConfirming = true);
            }
          });
        }
      } else {
        if (_confirmPin.length < 6) {
          _confirmPin += val;
        }
        if (_confirmPin.length == 6) {
          _verifyPin();
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      _errorMessage = "";
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else {
          _isConfirming = false;
        }
      } else if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  void _verifyPin() {
    if (_pin == _confirmPin) {
      _showSuccessDialog();
    } else {
      setState(() {
        _confirmPin = "";
        _errorMessage = "PINs do not match. Please try again.";
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                Icon(Icons.check_circle_outline, color: cs.primary, size: 80),
                const SizedBox(height: 20),
                Text(
                  "PIN Set Successfully",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Your 6-digit security PIN has been created. Use it to authorize transactions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurface.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const KycOnboarding()),
                      (route) => false,
                    );
                  },
                  child: const Text("Get Started"),
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
            if (_isConfirming) {
              setState(() {
                _isConfirming = false;
                _confirmPin = "";
              });
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              cs.primary.withValues(alpha: 0.28),
                              cs.secondary.withValues(alpha: 0.12),
                            ],
                          ),
                        ),
                        child: Icon(Icons.pin_rounded, color: cs.primary, size: 34),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _isConfirming ? "Confirm your PIN" : "Create a PIN",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: cs.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          _isConfirming
                              ? "Re-enter your PIN to confirm it's correct."
                              : "Enter 6 digits to keep your account and transactions secure.",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.66),
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) => _buildIndicator(index)),
                      ),
                      const SizedBox(height: 24),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      _buildKeypad(cs),
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

  Widget _buildIndicator(int index) {
    final bool isFilled = _isConfirming ? index < _confirmPin.length : index < _pin.length;
    final cs = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? cs.primary : cs.outline.withValues(alpha: 0.2),
        border: Border.all(
          color: isFilled ? cs.primary : cs.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
    );
  }

  Widget _buildKeypad(ColorScheme cs) {
    return Column(
      children: [
        _buildKeyRow(["1", "2", "3"], cs),
        const SizedBox(height: 16),
        _buildKeyRow(["4", "5", "6"], cs),
        const SizedBox(height: 16),
        _buildKeyRow(["7", "8", "9"], cs),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80),
            _buildKeyButton("0", cs),
            _buildBackspaceButton(cs),
          ],
        ),
      ],
    );
  }

  Widget _buildKeyRow(List<String> keys, ColorScheme cs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _buildKeyButton(key, cs)).toList(),
    );
  }

  Widget _buildKeyButton(String val, ColorScheme cs) {
    return InkWell(
      onTap: () => _onKeyTap(val),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: cs.surface.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
        ),
        child: Text(
          val,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton(ColorScheme cs) {
    return InkWell(
      onTap: _onBackspace,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: cs.surface.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
        ),
        child: Icon(
          Icons.backspace_outlined,
          size: 28,
          color: cs.onSurface,
        ),
      ),
    );
  }
}
