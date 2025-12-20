import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/dashboard/dashboard_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/auth/complete_profile_screen.dart';
import 'screens/jobs/job_details_screen.dart';
import 'screens/proposals/proposal_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/chat/history_screen.dart';
import 'screens/notification/notification_screen.dart';
import 'screens/search/search_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'screens/auth/email_otp_screen.dart';
import 'features/security/presentation/security_screen.dart';
import 'features/security/presentation/email_change_screen.dart';
import 'features/security/presentation/mfa_screen.dart';
// import 'services/firebase_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FirebaseInitializer.initialize();
  await dotenv.load(fileName: 'assets/env/.env');

  await Supabase.initialize(
    url: 'https://begqqelkatucomtrjbmf.supabase.co',
    anonKey: 'sb_publishable_eIcboQ963PhccuLp7vOL7w_WDdH5z5I',
  );

  // Light UI with dark status bar icons.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: FreelanceAgentApp()));
}

class FreelanceAgentApp extends ConsumerWidget {
  const FreelanceAgentApp({super.key});
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(
    ThemeMode.system,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state
    final authState = ref.watch(authControllerProvider);

    final base = ThemeData.light(useMaterial3: true);
    final theme = base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(0, 20, 20, 20),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF2F2F7),
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
    );
    final baseDark = ThemeData.dark(useMaterial3: true);
    final darkTheme = baseDark.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF222222),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.black,
      textTheme: GoogleFonts.interTextTheme(baseDark.textTheme),
    );

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'KLOI AI',
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          themeMode: mode,
          // We can use a builder here to decide the home screen based on auth state
          // However, for simplicity and splash screen support, we might keep SplashScreen as home
          // OR better: Let SplashScreen delegate the decision, but we already have the state here.
          // Let's stick to SplashScreen for initial load, but update routes.
          home: const SplashScreen(),
          routes: {
            SplashScreen.routeName: (_) => const SplashScreen(),
            OnboardingScreen.routeName: (_) => const OnboardingScreen(),
            AuthScreen.routeName: (_) => const AuthScreen(),
            CompleteProfileScreen.routeName: (_) =>
                const CompleteProfileScreen(),
            DashboardScreen.routeName: (_) => const DashboardScreen(),
            JobDetailsScreen.routeName: (_) => const JobDetailsScreen(),
            ProposalScreen.routeName: (_) => const ProposalScreen(),
            '/chat': (_) => const ChatScreen(),
            HistoryScreen.routeName: (_) => const HistoryScreen(),
            NotificationScreen.routeName: (_) => const NotificationScreen(),
            SearchScreen.routeName: (_) => const SearchScreen(),
            ProfileScreen.routeName: (_) => const ProfileScreen(),
            EmailOtpScreen.routeName: (_) => const EmailOtpScreen(email: ''),
            SecurityScreen.routeName: (_) => const SecurityScreen(),
            EmailChangeScreen.routeName: (_) => const EmailChangeScreen(),
            MfaScreen.routeName: (_) => const MfaScreen(),
          },
        );
      },
    );
  }
}
