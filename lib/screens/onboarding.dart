import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/screens/select_language.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Track Your Growth',
      'subtitle':
          'Analyze your business performance with real-time analytics and detailed revenue reports.',
      'image': 'Browser stats-rafiki.png',
    },
    {
      'title': 'Smart Cash Management',
      'subtitle':
          'Handle physical and digital payments seamlessly in one unified platform designed for speed.',
      'image': 'Cash Payment-bro.png',
    },
    {
      'title': 'Global Card Payments',
      'subtitle':
          'Accept all major credit and debit cards from customers around the world with bank-grade security.',
      'image': 'Credit Card Payment-cuate.png',
    },
    {
      'title': 'Digital Wallet Power',
      'subtitle':
          'Store, send, and receive money instantly with our secure multi-currency e-wallet.',
      'image': 'E-Wallet-rafiki.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onFinish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LanguageScreen()),
    );
  }

  void _onNextTap() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _onFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo or App Name
                  Text(
                    "TulaBiz",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: colorScheme.primary,
                    ),
                  ),
                  if (_currentPage < _onboardingData.length - 1)
                    TextButton(
                      onPressed: _onFinish,
                      child: Text(
                        "Skip",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration Container
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Image.asset(
                              'assets/images/${_onboardingData[index]['image']}',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Text Content
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                _onboardingData[index]['title']!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _onboardingData[index]['subtitle']!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom Controls
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicators
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? colorScheme.primary
                              : colorScheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Primary Action Button
                  GestureDetector(
                    onTap: _onNextTap,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        _currentPage == _onboardingData.length - 1
                            ? Icons.check_rounded
                            : Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

