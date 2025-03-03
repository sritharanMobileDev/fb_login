import 'package:fb_login/src/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:fb_login/src/features/auth/domain/entities/auth_user.dart';
import 'package:fb_login/src/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository] that handles authentication logic.
///
/// This class acts as a bridge between the data layer ([AuthRemoteDataSource])
/// and the domain layer ([AuthRepository]), ensuring separation of concerns.
class AuthRepositoryImpl implements AuthRepository {
  /// Remote data source responsible for handling authentication operations.
  final AuthRemoteDataSource remoteDataSource;

  /// Creates an instance of [AuthRepositoryImpl] with the required [remoteDataSource].
  const AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  /// Authenticates a user using email and password.
  ///
  /// Takes [email] and [password] as required parameters.
  /// Calls [remoteDataSource.signInWithEmailAndPassword] to authenticate the user.
  /// Converts the returned [AuthUserModel] into an [AuthUser] entity.
  /// Returns an [AuthUser] on successful authentication.
  /// Throws an exception if authentication fails.
  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final authModel = await remoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return authModel.toEntity();
  }

  /// Signs out the currently authenticated user.
  ///
  /// Calls [remoteDataSource.signOut] to perform the sign-out operation.
  /// Throws an exception if the sign-out process fails.
  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }
}
