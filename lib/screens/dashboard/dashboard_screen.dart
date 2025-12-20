import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:remixicon/remixicon.dart'; // Not used in this file

import 'tabs/home_tab.dart';
import 'tabs/chat_tab.dart';
import 'tabs/portfolio_tab.dart';
import '../../features/settings/presentation/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  static const _tabs = [
    HomeTab(), // Home: status + matches + flows
    ChatTab(), // Agent console
    PortfolioTab(), // Portfolio builder
    SettingsScreen(), // Subscription + settings
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          SafeArea(child: _tabs[_currentIndex]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const ui.Color.fromARGB(
                        255,
                        214,
                        214,
                        214,
                      ).withOpacity(0.0),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: const ui.Color.fromARGB(
                          255,
                          214,
                          214,
                          214,
                        ).withOpacity(0.1),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x29000000),
                          blurRadius: 0,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _NavIcon(
                          selected: _currentIndex == 0,
                          baseIcon: PhosphorIcons.houseSimple,
                          onTap: () => setState(() => _currentIndex = 0),
                        ),
                        const SizedBox(width: 18),
                        _NavIcon(
                          selected: _currentIndex == 1,
                          baseIcon: PhosphorIcons.chatCircleText,
                          onTap: () => setState(() => _currentIndex = 1),
                        ),
                        const SizedBox(width: 18),
                        _NavIcon(
                          selected: _currentIndex == 2,
                          baseIcon: PhosphorIcons.folderSimpleUser,
                          onTap: () => setState(() => _currentIndex = 2),
                        ),
                        const SizedBox(width: 18),
                        _NavIcon(
                          selected: _currentIndex == 3,
                          baseIcon: PhosphorIcons.user,
                          onTap: () => setState(() => _currentIndex = 3),
                        ),
                      ],
                    ),
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

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.selected,
    // Accept the base function pointer
    required this.baseIcon,
    super.key,
    required this.onTap,
  });

  final bool selected;
  // Type is the function signature
  final PhosphorIconData Function([PhosphorIconsStyle style]) baseIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accent = isDark ? Colors.white : Colors.black;

    // Determine the style based on selection status
    final iconStyle = selected
        ? PhosphorIconsStyle.fill
        : PhosphorIconsStyle.regular;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? Colors.white12 : Colors.white)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: PhosphorIcon(
          baseIcon(iconStyle), // Call the function with the correct style
          size: 20,
          color: selected ? accent : accent.withOpacity(0.7),
        ),
      ),
    );
  }
}
