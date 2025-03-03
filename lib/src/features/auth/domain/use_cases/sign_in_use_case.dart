import 'package:fb_login/src/features/auth/domain/entities/auth_user.dart';
import 'package:fb_login/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:fb_login/src/features/auth/domain/value_objects/email.dart';
import 'package:fb_login/src/features/auth/domain/value_objects/password.dart';

/// Use case for signing in a user with email and password.
///
/// This class defines the business logic for user authentication.
/// It interacts with the [AuthRepository] without directly dealing with data sources.
class SignInUseCase {
  /// The repository responsible for authentication operations.
  final AuthRepository authRepository;

  /// Creates an instance of [SignInUseCase] with the required [authRepository].
  SignInUseCase({required this.authRepository});

  /// Executes the sign-in operation.
  ///
  /// Takes [SignInParams] as input, which contains validated [Email] and [Password].
  /// Calls [authRepository.signIn] and returns an [AuthUser] upon success.
  /// Throws an [Exception] in case of validation or authentication errors.
  Future<AuthUser> call(SignInParams params) async {
    try {
      return await authRepository.signIn(
        email: params.email.value,
        password: params.password.value,
      );
    } on ArgumentError catch (error) {
      throw Exception(error);
    } catch (error) {
      throw Exception(error);
    }
  }
}

/// Encapsulates sign-in parameters into a single object.
///
/// This class ensures that [Email] and [Password] are passed as validated value objects,
/// enforcing domain rules before reaching the repository.
class SignInParams {
  /// The email address of the user.
  final Email email;

  /// The password of the user.
  final Password password;

  /// Creates an instance of [SignInParams] with required [email] and [password].
  SignInParams({
    required this.email,
    required this.password,
  });
}
