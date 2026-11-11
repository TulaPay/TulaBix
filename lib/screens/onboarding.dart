import 'package:flutter/material.dart';
import 'package:tulapay/screens/select_language.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> get _onboardingData => [
    {
      'title': context.l10n.trackYourGrowth,
      'subtitle':
          context.l10n.analyzeYourBusinessPerformanceWith,
      'image': 'Browser stats-rafiki.png',
    },
    {
      'title': context.l10n.smartCashManagement,
      'subtitle':
          context.l10n.handlePhysicalAndDigitalPayments,
      'image': 'Cash Payment-bro.png',
    },
    {
      'title': context.l10n.globalCardPayments,
      'subtitle':
          context.l10n.acceptAllMajorCreditAnd,
      'image': 'Credit Card Payment-cuate.png',
    },
    {
      'title': context.l10n.digitalWalletPower,
      'subtitle':
          context.l10n.storeSendAndReceiveMoney,
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    style: AppText.screenTitle(
                        size: 18, color: colorScheme.primary),
                  ),
                  if (_currentPage < _onboardingData.length - 1)
                    TextButton(
                      onPressed: _onFinish,
                      child: Text(
                        context.l10n.skip,
                        style: AppText.pillLabel(
                            color: colorScheme.onSurfaceVariant),
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
                              color: context.isDark ? AppColors.trackDark : AppColors.primaryTint,
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
                                style: AppText.screenTitle(
                                    size: 24, color: colorScheme.onSurface),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _onboardingData[index]['subtitle']!,
                                textAlign: TextAlign.center,
                                style: AppText.body(
                                    size: 16,
                                    color: colorScheme.onSurfaceVariant),
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
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 30),
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
                              : context.hairlineColor,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                    ),
                  ),
                  // Primary Action Button
                  GestureDetector(
                    onTap: _onNextTap,
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _currentPage == _onboardingData.length - 1
                            ? Icons.check_rounded
                            : Icons.chevron_right_rounded,
                        color: colorScheme.onPrimary,
                        size: 22,
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

