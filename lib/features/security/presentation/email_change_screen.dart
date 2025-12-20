import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailChangeScreen extends StatefulWidget {
  const EmailChangeScreen({super.key});
  static const routeName = '/email-change';

  @override
  State<EmailChangeScreen> createState() => _EmailChangeScreenState();
}

class _EmailChangeScreenState extends State<EmailChangeScreen> {
  final _currentCodeController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _newCodeController = TextEditingController();
  String? _currentEmail;
  bool _sendingCurrent = false;
  bool _verifyingCurrent = false;
  bool _sendingNew = false;
  bool _verifyingNew = false;
  String? _error;
  int _currentCountdown = 0;
  int _newCountdown = 0;
  Timer? _currentTimer;
  Timer? _newTimer;
  String _stage = 'prompt';

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    _currentEmail = user?.email;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentEmail != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Verify your current email'),
            content: Text(
              'Your current email is ${_currentEmail!}. We’ll send a temporary verification code to this email.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _sendCurrentCode();
                },
                child: const Text('Send verification'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _currentCodeController.dispose();
    _newEmailController.dispose();
    _newCodeController.dispose();
    _currentTimer?.cancel();
    _newTimer?.cancel();
    super.dispose();
  }

  void _startCurrentTimer() {
    _currentTimer?.cancel();
    _currentCountdown = 60;
    _currentTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_currentCountdown <= 0) {
        t.cancel();
      } else {
        setState(() => _currentCountdown--);
      }
    });
  }

  void _startNewTimer() {
    _newTimer?.cancel();
    _newCountdown = 60;
    _newTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_newCountdown <= 0) {
        t.cancel();
      } else {
        setState(() => _newCountdown--);
      }
    });
  }

  Future<void> _sendCurrentCode() async {
    final email = _currentEmail;
    if (email == null) return;
    setState(() {
      _sendingCurrent = true;
      _error = null;
    });
    try {
      await Supabase.instance.client.auth.signInWithOtp(email: email);
      if (mounted) {
        _stage = 'verify_current';
        _startCurrentTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('We’ve sent a temporary verification code to $email'),
          ),
        );
      }
    } catch (e) {
      setState(() => _error = 'Failed to send code to current email');
    } finally {
      if (mounted) setState(() => _sendingCurrent = false);
    }
  }

  Future<void> _verifyCurrentCode() async {
    final email = _currentEmail;
    final code = _currentCodeController.text.trim();
    if (email == null || code.isEmpty) return;
    setState(() {
      _verifyingCurrent = true;
      _error = null;
    });
    try {
      final res = await Supabase.instance.client.auth.verifyOTP(
        type: OtpType.email,
        email: email,
        token: code,
      );
      if (res.user == null) {
        throw Exception();
      }
      if (mounted) {
        _stage = 'enter_new';
      }
    } catch (e) {
      setState(() => _error = 'OTP verification failed');
    } finally {
      if (mounted) setState(() => _verifyingCurrent = false);
    }
  }

  Future<void> _sendNewEmailCode() async {
    final newEmail = _newEmailController.text.trim();
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (newEmail.isEmpty || !emailRegex.hasMatch(newEmail)) {
      setState(() => _error = 'Email is not valid.');
      return;
    }
    setState(() {
      _sendingNew = true;
      _error = null;
    });
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(email: newEmail),
      );
      if (mounted) {
        _stage = 'verify_new';
        _startNewTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'We just sent you a temporary verification code to $newEmail',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _error = 'Failed to start email change');
    } finally {
      if (mounted) setState(() => _sendingNew = false);
    }
  }

  Future<void> _verifyNewEmailCode() async {
    final newEmail = _newEmailController.text.trim();
    final code = _newCodeController.text.trim();
    if (newEmail.isEmpty || code.isEmpty) return;
    setState(() {
      _verifyingNew = true;
      _error = null;
    });
    try {
      final res = await Supabase.instance.client.auth.verifyOTP(
        type: OtpType.emailChange,
        email: newEmail,
        token: code,
      );
      if (res.user == null) {
        throw Exception();
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email changed successfully')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = 'Email change verification failed');
    } finally {
      if (mounted) setState(() => _verifyingNew = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Change Email'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_stage == 'verify_current' || _stage == 'prompt') ...[
                if (_currentEmail != null) ...[
                  Text(
                    _stage == 'verify_current'
                        ? 'Your current email is $_currentEmail. We’ve sent a temporary verification code to this email.'
                        : 'Your current email is $_currentEmail. We’ll send a temporary verification code to this email.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentCountdown > 0
                          ? 'Resend in $_currentCountdown s'
                          : 'Didn’t get the code?',
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _currentCountdown > 0 || _sendingCurrent
                          ? null
                          : _sendCurrentCode,
                      child: _sendingCurrent
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Send verification'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _currentCodeController,
                  decoration: InputDecoration(
                    hintText: 'Enter verification code',
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
                  onSubmitted: (_) => _verifyCurrentCode(),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _verifyingCurrent ? null : _verifyCurrentCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _verifyingCurrent
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Continue'),
                  ),
                ),
              ] else if (_stage == 'enter_new') ...[
                const SizedBox(height: 12),
                Text(
                  'Please enter a new email and we will send you a verification code.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _newEmailController,
                  decoration: InputDecoration(
                    hintText: 'Enter new email',
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.black.withOpacity(0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _sendNewEmailCode(),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _sendingNew ? null : _sendNewEmailCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _sendingNew
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Send verification code'),
                  ),
                ),
              ] else if (_stage == 'verify_new') ...[
                const SizedBox(height: 12),
                Text(
                  'We just sent you a temporary verification code to ${_newEmailController.text.trim()}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _newCountdown > 0
                          ? 'Resend in $_newCountdown s'
                          : 'Didn’t get the code?',
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _newCountdown > 0 || _sendingNew
                          ? null
                          : _sendNewEmailCode,
                      child: _sendingNew
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Resend'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _newCodeController,
                  decoration: InputDecoration(
                    hintText: 'Enter verification code',
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
                  onSubmitted: (_) => _verifyNewEmailCode(),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _verifyingNew ? null : _verifyNewEmailCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _verifyingNew
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Change email'),
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.red.shade200 : Colors.red.shade700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
