import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/models/merchant.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _street = TextEditingController();
  final _city = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    MerchantRepository.instance.myMerchant().then((Merchant m) {
      if (!mounted) return;
      setState(() {
        _name.text = m.ownerName;
        _email.text = m.ownerEmail ?? '';
        _street.text = m.addressStreet ?? '';
        _city.text = m.addressCity ?? '';
        _loading = false;
      });
    }).catchError((_) {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _street.dispose();
    _city.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      AppFeedback.toast(context, 'Name cannot be blank');
      return;
    }
    setState(() => _saving = true);
    try {
      await MerchantRepository.instance.updateContact(
        ownerName: _name.text.trim(),
        ownerEmail: _email.text.trim().isEmpty ? null : _email.text.trim(),
        addressStreet: _street.text.trim(),
        addressCity: _city.text.trim(),
      );
      if (!mounted) return;
      AppFeedback.toast(context, 'Profile updated');
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        AppFeedback.toast(context, 'Could not save — try again');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                GlassSurface(
                  borderRadius: BorderRadius.circular(28),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _field('Owner name', _name),
                      const SizedBox(height: 14),
                      _field('Email', _email,
                          keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 14),
                      _field('Street', _street),
                      const SizedBox(height: 14),
                      _field('City', _city),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            "Save changes",
                            style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800),
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
