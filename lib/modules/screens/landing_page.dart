import 'package:e_commerce_app/config/routes/router.dart';
import 'package:e_commerce_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:e_commerce_app/widgets/button_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: (state.status == AuthenticationStatus.unKnow)
                ? _buildLoading()
                : _buildBtn(context)),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonIntro(
              func: () {
                Navigator.of(context).pushNamed(Routes.logIn);
              },
              title: 'Login'),
          const SizedBox(
            height: 40,
          ),
          ButtonIntro(
              func: () {
                Navigator.of(context).pushNamed(Routes.signUp);
              },
              title: 'Sign Up'),
        ],
      ),
    );
  }
}
