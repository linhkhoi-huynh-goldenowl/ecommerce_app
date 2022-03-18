import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes/router.dart';
import 'modules/cubit/dashboard/dashboard_cubit.dart';
import 'modules/repositories/auth_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) =>
            DashboardCubit(authRepo: context.read<AuthRepository>()),
        child: const MaterialApp(
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: Routes.landing,
        ),
      ),
    );
  }
}
