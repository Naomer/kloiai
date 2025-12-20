import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/paywall_controller.dart';
import 'widgets/gradient_background.dart';
import 'widgets/plan_toggle.dart';

/// true = monthly, false = yearly
final billingCycleProvider = StateProvider<bool>((ref) => true);

void showPaywall(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const PaywallSheet(),
  );
}

class PaywallSheet extends ConsumerWidget {
  const PaywallSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMonthly = ref.watch(billingCycleProvider);

    final price = isMonthly ? "15/mo" : "120/yr";

    final bgColor = isDark
        ? Colors.black.withOpacity(0.9)
        : Colors.white.withOpacity(0.7);

    final blurCardColor = isDark
        ? Colors.white.withOpacity(0.09)
        : Colors.white.withOpacity(0.30);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(0), // straight top
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // CLOSE BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.12)
                              : Colors.black.withOpacity(0.06),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ICON + TITLE
                const Icon(
                  Icons.auto_awesome,
                  size: 40,
                  color: Color(0xFF8B5CF6),
                ),
                const SizedBox(height: 12),

                Text(
                  "Get KLOI Plus",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),

                const SizedBox(height: 4),
                Text(
                  "Unlock advanced features & job opportunities",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),

                const SizedBox(height: 26),

                // ================= BILLING TOGGLE =================
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.09)
                        : Colors.black.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _billingButton(
                        context,
                        ref,
                        label: "Monthly",
                        selected: isMonthly,
                        setMonthly: true,
                      ),
                      const SizedBox(width: 8),
                      _billingButton(
                        context,
                        ref,
                        label: "Yearly",
                        selected: !isMonthly,
                        setMonthly: false,
                      ),
                    ],
                  ),
                ),

                // ==================================================
                const SizedBox(height: 26),

                // FEATURES CARD
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: blurCardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: const [
                          FeatureRow("Real-time opportunity alerts"),
                          FeatureRow("Monitor multiple job sources"),
                          FeatureRow("AI matching & priority ranking"),
                          FeatureRow("Early access to new features"),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 26),

                // UPGRADE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Upgrade • \$$price",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Text(
                  "Auto-renews • Cancel anytime",
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HELPER (INSIDE CLASS) =================
  Widget _billingButton(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required bool selected,
    required bool setMonthly,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => ref.read(billingCycleProvider.notifier).state = setMonthly,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF8B5CF6) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.white
                : (isDark
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black.withOpacity(0.7)),
          ),
        ),
      ),
    );
  }
}

/// FEATURE ROW
class FeatureRow extends StatelessWidget {
  final String text;
  const FeatureRow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 20, color: Color(0xFF8B5CF6)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
