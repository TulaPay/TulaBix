import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/widgets/ui/icon_chip.dart';

/// Standard sub-page: pale background, a large left-aligned title in the app
/// bar, an optional back chevron in a white circular button, and optional
/// trailing actions (icon buttons or dark pills).
class AppScaffold extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget body;
  final bool showBack;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? bodyPadding;
  final bool scrollable;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.showBack = true,
    this.floatingActionButton,
    this.bodyPadding,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = bodyPadding != null
        ? Padding(padding: bodyPadding!, child: body)
        : body;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: showBack ? 0 : AppSpacing.xl,
        leadingWidth: 60,
        leading: showBack
            ? Padding(
                padding: const EdgeInsets.only(left: AppSpacing.lg),
                child: Center(
                  child: CircleIconButton(
                    Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.maybePop(context),
                  ),
                ),
              )
            : null,
        title: Text(title, style: AppText.screenTitle(size: 22)),
        actions: [
          ...actions.map((a) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Center(child: a),
              )),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        top: false,
        child: scrollable
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: content,
              )
            : content,
      ),
    );
  }
}
