import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes/router.dart';
import 'modules/cubit/dashboard/dashboard_cubit.dart';
import 'modules/repositories/auth_repository.dart';
import 'modules/screens/app_navigator_sceen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRouter.generateRoute,
      home: RepositoryProvider(
        create: (context) => AuthRepository(),
        child: BlocProvider(
          create: (context) =>
              DashboardCubit(authRepo: context.read<AuthRepository>()),
          child: const AppNavigator(),
        ),
      ),
    );
  }
}
