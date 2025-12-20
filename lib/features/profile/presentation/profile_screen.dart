import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../security/presentation/email_change_screen.dart';
import '../../security/presentation/mfa_screen.dart';
import '../../../services/auth_service.dart';
import '../../../screens/auth/auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _avatarUrlController = TextEditingController();
  String? _userId;
  String? _userEmail;
  String? _error;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      setState(() {
        _error = 'Not signed in';
        _loading = false;
      });
      return;
    }
    _userId = user.id;
    _userEmail = user.email;
    try {
      final data = await supabase
          .from('profiles')
          .select('full_name, avatar_url')
          .eq('id', user.id)
          .maybeSingle();
      if (data == null) {
        try {
          await supabase.from('profiles').upsert({
            'id': user.id,
            'full_name': '',
            'avatar_url': null,
          });
          final created = await supabase
              .from('profiles')
              .select('full_name, avatar_url')
              .eq('id', user.id)
              .maybeSingle();
          _nameController.text = (created?['full_name'] as String?) ?? '';
          _avatarUrlController.text = (created?['avatar_url'] as String?) ?? '';
          setState(() {
            _loading = false;
          });
          return;
        } catch (_) {
          _nameController.text = '';
          _avatarUrlController.text = '';
          setState(() {
            _loading = false;
          });
          return;
        }
      }
      final name = (data?['full_name'] as String?) ?? '';
      final avatarUrl = (data?['avatar_url'] as String?) ?? '';
      _nameController.text = name;
      _avatarUrlController.text = avatarUrl;
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final supabase = Supabase.instance.client;
      final id = _userId;
      if (id == null) {
        setState(() {
          _error = 'Not signed in';
        });
        return;
      }
      await supabase.from('profiles').upsert({
        'id': id,
        'full_name': _nameController.text.trim(),
        'avatar_url': _avatarUrlController.text.trim().isEmpty
            ? null
            : _avatarUrlController.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile saved')));
    } catch (e) {
      setState(() {
        _error = 'Failed to save profile';
      });
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final avatarUrl = _avatarUrlController.text.trim();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.08),
                        backgroundImage: avatarUrl.isNotEmpty
                            ? NetworkImage(avatarUrl)
                            : null,
                        child: avatarUrl.isEmpty
                            ? Text(
                                (_nameController.text.isNotEmpty
                                        ? _nameController.text[0]
                                        : 'U')
                                    .toUpperCase(),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_userId != null)
                      Center(
                        child: Text(
                          _userId!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    if (_userEmail != null) ...[
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          _userEmail!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full name',
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.black.withOpacity(0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _avatarUrlController,
                      decoration: InputDecoration(
                        labelText: 'Avatar URL',
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
                      onSubmitted: (_) => _save(),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: isDark
                              ? Colors.red.shade200
                              : Colors.red.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.white : Colors.black,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.black12,
                        ),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(
                              context,
                            ).pushNamed(EmailChangeScreen.routeName),
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.mail_outline, size: 22),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Change email',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            color: isDark ? Colors.white12 : Colors.black12,
                          ),
                          InkWell(
                            onTap: () => Navigator.of(
                              context,
                            ).pushNamed(MfaScreen.routeName),
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.verified_user_outlined,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Two‑step verification',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            color: isDark ? Colors.white12 : Colors.black12,
                          ),
                          InkWell(
                            onTap: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Delete account?'),
                                  content: const Text(
                                    'This will delete your account. This cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm != true) return;
                              final userId = _userId;
                              if (userId == null) return;
                              try {
                                await Supabase.instance.client.functions.invoke(
                                  'delete-account',
                                  body: {'user_id': userId},
                                );
                              } catch (_) {}
                              try {
                                await AuthService().signOut();
                              } finally {
                                if (!mounted) return;
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  AuthScreen.routeName,
                                  (route) => false,
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete_outline,
                                    size: 22,
                                    color: Color(0xFFE11900),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Delete account',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
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
      ),
    );
  }
}
