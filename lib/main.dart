import 'package:fb_login/src/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:fb_login/src/features/auth/data/data_sources/auth_remote_data_source_firebase.dart';
import 'package:fb_login/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fb_login/src/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'firebase_options.dart';
import 'src/features/auth/domain/repositories/auth_repository.dart';


final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceFirebase(firebaseAuth: getIt<FirebaseAuth>()));
  getIt.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()));
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();

  final authRepository = getIt<AuthRepository>();

  runApp(App(
    authRepository: authRepository,
  ));
}


class App extends StatelessWidget {
  const App({
    super.key,
    required this.authRepository,
  });

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
      ],
      child: MaterialApp(
        title: 'Clean Architecture',
        theme: ThemeData.light(useMaterial3: true),
        home: const SignInScreen(),
      ),
    );
  }
}

