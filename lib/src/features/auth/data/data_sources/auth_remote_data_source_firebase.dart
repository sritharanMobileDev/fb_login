import 'package:fb_login/src/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:fb_login/src/features/auth/data/models/auth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Implementation of [AuthRemoteDataSource] using Firebase Authentication.
/// This class provides methods to authenticate users via Firebase.
class AuthRemoteDataSourceFirebase implements AuthRemoteDataSource {
  /// Creates an instance of [AuthRemoteDataSourceFirebase].
  ///
  /// Accepts an optional [firebaseAuth] instance, useful for dependency injection.
  /// If not provided, it defaults to [firebase_auth.FirebaseAuth.instance].
  AuthRemoteDataSourceFirebase({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  /// Instance of Firebase Authentication used for authentication operations.
  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Signs in a user using email and password.
  ///
  /// Takes [email] and [password] as required parameters.
  /// Returns an [AuthUserModel] containing the authenticated user's details.
  /// Throws an exception if authentication fails.
  @override
  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential credential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure that the user is not null after authentication.
      if (credential.user == null) {
        throw Exception('Sign in failed: The user is null after sign in.');
      }

      // Convert Firebase User to AuthUserModel
      return AuthUserModel.fromFirebaseAuthUser(credential.user!);
    } catch (error) {
      throw Exception('Sign in failed: $error');
    }
  }

  /// Signs out the currently authenticated user.
  ///
  /// This method clears the user's authentication session.
  /// Throws an exception if sign-out fails.
  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (error) {
      throw Exception('Sign out failed: $error');
    }
  }
}
