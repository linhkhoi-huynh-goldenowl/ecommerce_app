import 'package:ecommerce_app/modules/screens/dashboard_screen.dart';
import 'package:ecommerce_app/modules/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth/auth_cubit.dart';
import '../cubit/dashboard/dashboard_cubit.dart';
import 'auth_navigator_screen.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
      return Navigator(
        pages: [
          // Show loading screen
          if (state is UnknownDashboardState)
            const MaterialPage(child: LoadingScreen()),

          // Show auth flow
          if (state is Unauthenticated)
            MaterialPage(
              child: BlocProvider(
                create: (context) =>
                    AuthCubit(dashboardCubit: context.read<DashboardCubit>()),
                child: const AuthNavigator(),
              ),
            ),

          // Show dashboard flow
          if (state is Authenticated)
            const MaterialPage(child: DashboardScreen())
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
