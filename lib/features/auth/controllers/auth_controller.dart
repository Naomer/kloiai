import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

// Provider to access the AuthController
final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<UserProfile?>>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<AsyncValue<UserProfile?>> {
  AuthController() : super(const AsyncValue.loading()) {
    _init();
  }

  final _supabase = Supabase.instance.client;

  Future<void> _init() async {
    // Listen to auth state changes
    _supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        // User is logged in, fetch profile
        await _fetchProfile(session.user.id);
      } else {
        // User is logged out
        state = const AsyncValue.data(null);
      }
    });
  }

  Future<void> _fetchProfile(String userId) async {
    try {
      state = const AsyncValue.loading();
      
      // Try to fetch existing profile
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data != null) {
        state = AsyncValue.data(UserProfile.fromJson(data));
      } else {
        // If no profile exists (new user), create one
        // Note: Usually this is handled by a Database Trigger on Supabase side,
        // but we can handle it here if needed or just wait for the trigger.
        // For now, let's assume the trigger works or we just show basic info.
        
        // Fallback: Create a temporary profile object from Auth User metadata
        final user = _supabase.auth.currentUser;
        final profile = UserProfile(
          id: userId,
          email: user?.email,
          fullName: user?.userMetadata?['full_name'],
          avatarUrl: user?.userMetadata?['avatar_url'],
          plan: 'free', // default
          credits: 10,  // default
        );
        state = AsyncValue.data(profile);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
