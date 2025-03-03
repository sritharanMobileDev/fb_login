
import 'dart:async';

import 'package:fb_login/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:fb_login/src/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:fb_login/src/features/auth/presentation/enums/email_status.dart';
import 'package:fb_login/src/features/auth/presentation/enums/form_status.dart';
import 'package:fb_login/src/features/auth/presentation/enums/password_status.dart';
import 'package:fb_login/src/features/auth/presentation/bloc/sign_in/sign_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(
        signInUseCase: SignInUseCase(
          authRepository: context.read<AuthRepository>(),
        ),
      ),
      child: const SignInView(),
    );
  }
}

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state.formStatus == FormStatus.invalid) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Invalid form: please fill in all fields'),
                ),
              );
          }
          if (state.formStatus == FormStatus.submissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                    'There was an error with the sign in process. Try again.',
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  key: const Key('signIn_emailInput_textField'),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: state.emailStatus == EmailStatus.invalid
                        ? 'Invalid email'
                        : null,
                  ),
                  onChanged: (String value) {
                    if (debounce?.isActive ?? false) debounce?.cancel();
                    debounce = Timer(const Duration(milliseconds: 500), () {
                      context.read<SignInCubit>().emailChanged(value);
                    });
                  },
                ),
                TextFormField(
                  key: const Key('signIn_passwordInput_textField'),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: state.passwordStatus == PasswordStatus.invalid
                        ? 'Invalid password'
                        : null,
                  ),
                  onChanged: (String value) {
                    context.read<SignInCubit>().passwordChanged(value);
                  },
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  key: const Key('signIn_continue_elevatedButton'),
                  onPressed: context.read<SignInCubit>().state.formStatus ==
                      FormStatus.submissionInProgress
                      ? null
                      : () {
                    context.read<SignInCubit>().signIn();
                  },
                  child: const Text('Sign In'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}