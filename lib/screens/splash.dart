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
    // Navigate to the next screen after 3 seconds
    Timer(const Duration(seconds: 5), () {
      // TODO: Navigate to your next screen (e.g., Login or Home)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnBoardingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Brand Logo/Name Section
              Text(
                "TulaPay",
                style: AppText.hero(size: 42, color: colorScheme.onPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                "Securely Connected",
                style: AppText.microLabel(
                  color: colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
              ),
              const Spacer(flex: 2),
              // Footer Section
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 18,
                      color: colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Powered by TulaPay",
                      style: AppText.caption(
                        color: colorScheme.onPrimary.withValues(alpha: 0.7),
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
