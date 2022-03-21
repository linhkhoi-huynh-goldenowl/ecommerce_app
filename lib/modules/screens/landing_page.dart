import 'package:ecommerce_app/config/routes/router.dart';
import 'package:ecommerce_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:ecommerce_app/widgets/button_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      // listenWhen: (previous, current) => previous.status == current.status,
      listener: (BuildContext context, state) {
        if (state.status == LoginStatus.authenticated) {
          Navigator.of(context).popAndPushNamed(Routes.dashboard);
        }
        if (state.status == LoginStatus.unauthenticated) {
          Navigator.of(context).popAndPushNamed(Routes.logIn);
        }
      },
      builder: (context, state) => Scaffold(
          body: (state.status == LoginStatus.unKnow)
              ? _buildLoading()
              : _buildBtn(context)),
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
