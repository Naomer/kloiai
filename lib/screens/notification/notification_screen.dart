import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const routeName = '/notifications';
  static int unreadCount() =>
      _mockNotifications.where((n) => n.unread).length;
  static bool hasUnread() => unreadCount() > 0;

  @override
  Widget build(BuildContext context) {
    final items = _mockNotifications;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDark ? Colors.white : Colors.black87,
                size: 18,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: const _TopCircleIcon(icon: RemixIcons.settings_3_line),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _NotificationCard(item: items[index]),
      ),
    );
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    this.unread = false,
  });
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final bool unread;
}

const _mockNotifications = [
  _NotificationItem(
    title: 'New match: Web Researcher',
    message: 'Willms Inc looks like a strong fit. Tap to view.',
    time: '2m',
    icon: RemixIcons.briefcase_2_line,
    unread: true,
  ),
  _NotificationItem(
    title: 'Proposal sent',
    message: 'Your proposal was sent for UX Researcher.',
    time: '1h',
    icon: RemixIcons.send_plane_line,
  ),
  _NotificationItem(
    title: 'Client replied',
    message: 'Bosco and Sons responded to your proposal.',
    time: '3h',
    icon: RemixIcons.message_2_line,
    unread: true,
  ),
  _NotificationItem(
    title: 'Reminder',
    message: 'Follow up with LinkedIn lead about scope.',
    time: '1d',
    icon: RemixIcons.alarm_line,
  ),
];

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});
  final _NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              item.icon,
              size: 18,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ).copyWith(color: isDark ? Colors.white : Colors.black),
                      ),
                    ),
                    Text(
                      item.time,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.message,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (item.unread)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

class _TopCircleIcon extends StatelessWidget {
  const _TopCircleIcon({required this.icon});
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 18,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }
}
