import 'package:flutter/material.dart';

import 'glass_widgets.dart';

class TopActions extends StatelessWidget {
  const TopActions({super.key, this.showRecord = true});

  final bool showRecord;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAction(
          icon: Icons.close,
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        const Spacer(),
        if (showRecord) ...[
          CircleAction(
            padding: const EdgeInsets.all(4),
            onTap: () {},
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFD4D4D),
              ),
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                width: 12,
                height: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        CircleAction(
          onTap: () {},
          child: const Icon(Icons.favorite, color: Color(0xFFFF3B30), size: 18),
        ),
        const SizedBox(width: 12),
        CircleAction(icon: Icons.share_outlined, onTap: () {}),
        const SizedBox(width: 12),
        CircleAction(icon: Icons.more_vert, onTap: () {}),
      ],
    );
  }
}

class CircleAction extends StatelessWidget {
  const CircleAction({
    super.key,
    this.icon,
    this.onTap,
    this.child,
    this.padding,
    this.backgroundColor,
  });

  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? child;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final decor = backgroundColor != null
        ? BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(32),
          )
        : null;

    final content = SizedBox(
      width: 32,
      height: 32,
      child: Center(
        child: child ?? Icon(icon, size: 18, color: Colors.white),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: decor != null
          ? Container(
              decoration: decor,
              padding: padding ?? const EdgeInsets.all(12),
              child: content,
            )
          : GlassPanel(
              borderRadius: 32,
              padding: padding ?? const EdgeInsets.all(12),
              child: content,
            ),
    );
  }
}

