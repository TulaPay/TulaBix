import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tulapay/screens/splash.dart';
import 'package:tulapay/screens/Navigation_bar.dart';
import 'package:tulapay/services/app_preferences.dart';
import 'package:tulapay/services/auth_service.dart';
import 'package:tulapay/services/supabase_client.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/widgets/glass_effects.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();

  // A restored session skips straight into the app — pull the merchant's
  // saved preferences (theme/language) so they carry over immediately.
  if (AuthService.instance.isSignedIn) {
    await AppPreferences.instance.hydrate();
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
        return MaterialApp(
          title: "TulaBiz",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: AppPreferences.instance.themeMode.value,
          locale: AppPreferences.instance.locale.value,
          supportedLocales: AppPreferences.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return AppBackdrop(child: child ?? const SizedBox.shrink());
          },
          home: AuthService.instance.isSignedIn
              ? const Navigation_Bar()
              : SplashScreen(),
        );
      },
    );
  }
}
