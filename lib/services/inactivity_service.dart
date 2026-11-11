import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tulapay/authentication/sign_in.dart';
import 'package:tulapay/l10n/app_localizations.dart';
import 'package:tulapay/services/app_preferences.dart';
import 'package:tulapay/services/auth_service.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/services/navigation_service.dart';

/// Forces a sign-out if a signed-in merchant leaves the app idle (no taps)
/// or backgrounded for too long — a payments app shouldn't stay unlocked
/// indefinitely on a phone left unattended.
///
/// Two triggers, both resolving to the same timeout:
/// - foreground idle: a `Timer` reset on every tap anywhere in the app (see
///   the `Listener` wrapping `AppBackdrop` in main.dart), which fires if it
///   ever runs out uninterrupted.
/// - backgrounded too long: `AppLifecycleListener` timestamps when the app
///   is paused and checks the elapsed time on resume, since a backgrounded
///   app receives no taps to reset the foreground timer at all.
///
/// Starts/stops itself off `AuthService.onAuthStateChange` — no screen needs
/// to remember to call this.
class InactivityService {
  InactivityService._() {
    AuthService.instance.onAuthStateChange.listen((state) {
      switch (state.event) {
        case AuthChangeEvent.signedIn:
          start();
          break;
        case AuthChangeEvent.signedOut:
          stop();
          break;
        default:
          break;
      }
    });
  }
  static final InactivityService instance = InactivityService._();

  static const timeout = Duration(minutes: 15);

  bool _active = false;
  Timer? _idleTimer;
  DateTime? _backgroundedAt;
  AppLifecycleListener? _lifecycleListener;

  /// Call once at launch for a restored session — a fresh sign-in is caught
  /// by the onAuthStateChange listener above on its own.
  void start() {
    if (_active) return;
    _active = true;
    _resetIdleTimer();
    _lifecycleListener = AppLifecycleListener(
      onPause: () => _backgroundedAt = DateTime.now(),
      onResume: () {
        final backgroundedAt = _backgroundedAt;
        _backgroundedAt = null;
        if (backgroundedAt != null && DateTime.now().difference(backgroundedAt) >= timeout) {
          _forceSignOut();
        } else {
          _resetIdleTimer();
        }
      },
    );
  }

  void stop() {
    _active = false;
    _backgroundedAt = null;
    _idleTimer?.cancel();
    _idleTimer = null;
    _lifecycleListener?.dispose();
    _lifecycleListener = null;
  }

  /// Call on every tap — see the `Listener` in main.dart.
  void recordActivity() {
    if (!_active) return;
    _resetIdleTimer();
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(timeout, _forceSignOut);
  }

  Future<void> _forceSignOut() async {
    if (!_active) return;
    stop();
    try {
      await AuthService.instance.signOut();
    } catch (_) {
      // Best-effort — the session may already be gone; either way, kick the
      // UI back to sign-in below so a dead session can't sit on screen.
    }
    // Grab the localized message first — reset() drops the locale back to en.
    final signedOutMessage = lookupAppLocalizations(
      AppPreferences.instance.locale.value,
    ).signedOutInactivity;
    MerchantRepository.instance.clearCache();
    AppPreferences.instance.reset();

    final nav = navigatorKey.currentState;
    if (nav == null) return;
    nav.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignIn()),
      (route) => false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentContext;
      if (context == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(signedOutMessage),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }
}
