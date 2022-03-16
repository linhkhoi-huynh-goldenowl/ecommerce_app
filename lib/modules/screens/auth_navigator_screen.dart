import 'package:ecommerce_app/modules/screens/login/login_screen.dart';
import 'package:ecommerce_app/modules/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth/auth_cubit.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      return Navigator(
        pages: [
          // Show login
          if (state == AuthState.login) MaterialPage(child: LoginScreen()),

          // Allow push animation
          if (state == AuthState.signUp) MaterialPage(child: SignUpScreen()),
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
