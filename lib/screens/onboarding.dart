import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/screens/Homepage.dart';
import 'package:tulapay/screens/select_language.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LanguageScreen()),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final pageDecoration = PageDecoration(
      titleTextStyle: GoogleFonts.inter(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
      ),
      bodyTextStyle: GoogleFonts.inter(
        fontSize: 16.0,
        color: colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      bodyPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
      pageColor: colorScheme.surface,
      imagePadding: const EdgeInsets.only(top: 40),
      imageFlex: 3,
      bodyFlex: 2,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: colorScheme.surface,
      allowImplicitScrolling: true,
      pages: [
        PageViewModel(
          title: "Seamless Payments",
          body: "Experience the future of finance with instant and secure transactions at your fingertips.",
          image: _buildImage('Revenue-bro.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Multiple Methods",
          body: "Pay via Mobile Money, Cards, or Bank Transfers. We support all your favorite ways to pay.",
          image: _buildImage('card.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Manage Your Business",
          body: "Take control of your finances with powerful tools to track sales, manage inventory, and grow your enterprise.",
          image: _buildImage('Team work-bro.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Secure Payments",
          body: "Rest easy knowing every transaction is protected with bank-grade encryption and 24/7 fraud monitoring.",
          image: _buildImage('Payment Information-bro.png'),
          decoration: pageDecoration,
        )
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: Icon(Icons.arrow_back, color: colorScheme.primary),
      skip: Text(
        'Skip',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
      next: Icon(Icons.arrow_forward, color: colorScheme.primary),
      done: Text(
        'Done',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: colorScheme.primary,
        ),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: colorScheme.primary.withValues(alpha: 0.2),
        activeSize: const Size(22.0, 10.0),
        activeColor: colorScheme.primary,
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
