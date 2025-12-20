import 'dart:ui';

import 'package:flutter/material.dart';

class ListeningScreen extends StatelessWidget {
  const ListeningScreen({super.key});

  static const routeName = '/listening';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/icon/icon.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(color: Colors.black.withValues(alpha: 0.15)),
          ),
          // UI content
          const ListeningView(),
        ],
      ),
    );
  }
}

class ListeningView extends StatelessWidget {
  const ListeningView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Star icon in center
          const Expanded(
            child: Center(
              child: Icon(Icons.star, size: 42, color: Colors.white),
            ),
          ),
          // Listening panel at bottom
          Padding(
            padding: const EdgeInsets.all(14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.close, color: Colors.white70),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "Listening...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white70,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "What movies are playing near me, and which ones are trending right now?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const SoundWave(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SoundWave extends StatelessWidget {
  const SoundWave({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(15, (index) {
        final height = (index % 4 + 1) * 8.0;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          width: 4,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
