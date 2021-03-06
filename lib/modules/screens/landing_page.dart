import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/loading_widget.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          Navigator.of(context).pushNamed(Routes.dashboard);
        }
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: (state.status == AuthenticationStatus.unKnow)
                ? const LoadingWidget()
                : _buildBtn(context)),
      ),
    );
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
