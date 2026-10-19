import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final topics = [
      _HelpTopic(
        icon: Icons.shopping_bag_outlined,
        title: 'Getting Started',
        subtitle: 'Setup, onboarding, and first transaction flow.',
      ),
      _HelpTopic(
        icon: Icons.lock_outline_rounded,
        title: 'Security & Access',
        subtitle: 'PIN, password, device security, and account recovery.',
      ),
      _HelpTopic(
        icon: Icons.payments_outlined,
        title: 'Payments & Transfers',
        subtitle: 'Links, cash receipts, QR payments, and bank transfers.',
      ),
      _HelpTopic(
        icon: Icons.support_agent_rounded,
        title: 'Contact Support',
        subtitle: 'Talk to the team or send a ticket with logs.',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "Help & Support",
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: GlassSurface(
                child: Row(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: context.primaryTintColor,
                      ),
                      child: Icon(
                        Icons.help_center_rounded,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How can we help?',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Find answers, launch support, or learn the product flow.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: context.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final topic = topics[index];
                return GlassSurface(
                  borderRadius: AppRadius.smAll,
                  border: Border.all(color: context.hairlineColor),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: context.primaryTintColor,
                        ),
                        child: Icon(
                          topic.icon,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        topic.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        topic.subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: context.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                );
              }, childCount: topics.length),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
              child: Text(
                'Quick actions',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ActionTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Start a chat',
                  subtitle: 'Get a human response during business hours.',
                  onTap: () {},
                ),
                _ActionTile(
                  icon: Icons.mail_outline_rounded,
                  title: 'Email support',
                  subtitle: 'Send details and attachments to the support team.',
                  onTap: () {},
                ),
                _ActionTile(
                  icon: Icons.article_outlined,
                  title: 'Read documentation',
                  subtitle: 'Browse feature guides and troubleshooting notes.',
                  onTap: () {},
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpTopic {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HelpTopic({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.hairlineColor)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: context.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    size: 20, color: context.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
