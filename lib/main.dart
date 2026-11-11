import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/l10n/app_localizations.dart';
import 'package:tulapay/screens/splash.dart';
import 'package:tulapay/screens/Navigation_bar.dart';
import 'package:tulapay/services/app_preferences.dart';
import 'package:tulapay/services/auth_service.dart';
import 'package:tulapay/services/inactivity_service.dart';
import 'package:tulapay/services/navigation_service.dart';
import 'package:tulapay/services/push_notification_service.dart';
import 'package:tulapay/services/supabase_client.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/widgets/glass_effects.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // DateFormat patterns (MMM d, …) follow Intl.defaultLocale, set below from
  // the merchant's language preference.
  await initializeDateFormatting();
  await initSupabase();

  // Initialize Push Notification Service
  await PushNotificationService.instance.initialize();

  // Touching .instance wires up its onAuthStateChange listener (handles
  // every future sign-in/sign-out on its own) — start() below only covers
  // a session already restored before this listener existed.
  InactivityService.instance;

  // A restored session skips straight into the app — pull the merchant's
  // saved preferences (theme/language) so they carry over immediately.
  if (AuthService.instance.isSignedIn) {
    await AppPreferences.instance.hydrate();
    PushNotificationService.instance.listenToRealtimeNotifications();
    InactivityService.instance.start();
  }

  runApp(const TulaApp());
}

class TulaApp extends StatelessWidget {
  const TulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppPreferences.instance.listenable,
      builder: (context, _) {
        Intl.defaultLocale = AppPreferences.instance.locale.value.languageCode;
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: "TulaBiz",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: AppPreferences.instance.themeMode.value,
          locale: AppPreferences.instance.locale.value,
          supportedLocales: AppPreferences.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            // Any tap anywhere in the app counts as activity — resets
            // InactivityService's idle timer. Translucent so it never
            // blocks hit-testing to the real content underneath.
            return Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) => InactivityService.instance.recordActivity(),
              child: AppBackdrop(child: child ?? const SizedBox.shrink()),
            );
          },
          home: AuthService.instance.isSignedIn
              ? const Navigation_Bar()
              : SplashScreen(),
        );
      },
    );
  }
}
