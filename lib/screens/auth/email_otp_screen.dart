import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_service.dart';
import '../dashboard/dashboard_screen.dart';
import 'complete_profile_screen.dart';

class EmailOtpScreen extends StatefulWidget {
  const EmailOtpScreen({super.key, required this.email});
  static const routeName = '/email-otp';
  final String email;

  @override
  State<EmailOtpScreen> createState() => _EmailOtpScreenState();
}

class _EmailOtpScreenState extends State<EmailOtpScreen> {
  final _codeController = TextEditingController();
  final _auth = AuthService();
  bool _isVerifying = false;
  bool _isResending = false;
  int _secondsLeft = 60;
  Timer? _timer;
  StreamSubscription<AuthState>? _sub;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _sub = _auth.authStateChanges.listen((data) {
      if (!mounted) return;
      if (data.event == AuthChangeEvent.signedIn && data.session != null) {
        _routePostLogin();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sub?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _secondsLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) {
        t.cancel();
        if (mounted) setState(() {});
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  Future<void> _routePostLogin() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return;
    try {
      final profile = await supabase
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .maybeSingle();
      final hasName =
          profile != null &&
          (profile['full_name'] as String?)?.trim().isNotEmpty == true;
      if (!mounted) return;
      if (hasName) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          DashboardScreen.routeName,
          (route) => false,
        );
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          CompleteProfileScreen.routeName,
          (route) => false,
        );
      }
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        DashboardScreen.routeName,
        (route) => false,
      );
    }
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (code.length < 6) return;
    setState(() => _isVerifying = true);
    try {
      await _auth.verifyEmailCode(email: widget.email, code: code);
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _resend() async {
    if (_secondsLeft > 0 || _isResending) return;
    setState(() => _isResending = true);
    try {
      await _auth.sendEmailCode(widget.email);
      _startTimer();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code resent')),
        );
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter the 6‑digit code sent to',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _codeController,
                maxLength: 6,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Code',
                  counterText: '',
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withOpacity(0.06)
                      : Colors.black.withOpacity(0.04),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _verify(),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _secondsLeft > 0
                        ? 'Resend in $_secondsLeft s'
                        : 'Didn’t get the code?',
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _secondsLeft > 0 ? null : _resend,
                    child: _isResending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Resend'),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: _isVerifying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Verify',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
