import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../widgets/glass_widgets.dart';

import '../proposals/proposal_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  static const routeName = '/job-details';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topInset = MediaQuery.of(context).padding.top + kToolbarHeight;
    // For now we use mock data; later we will pass a real job model via args.
    final job =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {
          'title': 'Flutter App Bug Fixing',
          'platform': 'Upwork',
          'budget': '\$600',
          'match': 87,
          'status': 'New',
          'description':
              'We need a Flutter developer to fix several bugs in our existing app and improve performance.',
        };

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 48,

        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: isDark
                  ? Colors.black.withOpacity(0.80)
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        ),

        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GlassCircleIcon(
            child: PhosphorIcon(PhosphorIcons.arrowLeft()),
            onTap: () => Navigator.of(context).pop(),
            diameter: 29,
            iconSize: 16,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: const GlassCircleIcon(child: Icon(RemixIcons.bookmark_line)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GlassCircleIcon(child: PhosphorIcon(PhosphorIcons.export())),
          ),
        ],
      ),

      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(16, topInset + 16, 16, 16),
            children: [
              _SectionCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : Colors.black,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'IP',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.black87 : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job['title'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            job['platform'] as String,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                RemixIcons.map_pin_line,
                                size: 16,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Heeminstadok, France',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                RemixIcons.calendar_2_line,
                                size: 16,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Posted on 03 July',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              // Apply before / salary range
              _SectionCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Apply Before',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '30 July, 2021',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Salary Range',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '100k - 120k/yearly',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              // Job Location
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Job Location',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Remote',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              // Skills Needed
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skills Needed',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _Chip('Tech Skills'),
                        _Chip('Tech Skills'),
                        _Chip('Tech Skills'),
                        _Chip('Tech Skills'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              // Job Description
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Job Description',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job['description'] as String,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 78),
            ],
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? Colors.white
                                : Colors.black,
                            foregroundColor: isDark
                                ? Colors.black
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () {},
                          child: const Text('Let KLOI apply'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.black.withOpacity(0.80),
                                side: BorderSide(
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.black12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  ProposalScreen.routeName,
                                  arguments: job,
                                );
                              },
                              child: Text(
                                'View Proposal Draft',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.white12
              : Colors.black12,
        ),
      ),
      child: child,
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          fontSize: 12,
        ),
      ),
    );
  }
}
