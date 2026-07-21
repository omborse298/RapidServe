// name=lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Add this import

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance; // <-- Initialize Firestore

  /// Logs in a user using their email and password.
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          return 'Invalid email or password.';
        case 'invalid-email':
          return 'The email address format is invalid.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        default:
          return e.message ?? 'An unexpected authentication error occurred.';
      }
    } catch (e) {
      return 'Connection error: ${e.toString()}';
    }
  }

  /// Registers a new user with email and password, and saves extra profile data to Firestore.
  Future<String?> registerUser({
    required String name,     // <-- Added name parameter
    required String phone,    // <-- Added phone parameter
    required String email,
    required String password,
  }) async {
    try {
      // 1. Create the user authentication profile
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Save additional data into Firestore using the generated User UID
      if (userCredential.user != null) {
        await _db.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': name,
          'phone': phone,
          'email': email,
          'role': 'customer', // Distinguishes profile types later
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'email-already-in-use':
          return 'An account already exists for this email.';
        case 'invalid-email':
          return 'The email address format is invalid.';
        default:
          return e.message ?? 'Registration failed. Please try again.';
      }
    } catch (e) {
      return 'Registration error: ${e.toString()}';
    }
  }

  /// Signs out the currently authenticated user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Gets the current authenticated user instance, if any.
  User? get currentUser => _auth.currentUser;

  /// Stream to listen to real-time authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}