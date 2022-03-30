import 'package:e_commerce_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:e_commerce_app/modules/repositories/features/repository_impl/auth_repository_impl.dart';
import 'package:e_commerce_app/modules/repositories/features/repository_impl/favorite_repository_impl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes/router.dart';
import 'modules/repositories/features/repository/auth_repository.dart';
import 'firebase_options.dart';
import 'modules/repositories/features/repository/favorite_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepositoryImpl(),
          ),
          RepositoryProvider<FavoriteRepository>(
            create: (context) => FavoriteRepositoryImpl(),
          ),
        ],
        child: BlocProvider(
          create: (BuildContext context) =>
              AuthenticationCubit(authRepo: context.read<AuthRepository>()),
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: Routes.landing,
          ),
        ));
  }
}
