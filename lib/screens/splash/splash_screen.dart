import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../dashboard/dashboard_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../auth/complete_profile_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/splash';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      Navigator.of(context).pushReplacementNamed(OnboardingScreen.routeName);
      return;
    }
    try {
      final profile = await supabase
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .maybeSingle();
      final hasName =
          profile != null &&
          (profile['full_name'] as String?)?.trim().isNotEmpty == true;
      if (hasName) {
        Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
      } else {
        Navigator.of(
          context,
        ).pushReplacementNamed(CompleteProfileScreen.routeName);
      }
    } catch (_) {
      Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/icon/icon.png',
                width: 76,
                height: 76,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            // Text(
            //   'KLOI',
            //   style: theme.textTheme.titleLarge?.copyWith(
            //     fontWeight: FontWeight.w700,
            //     fontSize: 1,
            //   ),
            // ),
            // const SizedBox(height: 6),
            // Text(
            //   'Your AI Client Hunter',
            //   style: theme.textTheme.bodyMedium?.copyWith(
            //     color: Colors.black54,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
