import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // TODO: Replace with your actual Web Client ID from Firebase Console
  // It usually looks like: 1234567890-abcdefg.apps.googleusercontent.com
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional: clientId is required for Web and Windows (if using web implementation)
    // You can find this in your google-services.json or Firebase Console (Web App)
    clientId: 'YOUR_WEB_CLIENT_ID_HERE',
  );

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up with Email & Password
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Log In with Email & Password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Google Sign In
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Update Profile Photo
  Future<void> updateProfilePhoto(String url) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePhotoURL(url);
      await user.reload(); // Refresh user data
      notifyListeners();
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
