import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../widgets/glass_widgets.dart';

class ProposalScreen extends StatelessWidget {
  const ProposalScreen({super.key});

  static const routeName = '/proposal';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final job =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {'title': 'Flutter App Bug Fixing'};

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            padding: const EdgeInsets.only(
              top: kToolbarHeight + 12,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            children: [
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                            (job['title'] as String).isNotEmpty
                                ? (job['title'] as String)[0].toUpperCase()
                                : 'J',
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
                                style:
                                    const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ).copyWith(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (job['platform'] as String?) ?? '',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Opening message',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ).copyWith(color: isDark ? Colors.white : Colors.black),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      maxLines: 4,
                      initialValue:
                          "Hi there, I'd be happy to help you fix and improve your Flutter app.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why you’re a good fit',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ).copyWith(color: isDark ? Colors.white : Colors.black),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      maxLines: 5,
                      initialValue:
                          "I've shipped multiple production Flutter apps and have strong experience debugging performance and UI issues.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio links',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ).copyWith(color: isDark ? Colors.white : Colors.black),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      maxLines: 3,
                      initialValue:
                          'https://yourportfolio.com\nhttps://github.com/yourprofile',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attachments',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ).copyWith(color: isDark ? Colors.white : Colors.black),
                    ),
                    const SizedBox(height: 8),

                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: open file picker
                      },
                      icon: Icon(
                        RemixIcons.attachment_2,
                        size: 18,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      label: Text(
                        'Add attachment',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.black12,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
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
                          child: const Text('Send Proposal'),
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
                                    ? Colors.white.withOpacity(0.06)
                                    : Colors.black.withOpacity(0.04),
                                side: BorderSide(
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.black12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                'Preview Draft',
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
