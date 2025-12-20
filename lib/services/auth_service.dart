import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  User? get currentUser => _supabase.auth.currentUser;

  Future<bool> signInWithGoogle() async {
    try {
      final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
      if (webClientId == null || webClientId.isEmpty) {
        throw 'GOOGLE_WEB_CLIENT_ID missing. Add it to assets/env/.env';
      }

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false; // User canceled

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw 'No ID Token found. Make sure you set the Web Client ID in AuthService.';
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return response.user != null;
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('Unacceptable audience')) {
        await _supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: 'com.kloi.ai://login-callback',
        );
        return false;
      }
      debugPrint('Google Sign In Error: $e');
      rethrow;
    }
  }

  Future<void> sendMagicLink(String email) async {
    await _supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: 'com.kloi.ai://login-callback',
    );
  }

  Future<bool> signInWithEmailLink(String email, String link) async {
    // Supabase handles the link automatically if deep linking is set up.
    // However, if you are manually handling the link (e.g. from a text input),
    // you might use verifyOtp, but usually this is not needed for Magic Link + Deep Link.
    return true;
  }

  Future<void> sendEmailCode(String email) async {
    await _supabase.auth.signInWithOtp(email: email, shouldCreateUser: true);
  }

  Future<bool> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    final response = await _supabase.auth.verifyOTP(
      email: email,
      token: code,
      type: OtpType.email,
    );
    return response.user != null;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    await GoogleSignIn().signOut();
  }
}
