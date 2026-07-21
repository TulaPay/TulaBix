import 'package:flutter/material.dart';
import 'package:tulapay/screens/splash.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/widgets/glass_effects.dart';

void main() {
  runApp(const TulaApp());
}

class TulaApp extends StatelessWidget {
  const TulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tula-Merchant",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      builder: (context, child) {
        return AppBackdrop(child: child ?? const SizedBox.shrink());
      },
      home: SplashScreen(),
    );
  }
}
