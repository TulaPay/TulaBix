import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';

/// Standard sub-page: pale background, a large left-aligned title in the app
/// bar, a plain back chevron, and optional
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
        titleSpacing: showBack ? 0 : AppSpacing.xxl,
        leadingWidth: 56,
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 28),
                onPressed: () => Navigator.maybePop(context),
              )
            : null,
        title: Text(title, style: AppText.screenTitle(size: 20)),
        actions: [
          ...actions.map(
            (a) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Center(child: a),
            ),
          ),
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
