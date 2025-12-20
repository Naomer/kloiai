import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MfaScreen extends StatefulWidget {
  const MfaScreen({super.key});
  static const routeName = '/mfa';

  @override
  State<MfaScreen> createState() => _MfaScreenState();
}

class _MfaScreenState extends State<MfaScreen> {
  String? _factorId;
  String? _challengeId;
  String? _qrUrl;
  String? _secret;
  final _codeController = TextEditingController();
  bool _enrolling = false;
  bool _verifying = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _enroll() async {
    setState(() {
      _enrolling = true;
      _error = null;
    });
    try {
      final res = await Supabase.instance.client.auth.mfa.enroll(
        factorType: FactorType.totp,
      );
      final id = res.id;
      final qr = res.totp?.qrCode;
      final secret = res.totp?.secret;
      final challenge = await Supabase.instance.client.auth.mfa.challenge(
        factorId: id,
      );
      setState(() {
        _factorId = id;
        _qrUrl = qr;
        _secret = secret;
        _challengeId = challenge.id;
      });
    } catch (e) {
      setState(() => _error = 'Failed to start enrollment');
    } finally {
      if (mounted) setState(() => _enrolling = false);
    }
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (code.isEmpty || _factorId == null || _challengeId == null) return;
    setState(() {
      _verifying = true;
      _error = null;
    });
    try {
      await Supabase.instance.client.auth.mfa.verify(
        factorId: _factorId!,
        challengeId: _challengeId!,
        code: code,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Two‑step verification enabled')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = 'Verification failed');
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two‑step verification'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_qrUrl == null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _enrolling ? null : _enroll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _enrolling
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Enable'),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      Image.network(
                        _qrUrl!,
                        width: 180,
                        height: 180,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 10),
                      if (_secret != null)
                        Text(
                          _secret!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    hintText: 'Code',
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.black.withOpacity(0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _verify(),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _verifying ? null : _verify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _verifying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Verify'),
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
