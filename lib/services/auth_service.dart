import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// GOOGLE SIGN-IN
  Future<User?> signInWithGoogle() async {
    try {
      // Step 1: Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // user cancelled
      }

      // Step 2: Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Step 3: Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Save user data to Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': googleUser.displayName ?? 'User',
          'email': googleUser.email,
          'photoUrl': googleUser.photoUrl,
          'createdAt': DateTime.now(),
          'authMethod': 'google',
        }, SetOptions(merge: true));
      }

      return userCredential.user;
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  // SIGN UP
  Future<User?> signUp(String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user profile to Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': name,
          'email': email,
          'photoUrl': null,
          'createdAt': FieldValue.serverTimestamp(),
          'authMethod': 'email',
        });
      }

      return userCredential.user;
    } catch (e) {
      print('Sign Up Error: $e');
      return null;
    }
  }

  // 🔓 LOGIN
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      // print('Sign In Error: $e');
      return null;
    }
  }

  // 🚪 LOGOUT
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      // print('Sign Out Error: $e');
    }
  }

  // 🔄 AUTH STATE
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
