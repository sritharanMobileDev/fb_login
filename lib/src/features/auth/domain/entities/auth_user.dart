import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoURL;

  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.photoURL,
  });

  static const AuthUser empty = AuthUser(
    id: '',
    name: '',
    email: '',
    photoURL: '',
  );


  bool get isEmpty => this == AuthUser.empty;

  @override
  List<Object?> get props => [id, name, email, photoURL];

}