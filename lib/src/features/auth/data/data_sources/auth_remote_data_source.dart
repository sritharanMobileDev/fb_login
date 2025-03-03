import 'package:fb_login/src/features/auth/data/models/auth_user_model.dart';

/// An abstract class that defines the contract for authentication operations.
/// This allows for different implementations of authentication, such as Firebase or mock authentication.
abstract class AuthRemoteDataSource {

  /// Authenticates a user with email and password.
  ///
  /// Takes [email] and [password] as required parameters.
  /// Returns an [AuthUserModel] containing the authenticated user's details.
  /// Throws an exception if authentication fails.
  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs out the currently authenticated user.
  ///
  /// This method clears the user's authentication session.
  /// Throws an exception if sign-out fails.
  Future<void> signOut();
}
