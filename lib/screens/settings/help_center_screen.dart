import 'package:flutter/material.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';
import 'package:tulapay/widgets/ui/ui.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

const _supportEmail = 'support@tulabix.com';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  List<(String, String)> _faqs(BuildContext context) => <(String, String)>[
    (
      context.l10n.howLongDoSettlementsTake,
      context.l10n.completedPaymentsAreBatchedAnd2
    ),
    (
      context.l10n.whyIsAPaymentStill,
      context.l10n.mobileMoneyConfirmationsCanTake2
    ),
    (
      context.l10n.howDoIChangeMy,
      context.l10n.payoutAccountChangesAreHandled2
    ),
    (
      context.l10n.whatAreTheFees,
      context.l10n.perChannelRatesAreListed
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: context.l10n.helpCenter,
      subtitle: context.l10n.answersToCommonQuestionsPlus,
      icon: Icons.support_agent_rounded,
      actionLabel: context.l10n.emailSupport,
      onAction: () => AppFeedback.email(
        context,
        to: _supportEmail,
        subject: context.l10n.tulabixMerchantSupport,
      ),
      children: [
        for (final faq in _faqs(context))
          Padding(
            padding: EdgeInsets.zero,
            child: GlassSurface(
              border: Border(bottom: BorderSide(color: context.hairlineColor)),
              padding: EdgeInsets.zero,
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(vertical: 2),
                  childrenPadding:
                      const EdgeInsets.fromLTRB(0, 0, 0, AppSpacing.lg),
                  title: Text(faq.$1,
                      style: AppText.cardTitle(
                          color: Theme.of(context).colorScheme.onSurface)),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(faq.$2,
                          style: AppText.body(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.xl),
        GlassInfoCard(
          icon: Icons.chat_bubble_outline_rounded,
          title: context.l10n.liveChat,
          subtitle: context.l10n.availableMonFri8am6pm,
          onTap: () => AppFeedback.toast(
              context, context.l10n.liveChatOpensDuringBusiness),
        ),
        GlassInfoCard(
          icon: Icons.mail_outline_rounded,
          title: context.l10n.emailSupport,
          subtitle: _supportEmail,
          onTap: () => AppFeedback.email(context, to: _supportEmail),
        ),
      ],
    );
  }
}
