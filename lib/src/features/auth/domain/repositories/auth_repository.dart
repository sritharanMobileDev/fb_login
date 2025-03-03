import 'package:fb_login/src/features/auth/domain/entities/auth_user.dart';

/// Abstract class defining the contract for authentication operations.
///
/// This repository acts as an interface between the domain and data layers,
/// ensuring separation of concerns and enabling different authentication implementations.
abstract class AuthRepository {

  /// Authenticates a user using email and password.
  ///
  /// Takes [email] and [password] as required parameters.
  /// Returns an [AuthUser] entity on successful authentication.
  /// Throws an exception if authentication fails.
  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  /// Signs out the currently authenticated user.
  ///
  /// Clears the authentication session.
  /// Throws an exception if sign-out fails.
  Future<void> signOut();
}
