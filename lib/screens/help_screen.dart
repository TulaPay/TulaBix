import 'package:flutter/material.dart';
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
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: GlassSurface(
                borderRadius: BorderRadius.circular(28),
                opacity: 0.16,
                blur: 18,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.28),
                            colorScheme.secondary.withValues(alpha: 0.12),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.help_center_rounded,
                        color: colorScheme.primary,
                        size: 32,
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
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Find answers, launch support, or learn the product flow.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: colorScheme.onSurfaceVariant,
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  borderRadius: BorderRadius.circular(24),
                  opacity: 0.14,
                  blur: 14,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withValues(alpha: 0.22),
                              colorScheme.secondary.withValues(alpha: 0.10),
                            ],
                          ),
                        ),
                        child: Icon(
                          topic.icon,
                          color: colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        topic.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        topic.subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
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
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                'Quick actions',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ActionTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Start a chat',
                  subtitle: 'Get a human response during business hours.',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _ActionTile(
                  icon: Icons.mail_outline_rounded,
                  title: 'Email support',
                  subtitle: 'Send details and attachments to the support team.',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
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
    return GlassSurface(
      borderRadius: BorderRadius.circular(24),
      opacity: 0.14,
      blur: 14,
      padding: const EdgeInsets.all(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.22),
                      colorScheme.secondary.withValues(alpha: 0.12),
                    ],
                  ),
                ),
                child: Icon(icon, color: colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
