import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final iconColor = Colors.white.withValues(alpha: 0.85);

    return Row(
      children: [
        Text(
          '9:41',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
        ),
        const Spacer(),
        Row(
          children: [
            Icon(Icons.signal_cellular_alt_rounded,
                size: 18, color: iconColor),
            const SizedBox(width: 6),
            Icon(Icons.wifi, size: 18, color: iconColor),
            const SizedBox(width: 6),
            Icon(Icons.battery_5_bar, size: 20, color: iconColor),
          ],
        ),
      ],
    );
  }
}

