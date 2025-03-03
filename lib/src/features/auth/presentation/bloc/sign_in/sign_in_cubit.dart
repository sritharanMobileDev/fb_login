import 'package:equatable/equatable.dart';
import 'package:fb_login/src/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:fb_login/src/features/auth/domain/value_objects/email.dart';
import 'package:fb_login/src/features/auth/domain/value_objects/password.dart';
import 'package:fb_login/src/features/auth/presentation/enums/email_status.dart';
import 'package:fb_login/src/features/auth/presentation/enums/form_status.dart';
import 'package:fb_login/src/features/auth/presentation/enums/password_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInUseCase _signInUseCase;

  SignInCubit({
    required SignInUseCase signInUseCase,
  })  : _signInUseCase = signInUseCase,
        super(const SignInState());

  void emailChanged(String value) {
    try {
      Email email = Email((email) => email..value = value);
      emit(
        state.copyWith(
          email: email,
          emailStatus: EmailStatus.valid,
        ),
      );
    } on ArgumentError {
      emit(state.copyWith(emailStatus: EmailStatus.invalid));
    }
  }

  void passwordChanged(String value) {
    try {
      Password password = Password((password) => password..value = value);
      emit(
        state.copyWith(
          password: password,
          passwordStatus: PasswordStatus.valid,
        ),
      );
    } on ArgumentError {
      emit(state.copyWith(passwordStatus: PasswordStatus.invalid));
    }
  }

  Future<void> signIn() async {
    if (!(state.emailStatus == EmailStatus.valid) ||
        !(state.passwordStatus == PasswordStatus.valid)) {
      emit(state.copyWith(formStatus: FormStatus.invalid));
      emit(state.copyWith(formStatus: FormStatus.initial));
      return;
    }

    emit(state.copyWith(formStatus: FormStatus.submissionInProgress));
    try {
      await _signInUseCase(
        SignInParams(
          email: state.email!,
          password: state.password!,
        ),
      );
      emit(state.copyWith(formStatus: FormStatus.submissionSuccess));
    } catch (err) {
      emit(state.copyWith(formStatus: FormStatus.submissionFailure));
    }
  }
}