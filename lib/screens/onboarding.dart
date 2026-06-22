import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for SystemChrome
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/screens/select_language.dart';
import 'package:tulapay/themes/app_theme.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 4;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'ONE ACCOUNT\nALL THE MONEY\nTHE WHOLE WORLD.',
      'subtitle':
          'Experience the future of finance with instant and secure transactions at your fingertips.',
      'image': 'easypayments.jpeg',
    },
    {
      'title': 'VIEW ALL YOUR\nANALYTICS IN ONE\nPLACE.',
      'subtitle':
          'Take control of your finances with powerful tools to track sales, manage inventory, and grow your enterprise.',
      'image': 'businessmanagement.jpeg',
    },
    {
      'title': '175 COUNTRIES\n50 CURRENCIES\nONE ACCOUNT',
      'subtitle':
          'Pay via Mobile Money, Cards, or Bank Transfers. We support all your favorite ways to pay.',
      'image': 'multiplepayments.jpeg',
    },
    {
      'title': 'SECURE PAYMENTS\nSAFE AND TRUSTED\nEVERY SINGLE TIME.',
      'subtitle':
          'Rest easy knowing every transaction is protected with bank-grade encryption and 24/7 fraud monitoring.',
      'image': 'security.jpeg',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onIntroEnd(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LanguageScreen()),
    );
  }

  void _onNextTap() {
    if (_currentPage < _numPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      _onIntroEnd(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Choose colors dynamically based on light/dark mode
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final activeIndicatorColor = isDark
        ? const Color(0xFF80A0FF)
        : AppColors.primary;
    final inactiveIndicatorColor = isDark
        ? Colors.white.withValues(alpha: 0.2)
        : AppColors.neutral.withValues(alpha: 0.3);

    // Apply immersive transparent bars to system chrome
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    return PopScope(
      // Intercept system back gestures to navigate back onboarding pages instead of exiting
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_currentPage > 0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 350),
            curve: Curves.fastOutSlowIn,
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // 1. PageView for full-screen background image only
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _numPages,
              itemBuilder: (context, index) {
                final item = _onboardingData[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Full screen background image
                    Image.asset(
                      'assets/images/${item['image']}',
                      fit: BoxFit.fitHeight,
                    ),

                    // Dynamic subtle overlay to darken/lighten the background image for premium contrast
                    Container(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.30 : 0.12,
                      ),
                    ),
                  ],
                );
              },
            ),

            // 2. Fixed overlay: Translucent Skip button capsule (top-right)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 20,
              child: _currentPage < _numPages - 1
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.35)
                                : Colors.white.withValues(alpha: 0.50),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.black.withValues(alpha: 0.06),
                              width: 1,
                            ),
                          ),
                          child: TextButton(
                            onPressed: () => _onIntroEnd(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: isDark
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : AppColors.textDark.withValues(alpha: 0.8),
                            ),
                            child: Text(
                              'Skip',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // 3. Fixed overlay: Glassmorphic text card and navigation controls at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height:
                  MediaQuery.of(context).size.height *
                  0.44, // Elegant 44% height bottom sheet
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.48)
                          : Colors.white.withValues(alpha: 0.68),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.12)
                            : Colors.black.withValues(alpha: 0.08),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    child: Column(
                      children: [
                        // Smooth cross-fading text block (Headline + Subtitle paragraph)
                        Expanded(
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                              child: Column(
                                key: ValueKey<int>(_currentPage),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _onboardingData[_currentPage]['title']!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: textColor,
                                      height: 1.3,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _onboardingData[_currentPage]['subtitle']!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      color: textColor.withValues(alpha: 0.70),
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Page Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _numPages,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 5,
                              width: _currentPage == index ? 26 : 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? activeIndicatorColor
                                    : inactiveIndicatorColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Capsule Gradient Action Button (Material/Ink structure for visible touch feedback)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _onNextTap,
                            borderRadius: BorderRadius.circular(30),
                            child: Ink(
                              height: 56,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isDark
                                      ? const [
                                          Color(0xFF4D73FF),
                                          Color(0xFF00E5FF),
                                        ]
                                      : const [
                                          Color(0xFF0000FF),
                                          Color(0xFF4D73FF),
                                        ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (isDark
                                                ? const Color(0xFF4D73FF)
                                                : AppColors.primary)
                                            .withValues(alpha: 0.35),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _currentPage == _numPages - 1
                                      ? 'GET STARTED'
                                      : 'NEXT',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isDark
                                        ? const Color(0xFF05081A)
                                        : Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Bottom safety spacing
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom > 0
                              ? 0
                              : 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
