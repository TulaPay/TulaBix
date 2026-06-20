import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              setState(() {
                _isConfirming = true;
              });
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
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
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
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            Text(
              "PIN Set Successfully",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your 6-digit security PIN has been created. Use it to authorize transactions.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to Homepage
                Navigator.of(context).pop(); 
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: const Text("Get Started"),
            ),
          ],
        ),
      ),
    );
  }

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
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              _isConfirming ? "Confirm your PIN" : "Create a PIN",
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _isConfirming
                    ? "Re-enter your PIN to confirm it's correct."
                    : "Enter 6 digits to keep your account and transactions secure.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 60),
            
            // PIN Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) => _buildIndicator(index)),
            ),
            
            const SizedBox(height: 24),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              ),
            
            const Spacer(),
            
            // Custom Keypad
            _buildKeypad(colorScheme),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final bool isFilled = _isConfirming ? index < _confirmPin.length : index < _pin.length;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.2),
        border: Border.all(
          color: isFilled ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
    );
  }

  Widget _buildKeypad(ColorScheme colorScheme) {
    return Column(
      children: [
        _buildKeyRow(["1", "2", "3"]),
        const SizedBox(height: 20),
        _buildKeyRow(["4", "5", "6"]),
        const SizedBox(height: 20),
        _buildKeyRow(["7", "8", "9"]),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80), 
            _buildKeyButton("0"),
            _buildBackspaceButton(colorScheme),
          ],
        ),
      ],
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _buildKeyButton(key)).toList(),
    );
  }

  Widget _buildKeyButton(String val) {
    return InkWell(
      onTap: () => _onKeyTap(val),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: Text(
          val,
          style: GoogleFonts.inter(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton(ColorScheme colorScheme) {
    return InkWell(
      onTap: _onBackspace,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: Icon(
          Icons.backspace_outlined,
          size: 28,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
