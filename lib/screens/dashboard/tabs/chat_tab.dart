import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:remixicon/remixicon.dart';

/// Full KLOI chat UI (streaming, speech, TTS, model dropdown).
class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> with WidgetsBindingObserver {
  final TextEditingController controller = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();
  final List<String> _suggestions = const [
    'Best day job',
    'Client Day',
    'Find Writter Job',
  ];
  bool isRecording = false;
  bool _isStreaming = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    inputFocusNode.dispose();
    super.dispose();
  }

  void _openChat(String? initialPrompt) {
    Navigator.of(context).pushNamed(
      '/chat',
      arguments: initialPrompt == null || initialPrompt.isEmpty
          ? null
          : {'initialPrompt': initialPrompt},
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: isDark ? Colors.white10 : Colors.black,
                    child: PhosphorIcon(
                      PhosphorIcons.userCircle(),
                      size: 28,
                      color: isDark ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Nolan Naos',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/history'),
                    child: Icon(
                      RemixIcons.history_line,
                      size: 20,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/chat'),
                    child: Icon(
                      FeatherIcons.edit,
                      size: 20,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 1,
            color: isDark ? Colors.white24 : Colors.black12,
          ),
        ),
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: _buildLanding(context),
    );
  }

  Widget _buildLanding(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const SizedBox(height: 40),
            Text(
              'Need anything?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Our kloi AI assistant helps you find exactly what you need—faster and easier than ever.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                borderRadius: BorderRadius.circular(999),
                boxShadow: isDark
                    ? null
                    : const [
                        BoxShadow(
                          color: Color(0x11000000),
                          blurRadius: 10,
                          offset: Offset(0, 12),
                        ),
                      ],
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.04),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    child: Icon(
                      RemixIcons.attachment_2,
                      color: isDark ? Colors.white70 : Colors.black54,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: inputFocusNode,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: isRecording
                            ? 'Listening...'
                            : 'Ask Anything...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: isRecording
                              ? Colors.red
                              : (isDark ? Colors.white60 : Colors.black45),
                          fontSize: 13,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openChat(controller.text.trim()),
                    child: Container(
                      width: 39,
                      height: 39,
                      decoration: BoxDecoration(
                        color: _isStreaming
                            ? Colors.grey
                            : (isRecording
                                  ? Colors.red
                                  : (isDark ? Colors.white : Colors.black)),
                        shape: BoxShape.circle,
                      ),
                      child: _isStreaming
                          ? const Icon(Icons.stop_rounded, color: Colors.white)
                          : (controller.text.trim().isNotEmpty
                                ? Icon(
                                    Icons.arrow_upward_rounded,
                                    color: isDark
                                        ? Colors.black87
                                        : Colors.white,
                                  )
                                : (isRecording
                                      ? const Icon(
                                          Icons.stop_rounded,
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          RemixIcons.voiceprint_fill,
                                          color: isDark
                                              ? Colors.black87
                                              : Colors.white,
                                          size: 19,
                                        ))),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 44,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: _suggestions
                      .map(
                        (s) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () => _openChat(s),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.06)
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PhosphorIcon(
                                    PhosphorIcons.sealCheck(),
                                    size: 16,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    s,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaretIcon extends StatelessWidget {
  const _CaretIcon({required this.color, required this.down, this.size = 12});

  final Color color;
  final bool down;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _CaretPainter(color: color, down: down),
    );
  }
}

class _CaretPainter extends CustomPainter {
  _CaretPainter({required this.color, required this.down});

  final Color color;
  final bool down;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.18
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path();
    if (down) {
      path.moveTo(w * 0.2, h * 0.35);
      path.lineTo(w * 0.5, h * 0.65);
      path.lineTo(w * 0.8, h * 0.35);
    } else {
      path.moveTo(w * 0.2, h * 0.65);
      path.lineTo(w * 0.5, h * 0.35);
      path.lineTo(w * 0.8, h * 0.65);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CaretPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.down != down;
  }
}
