import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tulapay/services/supabase_client.dart';

/// Thin wrapper around Supabase Auth for the merchant app. Reconciles the
/// UI's three auth concepts against Supabase's actual primitives:
/// - phone+password is the ordinary sign-in credential (no OTP on login);
/// - OTP is used only to confirm a phone at signup and to authenticate a
///   password-reset ("forgot PIN") flow;
/// - the 6-digit transaction PIN is not a Supabase Auth concept at all — it
///   never leaves this service as anything but a boolean verify result, and
///   is stored/checked exclusively via the set_transaction_pin /
///   verify_transaction_pin RPCs (hashed server-side, never client-side).
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  Stream<AuthState> get onAuthStateChange => supabase.auth.onAuthStateChange;
  Session? get currentSession => supabase.auth.currentSession;
  bool get isSignedIn => currentSession != null;

  Future<void> signUp({
    required String phone,
    required String password,
    String? fullName,
    String? email,
  }) {
    return supabase.auth.signUp(
      phone: phone,
      password: password,
      data: {
        if (fullName != null && fullName.isNotEmpty) 'full_name': fullName,
        if (email != null && email.isNotEmpty) 'email': email,
      },
    );
  }

  Future<void> signInWithPassword({
    required String phone,
    required String password,
  }) {
    return supabase.auth.signInWithPassword(phone: phone, password: password);
  }

  /// Confirms the phone number entered at signup.
  Future<void> verifySignupOtp({required String phone, required String token}) {
    return supabase.auth.verifyOTP(phone: phone, token: token, type: OtpType.sms);
  }

  Future<void> resendSignupOtp({required String phone}) {
    return supabase.auth.resend(type: OtpType.sms, phone: phone);
  }

  /// Starts a "forgot PIN" flow for an existing account — does not create a
  /// new user if the phone isn't already registered.
  Future<void> sendPinResetOtp({required String phone}) {
    return supabase.auth.signInWithOtp(phone: phone, shouldCreateUser: false);
  }

  /// Verifying this OTP also signs the user in (Supabase returns a session
  /// on success), which is what lets setTransactionPin below act on their
  /// behalf immediately afterward without asking for their old PIN.
  Future<void> verifyPinResetOtp({required String phone, required String token}) {
    return supabase.auth.verifyOTP(phone: phone, token: token, type: OtpType.sms);
  }

  Future<void> setTransactionPin(String pin) async {
    await supabase.rpc('set_transaction_pin', params: {'p_pin': pin});
  }

  Future<bool> verifyTransactionPin(String pin) async {
    final result = await supabase.rpc('verify_transaction_pin', params: {'p_pin': pin});
    return result as bool;
  }

  Future<void> signOut() {
    return supabase.auth.signOut();
  }
}
