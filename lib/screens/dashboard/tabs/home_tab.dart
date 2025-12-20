import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

import '../../jobs/job_details_screen.dart';
import '../../notification/notification_screen.dart';
import '../../search/search_screen.dart';

/// Home tab: glassy hero + matches preview (Job list & flows live under Home).
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Container(color: theme.scaffoldBackgroundColor),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(color: Colors.transparent),
        ),
        SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Hi!',
                        //   style:
                        //       const TextStyle(
                        //         fontSize: 10,
                        //         fontWeight: FontWeight.w600,
                        //       ).copyWith(
                        //         color: isDark ? Colors.white70 : Colors.black54,
                        //       ),
                        // ),
                        // const SizedBox(height: 2),
                        Text(
                          'Good Morning', //upgrades morning/ afternoon / evening based on DateTime.now().hour
                          style:
                              const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ).copyWith(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed(NotificationScreen.routeName);
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 35,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1C1C1E)
                                  : Colors.white,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: iconoir.Bell(
                              width: 17,
                              height: 17,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          if (NotificationScreen.hasUnread())
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(SearchScreen.routeName);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1C1C1E)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? Colors.white10 : Colors.black12,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                RemixIcons.search_line,
                                color: isDark ? Colors.white60 : Colors.black45,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Search for jobs, company, etc.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 12),
                    // Container(
                    //   width: 46,
                    //   height: 46,
                    //   decoration: BoxDecoration(
                    //     color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                    //     shape: BoxShape.circle,
                    //   ),
                    //   alignment: Alignment.center,
                    //   child: Icon(
                    //     RemixIcons.equalizer_2_line,
                    //     color: isDark ? Colors.white70 : Colors.black54,
                    //     size: 20,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Recomendations',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recommendations.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final rec = _recommendations[index];
                      return _RecommendationCard(rec: rec);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Jobs',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ).copyWith(color: isDark ? Colors.white : Colors.black),
                    ),
                    Text(
                      'View all',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  _mockJobs.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == _mockJobs.length - 1 ? 0 : 10,
                    ),
                    child: _RecentJobCard(job: _mockJobs[index]),
                  ),
                ),
                const SizedBox(height: 74),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressRingLabel extends StatelessWidget {
  const _ProgressRingLabel({
    required this.percent,
    required this.color,
    required this.track,
    this.size = 24,
    this.strokeWidth = 3,
  });
  final int percent;
  final Color color;
  final Color track;
  final double size;
  final double strokeWidth;
  @override
  Widget build(BuildContext context) {
    final labelColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: (percent / 100).clamp(0.0, 1.0),
                strokeWidth: strokeWidth,
                backgroundColor: track,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Text(
                '$percent%',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 9,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text('match', style: TextStyle(color: labelColor, fontSize: 11)),
      ],
    );
  }
}

class _MockJobPreview {
  const _MockJobPreview({
    required this.title,
    required this.company,
    required this.match,
    required this.tags,
  });
  final String title;
  final String company;
  final int match;
  final List<String> tags;
}

final _mockJobs = [
  const _MockJobPreview(
    title: 'Web Researcher',
    company: 'Willms Inc',
    match: 87,
    tags: ['Full Time', 'Part Time', 'WFO'],
  ),
  const _MockJobPreview(
    title: 'UX Researcher',
    company: 'Bosco and Sons',
    match: 70,
    tags: ['Full Time', 'WFO'],
  ),
];

class _Recommendation {
  const _Recommendation({
    required this.company,
    required this.title,
    required this.location,
    required this.tags,
  });
  final String company;
  final String title;
  final String location;
  final List<String> tags;
}

final _recommendations = [
  const _Recommendation(
    company: 'Willms Inc',
    title: 'Web Researcher',
    location: 'Heeminstadok, France',
    tags: ['Full Time', 'Part Time', 'WFO'],
  ),
  const _Recommendation(
    company: 'Bosco and Sons',
    title: 'UX Researcher',
    location: 'Remote',
    tags: ['Full Time', 'WFO'],
  ),
];

class _RecentJobCard extends StatelessWidget {
  const _RecentJobCard({required this.job});
  final _MockJobPreview job;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            JobDetailsScreen.routeName,
            arguments: {
              'title': job.title,
              'platform': job.company,
              'budget': '',
              'match': job.match,
              'status': 'New',
              'description':
                  'Detailed description for ${job.title}. Later this will come from the backend.',
            },
          );
        },
        child: Container(
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
          child: Row(
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
                child: Icon(
                  RemixIcons.briefcase_2_line,
                  size: 18,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: const TextStyle(fontWeight: FontWeight.w600)
                          .copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      job.company,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: job.tags.map((t) => _Tag(t)).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _ProgressRingLabel(
                percent: job.match,
                color: (Theme.of(context).brightness == Brightness.dark
                    ? (job.match > 75 ? Colors.green : Colors.white54)
                    : (job.match > 75 ? Colors.green : Colors.black38)),
                track: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white12
                    : Colors.black12,
                size: 40,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.rec});
  final _Recommendation rec;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 260,
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  rec.company.isNotEmpty ? rec.company[0].toUpperCase() : 'C',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rec.company,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      rec.location,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                RemixIcons.bookmark_line,
                size: 18,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            rec.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: rec.tags.map((t) => _Tag(t)).toList(),
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

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.value,
    required this.color,
    required this.background,
    this.size = 20,
    this.strokeWidth = 3,
  });
  final double value;
  final Color color;
  final Color background;
  final double size;
  final double strokeWidth;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value.clamp(0.0, 1.0),
        strokeWidth: strokeWidth,
        backgroundColor: background,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
