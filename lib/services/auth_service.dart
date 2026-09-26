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

  /// Deep link target Supabase redirects to after the user taps the
  /// confirmation link — registered as a real intent-filter/URL scheme on
  /// both platforms (AndroidManifest.xml, ios/Runner/Info.plist) and must
  /// also be allow-listed in the Supabase dashboard's Authentication > URL
  /// Configuration > Redirect URLs, or GoTrue silently falls back to the
  /// project's Site URL instead of this.
  static const emailConfirmRedirect = 'com.tulapay.tulapay://login-callback';

  /// Attaches + verifies an email on the already phone-authenticated signup
  /// session. Supabase has no separate "verify a second identifier" concept
  /// for an existing user — attaching an email always goes through GoTrue's
  /// secure email-change flow, which happens to be exactly right here too (a
  /// signup email add is genuinely a change from "no email" to "this
  /// email"). This can't send a 6-digit code — Supabase only lets you
  /// customize an auth email template's body once a real custom SMTP
  /// provider is configured, which isn't set up here, so the "Change Email
  /// Address" template stays on its default link-based content. Instead,
  /// this passes emailRedirectTo so the link deep-links back into the app;
  /// updateUser() generates a PKCE code_challenge whenever `email` is set
  /// (confirmed from the installed gotrue 2.27.2 client source), so the
  /// resulting link carries `?code=...`, which supabase_flutter's built-in
  /// deep-link handling (on by default) already completes automatically via
  /// getSessionFromUrl — no manual token parsing needed on this end.
  Future<void> sendEmailVerification(String email) async {
    await supabase.auth.updateUser(
      UserAttributes(email: email),
      emailRedirectTo: emailConfirmRedirect,
    );
  }

  /// Starts an account-recovery flow for an existing account (forgot
  /// password OR forgot PIN — this step is identical for both, it just
  /// proves phone ownership) — does not create a new user if the phone
  /// isn't already registered.
  Future<void> sendRecoveryOtp({required String phone}) {
    return supabase.auth.signInWithOtp(phone: phone, shouldCreateUser: false);
  }

  /// Verifying this OTP also signs the user in (Supabase returns a session
  /// on success), which is what lets resetPassword/setTransactionPin below
  /// act on their behalf immediately afterward without asking for the old
  /// password/PIN.
  Future<void> verifyRecoveryOtp({required String phone, required String token}) {
    return supabase.auth.verifyOTP(phone: phone, token: token, type: OtpType.sms);
  }

  /// Sets a new Auth password on the current (OTP-recovered) session — the
  /// actual "forgot password" action. Distinct from [setTransactionPin]:
  /// this changes the sign-in credential, not the 6-digit transaction PIN.
  Future<void> resetPassword(String newPassword) async {
    await supabase.auth.updateUser(UserAttributes(password: newPassword));
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
