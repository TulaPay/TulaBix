import 'package:flutter/material.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';
import 'package:tulapay/widgets/ui/ui.dart';

const _supportEmail = 'support@tulabix.com';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  static const _faqs = <(String, String)>[
    (
      'How long do settlements take?',
      'Completed payments are batched and paid to your settlement account on '
          'the next business day. You can see each batch under Payments.'
    ),
    (
      'Why is a payment still pending?',
      'Mobile money confirmations can take a few minutes. If it stays pending '
          'for more than an hour, contact support with the reference.'
    ),
    (
      'How do I change my payout number?',
      'Payout account changes are handled by support for security — email us '
          'from the button below and we\'ll verify and update it.'
    ),
    (
      'What are the fees?',
      'Per-channel rates are listed under Settings → Payment Methods → Billing.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Help Center',
      subtitle: 'Answers to common questions, plus a direct line to support.',
      icon: Icons.support_agent_rounded,
      actionLabel: 'Email support',
      onAction: () => AppFeedback.email(
        context,
        to: _supportEmail,
        subject: 'TulaBix merchant support',
      ),
      children: [
        for (final faq in _faqs)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: GlassSurface(
              padding: EdgeInsets.zero,
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: 2),
                  childrenPadding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
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
        const SizedBox(height: AppSpacing.sm),
        GlassInfoCard(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'Live chat',
          subtitle: 'Available Mon–Fri, 8am–6pm WAT.',
          onTap: () => AppFeedback.toast(
              context, 'Live chat opens during business hours'),
        ),
        const SizedBox(height: AppSpacing.sm),
        GlassInfoCard(
          icon: Icons.mail_outline_rounded,
          title: 'Email support',
          subtitle: _supportEmail,
          onTap: () => AppFeedback.email(context, to: _supportEmail),
        ),
      ],
    );
  }
}
