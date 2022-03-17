import 'package:ecommerce_app/modules/cubit/auth/auth_cubit.dart';
import 'package:ecommerce_app/widgets/button_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ButtonIntro(
                func: () {
                  context.read<AuthCubit>().showLogin();
                },
                title: 'Login'),
            const SizedBox(
              height: 40,
            ),
            ButtonIntro(
                func: () {
                  context.read<AuthCubit>().showSignUp();
                },
                title: 'Sign Up'),
          ],
        ),
      ),
    );
  }
}
