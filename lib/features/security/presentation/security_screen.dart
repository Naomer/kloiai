import 'package:flutter/material.dart';
import 'email_change_screen.dart';
import 'mfa_screen.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});
  static const routeName = '/security';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sep = isDark ? Colors.white12 : Colors.black12;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context)
                        .pushNamed(EmailChangeScreen.routeName),
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.mail_outline, size: 22),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Change email',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 1, color: sep),
                  InkWell(
                    onTap: () =>
                        Navigator.of(context).pushNamed(MfaScreen.routeName),
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.verified_user_outlined, size: 22),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Two‑step verification',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
