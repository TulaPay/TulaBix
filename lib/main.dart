import 'package:flutter/material.dart';
import 'package:tulapay/authentication/kyc_onboarding.dart';
import 'package:tulapay/authentication/upgrade_to_tier%202.dart';
import 'package:tulapay/authentication/verification_in_progress_page.dart';
import 'package:tulapay/screens/Navigation_bar.dart';
import 'package:tulapay/screens/splash.dart';
import 'package:tulapay/themes/app_theme.dart';

void main(){
  runApp(const TulaApp());
}

class TulaApp extends StatelessWidget {
  const TulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      title: "Tula-Merchant",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home:   Navigation_Bar()
    );
  }
}
