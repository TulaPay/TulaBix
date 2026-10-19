import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tulapay/screens/onboarding.dart';
import 'package:tulapay/themes/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnBoardingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              Text(
                "TulaBiz",
                style: AppText.hero(size: 42, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "FINANCIAL ENGINE FOR MERCHANTS",
                style: AppText.microLabel(
                  color: Colors.white.withValues(alpha: 0.72),
                ),
              ),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 18,
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Powered by TulaPay",
                      style: AppText.caption(
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
