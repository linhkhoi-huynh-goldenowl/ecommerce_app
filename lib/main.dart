import 'package:e_commerce_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:e_commerce_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:e_commerce_app/utils/services/navigator_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes/router.dart';
import 'firebase_options.dart';

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
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationCubit>(
              create: (BuildContext context) => AuthenticationCubit()),
          BlocProvider<FavoriteCubit>(
              create: (BuildContext context) => FavoriteCubit())
        ],
        child: MaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: Routes.landing,
        ));
  }
}
