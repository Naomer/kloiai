import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:remixicon/remixicon.dart';
import '../../../screens/auth/auth_screen.dart';
import '../../../main.dart';
import '../../../widgets/glass_widgets.dart';
import '../widgets/setting_tile.dart';
import '../paywall_sheet.dart';
import '../../../services/auth_service.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../security/presentation/security_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 4),
        Text(
          "Settings",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 24),

        _SectionHeader("Account"),
        const SizedBox(height: 12),
        _GroupCard(
          children: [
            _ListRow(
              icon: RemixIcons.user_3_line,
              title: "Profile",
              subtitle: "Personal info & identity",
              onTap: () =>
                  Navigator.of(context).pushNamed(ProfileScreen.routeName),
            ),
            _ListRow(
              icon: RemixIcons.lock_password_line,
              title: "Security",
              subtitle: "Password, login sessions",
              onTap: () =>
                  Navigator.of(context).pushNamed(SecurityScreen.routeName),
            ),
          ],
        ),
        const SizedBox(height: 28),

        _SectionHeader("Upgrade"),
        const SizedBox(height: 12),
        _GroupCard(
          children: [
            _ListRow(
              icon: RemixIcons.arrow_up_circle_line,
              title: "Upgrade to Plus",
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const FractionallySizedBox(
                  heightFactor: 0.94,
                  child: PaywallSheet(),
                ),
              ),
            ),
            _ListRow(
              icon: RemixIcons.add_circle_line,
              title: "Subscription",
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const FractionallySizedBox(
                  heightFactor: 0.94,
                  child: PaywallSheet(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        _SectionHeader("Usage"),
        const SizedBox(height: 12),
        _UsageCard(label: "Messages", used: 18, total: 50),
        const SizedBox(height: 10),
        _UsageCard(label: "Proposals", used: 3, total: 10),
        const SizedBox(height: 28),

        _SectionHeader("General"),
        const SizedBox(height: 12),
        _GroupCard(
          children: [
            _ToggleRow(
              title: "Auto‑proposals",
              subtitle: "Let the agent write proposals automatically",
              defaultValue: true,
              onChanged: (v) {},
            ),
            _ListRow(
              icon: RemixIcons.notification_2_line,
              title: "Notifications",
              subtitle: "Email & push alerts",
              onTap: () {},
            ),
            _ListRow(
              icon: RemixIcons.sun_line,
              title: "Appearance",
              subtitle: "System • Dark • Light",
              onTap: () => _showAppearanceDialog(context),
            ),
          ],
        ),

        const SizedBox(height: 28),

        _GroupCard(
          children: [
            _ListRow(
              iconWidget: const Icon(IconlyLight.logout, size: 22),
              title: "Log Out",
              titleColor: isDark ? Colors.white : const Color(0xFFE11900),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Log out?'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: TextButton.styleFrom(
                          foregroundColor: isDark
                              ? Colors.white
                              : const Color(0xFFE11900),
                        ),
                        child: const Text('Log out'),
                      ),
                    ],
                  ),
                );
                if (confirm != true) return;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
                try {
                  await AuthService().signOut();
                } finally {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AuthScreen.routeName,
                    (route) => false,
                  );
                }
              },
              trailing: const SizedBox.shrink(),
            ),
          ],
        ),
        const SizedBox(height: 65),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.titleMedium?.color,
      ),
    );
  }
}

class _ToggleTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool defaultValue;
  final ValueChanged<bool> onChanged;
  const _ToggleTile({
    required this.title,
    required this.subtitle,
    required this.defaultValue,
    required this.onChanged,
  });
  @override
  State<_ToggleTile> createState() => _ToggleTileState();
}

class _ToggleTileState extends State<_ToggleTile> {
  late bool value;
  @override
  void initState() {
    value = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (v) {
              setState(() => value = v);
              widget.onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}

class _UsageCard extends StatelessWidget {
  final String label;
  final int used;
  final int total;
  const _UsageCard({
    required this.label,
    required this.used,
    required this.total,
  });
  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : (used / total).clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text("$used / $total"),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: isDark ? Colors.white12 : Colors.black12,
              valueColor: AlwaysStoppedAnimation(
                isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final List<Widget> children;
  const _GroupCard({required this.children});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final border = isDark ? Colors.white10 : Colors.black12;
    final sep = isDark ? Colors.white12 : Colors.black12;
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) Container(height: 1, color: sep),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _ListRow extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _ListRow({
    this.icon,
    this.iconWidget,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.trailing,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chevronColor =
        Theme.of(context).textTheme.bodyMedium?.color ??
        (isDark ? Colors.white70 : Colors.black54);
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (iconWidget != null)
            iconWidget!
          else if (icon != null)
            Icon(icon, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ],
            ),
          ),
          trailing ??
              Icon(
                RemixIcons.arrow_right_s_line,
                size: 20,
                color: chevronColor,
              ),
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: content,
      );
    }
    return content;
  }
}

class _ToggleRow extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool defaultValue;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.defaultValue,
    required this.onChanged,
  });
  @override
  State<_ToggleRow> createState() => _ToggleRowState();
}

class _ToggleRowState extends State<_ToggleRow> {
  late bool value;
  @override
  void initState() {
    value = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (v) {
              setState(() => value = v);
              widget.onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}
//

void _showAppearanceDialog(BuildContext context) {
  final current = FreelanceAgentApp.themeMode.value;
  ThemeMode selected = current;
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: GlassPanel(
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Appearance",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _AppearanceOption(
                      label: "System",
                      icon: RemixIcons.computer_line,
                      selected: selected == ThemeMode.system,
                      onTap: () {
                        setState(() => selected = ThemeMode.system);
                        FreelanceAgentApp.themeMode.value = ThemeMode.system;
                      },
                    ),
                    const SizedBox(height: 10),
                    _AppearanceOption(
                      label: "Dark",
                      icon: RemixIcons.moon_line,
                      selected: selected == ThemeMode.dark,
                      onTap: () {
                        setState(() => selected = ThemeMode.dark);
                        FreelanceAgentApp.themeMode.value = ThemeMode.dark;
                      },
                    ),
                    const SizedBox(height: 10),
                    _AppearanceOption(
                      label: "Light",
                      icon: RemixIcons.sun_line,
                      selected: selected == ThemeMode.light,
                      onTap: () {
                        setState(() => selected = ThemeMode.light);
                        FreelanceAgentApp.themeMode.value = ThemeMode.light;
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

class _AppearanceOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _AppearanceOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = selected
        ? (isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.04))
        : (isDark ? Colors.black.withOpacity(0.30) : Colors.white);
    final borderColor = selected
        ? (isDark
              ? Colors.white.withOpacity(0.15)
              : Colors.black.withOpacity(0.15))
        : (isDark ? Colors.white12 : Colors.black12);
    final iconColor =
        Theme.of(context).textTheme.bodyMedium?.color ??
        (isDark ? Colors.white70 : Colors.black87);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            if (selected)
              Icon(RemixIcons.check_line, size: 18, color: iconColor),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  final Color accent;
  const _FeatureRow(this.text, this.accent);
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, size: 18, color: accent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color:
                  Theme.of(context).textTheme.bodyMedium?.color ??
                  (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
