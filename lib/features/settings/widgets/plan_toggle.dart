import 'package:flutter/material.dart';

class PlanToggle extends StatelessWidget {
  final bool isYearly;
  final VoidCallback onToggle;

  const PlanToggle({super.key, required this.isYearly, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ChoiceChip(
            label: const Text("Monthly"),
            selected: !isYearly,
            onSelected: (v) => onToggle(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ChoiceChip(
            label: const Text("Yearly • Save 20%"),
            selected: isYearly,
            onSelected: (v) => onToggle(),
          ),
        ),
      ],
    );
  }
}
