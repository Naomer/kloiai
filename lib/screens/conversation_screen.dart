import 'dart:ui';

import 'package:flutter/material.dart';

import 'listening_screen.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  static const routeName = '/conversation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/icon/icon.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),
          // UI content
          const ConversationView(),
        ],
      ),
    );
  }
}

class ConversationView extends StatelessWidget {
  const ConversationView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          // Buttons Row - reaches screen edges
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
              const Spacer(),
              CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                child: const Icon(Icons.favorite, color: Colors.redAccent),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                child: const Icon(Icons.share, color: Colors.white),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                child: const Icon(Icons.more_vert, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          ConversationBubble(
                            title: 'Perplexity',
                            subtitle: 'Hello!\nHow can I assist you today?',
                          ),
                          SizedBox(height: 20),
                          ConversationBubble(isUser: true, subtitle: 'Hi'),
                          SizedBox(height: 20),
                          ConversationBubble(
                            isUser: true,
                            subtitle:
                                'I need a best user friendly and best category mobile app industry ?',
                          ),
                          SizedBox(height: 20),
                          ConversationBubble(
                            title: 'Perplexity',
                            subtitle:
                                'Based on recent analyses of mobile app user experience (UX) in 2025, here are five standout examples of the most user-friendly apps across key categories.',
                          ),
                          SizedBox(height: 20),
                          ConversationBubble(
                            title: 'Perplexity',
                            subtitle:
                                'Clean, minimalist interface with real-time maps and simple options (e.g., fare splitting for groups).\nIt applies principles like Hick\'s Law to minimize choices, making ride booking quick and stress-free.\n\nMap-based search with grouped results (e.g., by proximity) and easy favorites for comparisons.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.13),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'ASK Anything.....',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                            letterSpacing: 0.3,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        ListeningScreen.routeName,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(
                                          alpha: 0.25,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.mic_none_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConversationBubble extends StatelessWidget {
  const ConversationBubble({
    super.key,
    this.title,
    required this.subtitle,
    this.isUser = false,
  });

  final String? title;
  final String subtitle;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 0.5,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Text(
          subtitle,
          textAlign: isUser ? TextAlign.right : TextAlign.left,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.4,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
