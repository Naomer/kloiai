import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../../proposals/proposal_screen.dart';

/// Shows generated proposals (mocked for now).
class ProposalsTab extends StatelessWidget {
  const ProposalsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final mockProposals = [
      const _ProposalItem(
        title: 'Web Researcher',
        company: 'Willms Inc',
        location: 'Heeminstadok, France',
        tags: ['Full Time', 'Part Time', 'WFO'],
        excerpt:
            'Hi there, I specialize in Flutter dashboards and research tooling. I can help you streamline data collection and insights.',
      ),
      const _ProposalItem(
        title: 'UX Researcher',
        company: 'Bosco and Sons',
        location: 'Remote',
        tags: ['Full Time', 'WFO'],
        excerpt:
            'Hello, I’ve led UX research for SaaS apps and mobile products. I can design studies and synthesize findings for the team.',
      ),
    ];

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8, bottom: 12),
          child: Text(
            'Proposals',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
        _GroupCard(
          children: [
            for (final item in mockProposals)
              _ListRow(
                iconWidget: _CompanyAvatar(text: item.company),
                title: item.title,
                subtitle: '${item.company} • ${item.location}',
                trailing: Icon(
                  RemixIcons.arrow_right_s_line,
                  size: 20,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  ProposalScreen.routeName,
                  arguments: {'title': item.title},
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ProposalItem {
  const _ProposalItem({
    required this.title,
    required this.company,
    required this.location,
    required this.tags,
    required this.excerpt,
  });

  final String title;
  final String company;
  final String location;
  final List<String> tags;
  final String excerpt;
}

class _CompanyAvatar extends StatelessWidget {
  const _CompanyAvatar({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.06);
    final fg = isDark ? Colors.white70 : Colors.black87;
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        text.isNotEmpty ? text[0].toUpperCase() : 'C',
        style: TextStyle(fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.black87, fontSize: 11),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final List<Widget> children;
  const _GroupCard({required this.children});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final border = isDark ? Colors.white10 : Colors.black12;
    final sep = isDark ? Colors.white12 : Colors.black12;
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) Container(height: 1, color: sep),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _ListRow extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _ListRow({
    this.icon,
    this.iconWidget,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (iconWidget != null)
            iconWidget!
          else if (icon != null)
            Icon(icon, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ],
            ),
          ),
          trailing ?? const Icon(RemixIcons.arrow_right_s_line, size: 20),
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: content,
      );
    }
    return content;
  }
}
