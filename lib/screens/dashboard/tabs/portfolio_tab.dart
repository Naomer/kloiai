import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

/// Portfolio builder: upload work, KLOI rewrites for SEO (UI only for now).
class PortfolioTab extends StatelessWidget {
  const PortfolioTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final projects = [
      const _ProjectItem(
        title: 'SaaS Analytics Dashboard',
        client: 'Acme Analytics',
        location: 'Remote',
        tags: ['Flutter', 'Web', 'Charts'],
        excerpt:
            'B2B analytics dashboard enabling cohort insights and revenue tracking.',
        link: 'https://example.com/dashboard',
      ),
      const _ProjectItem(
        title: 'AI Client Finder Agent',
        client: 'KLOI',
        location: 'Remote',
        tags: ['AI', 'Agents', 'Automation'],
        excerpt:
            'Agent that discovers leads and drafts proposals automatically.',
        link: 'https://example.com/agent',
      ),
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Portfolio',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ).copyWith(color: isDark ? Colors.white : Colors.black),
              ),
              Icon(
                RemixIcons.settings_3_line,
                size: 20,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.12)
                          : Colors.black.withOpacity(0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        RemixIcons.search_line,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('Search portfolio', style: TextStyle()),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white : Colors.black,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  RemixIcons.upload_2_line,
                  color: isDark ? Colors.black87 : Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...List.generate(
            projects.length,
            (i) => Padding(
              padding: EdgeInsets.only(
                bottom: i == projects.length - 1 ? 0 : 12,
              ),
              child: _ProjectCard(item: projects[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectItem {
  const _ProjectItem({
    required this.title,
    required this.client,
    required this.location,
    required this.tags,
    required this.excerpt,
    required this.link,
  });

  final String title;
  final String client;
  final String location;
  final List<String> tags;
  final String excerpt;
  final String link;
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.item});
  final _ProjectItem item;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  item.client.isNotEmpty ? item.client[0].toUpperCase() : 'C',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.client,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.location,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                RemixIcons.share_line,
                size: 18,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: item.tags.map((t) => _Tag(t)).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            item.excerpt,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Edit'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark ? Colors.white24 : Colors.black12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Open'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.black87,
          fontSize: 11,
        ),
      ),
    );
  }
}
