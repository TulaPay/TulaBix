import 'package:flutter/material.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

  static const _base = 'https://docs.tulabix.com';

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: context.l10n.documentation,
      subtitle: context.l10n.guidesProductNotesAndImplementation,
      icon: Icons.menu_book_rounded,
      actionLabel: context.l10n.openDocs,
      onAction: () => AppFeedback.launch(context, _base),
      children: [
        GlassInfoCard(
          icon: Icons.play_circle_outline_rounded,
          title: context.l10n.gettingStarted,
          subtitle: context.l10n.productSetupAndYourFirst,
          onTap: () => AppFeedback.launch(context, '$_base/getting-started'),
        ),
        GlassInfoCard(
          icon: Icons.api_rounded,
          title: context.l10n.featureGuides,
          subtitle: context.l10n.paymentsDrawerAndSettingsFlows,
          onTap: () => AppFeedback.launch(context, '$_base/guides'),
        ),
        GlassInfoCard(
          icon: Icons.bug_report_outlined,
          title: context.l10n.troubleshooting,
          subtitle: context.l10n.commonIssuesAndWhatTo,
          onTap: () => AppFeedback.launch(context, '$_base/troubleshooting'),
        ),
      ],
    );
  }
}
