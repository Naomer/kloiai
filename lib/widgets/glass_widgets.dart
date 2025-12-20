import 'dart:ui';

import 'package:flutter/material.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = 28,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.18),
                Colors.white.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class BlurryBackground extends StatelessWidget {
  const BlurryBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.2, -0.4),
          radius: 1.5,
          colors: [
            Color(0xFFD47A5A),
            Color(0xFFB8553D),
            Color(0xFF8B3A2A),
            Color(0xFF2A1A15),
            Color(0xFF0A0A0A),
          ],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(color: Colors.black.withValues(alpha: 0.15)),
      ),
    );
  }
}

class GlassCircleIcon extends StatelessWidget {
  const GlassCircleIcon({
    super.key,
    required this.child,
    this.onTap,
    this.diameter = 36,
    this.iconSize = 16,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double diameter;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.03);
    final color = isDark ? Colors.white70 : Colors.black54;
    final content = Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Container(
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: IconTheme(
          data: IconThemeData(color: color, size: iconSize),
          child: child,
        ),
      ),
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}
