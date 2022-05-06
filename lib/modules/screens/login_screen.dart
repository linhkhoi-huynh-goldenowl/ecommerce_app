import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/login/login_cubit.dart';
import 'package:e_commerce_shop_app/utils/helpers/show_snackbar.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_intro.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_leading.dart';
import 'package:e_commerce_shop_app/widgets/buttons/social_button.dart';
import 'package:e_commerce_shop_app/widgets/buttons/text_button_intro.dart';
import 'package:e_commerce_shop_app/widgets/textfields/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/loading_widget.dart';
import '../cubit/authentication/authentication_cubit.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  final FocusNode focusPass = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
        listenWhen: (previous, current) =>
            previous.submitStatus != current.submitStatus,
        listener: (context, state) {
          if (state.submitStatus == AuthSubmitStatus.error) {
            AppSnackBar.showSnackBar(context, state.messageError);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: const ButtonLeading(),
          ),
          body: BlocProvider(
            create: (context) => LoginCubit(),
            child: _loginForm(),
          ),
        ));
  }

  Widget _loginForm() {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              const SizedBox(
                height: 10,
              ),
              _loginTitle(),
              const SizedBox(
                height: 80,
              ),
              _inputEmailField(),
              const SizedBox(
                height: 20,
              ),
              _inputPasswordField(),
              _forgotPassButton(context),
              _buttonLogin(),
              const SizedBox(
                height: 150,
              ),
              _showLoginSocial(),
            ],
          ),
        );
      },
    );
  }

  Widget _loginTitle() {
    return Align(
      child: Text(
        "Login",
        style: ETextStyle.metropolis(fontSize: 40, weight: FontWeight.bold),
      ),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _inputEmailField() {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.isValidEmail != current.isValidEmail,
      builder: (context, state) {
        return TextFieldWidget(
            onEditComplete: () =>
                FocusScope.of(context).requestFocus(focusPass),
            labelText: 'Email',
            validatorText: 'Email must contain @',
            isValid: state.isValidEmail,
            func: (value) =>
                context.read<LoginCubit>().loginEmailChanged(value),
            isPassword: false);
      },
    );
  }

  Widget _inputPasswordField() {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.isValidPassword != current.isValidPassword,
      builder: (context, state) {
        return TextFieldWidget(
            onEditComplete: () => focusPass.unfocus(),
            focusNode: focusPass,
            labelText: 'Password',
            validatorText: 'Password must more than 6',
            isValid: state.isValidPassword,
            func: (value) =>
                context.read<LoginCubit>().loginPasswordChanged(value),
            isPassword: true);
      },
    );
  }

  Widget _buttonLogin() {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
        buildWhen: (previous, current) =>
            previous.submitStatus != current.submitStatus,
        builder: (context, stateAuth) {
          return stateAuth.submitStatus == AuthSubmitStatus.loading
              ? const LoadingWidget()
              : BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.email != current.email ||
                      previous.password != current.password,
                  builder: (context, state) {
                    return ButtonIntro(
                        func: () async {
                          if (_formKey.currentState!.validate()) {
                            final result = await context
                                .read<AuthenticationCubit>()
                                .login(state.email, state.password);
                            if (result) {
                              _formKey.currentState!.reset();
                            }
                          }
                        },
                        title: 'Login');
                  },
                );
        });
  }

  Widget _forgotPassButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: TextButtonIntro(
          func: () {
            Navigator.of(context).pushNamed(Routes.resetPassScreen);
          },
          text: "Forgot your password?"),
    );
  }

  Widget _showLoginSocial() {
    return Column(
      children: [
        Text("Or login with social account",
            style: ETextStyle.metropolis(
                color: const Color(0xff414141), fontSize: 18)),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<AuthenticationCubit, AuthenticationState>(
          buildWhen: (previous, current) =>
              previous.submitStatus != current.submitStatus,
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SocialButton(
                    func: state.submitStatus == AuthSubmitStatus.loading
                        ? () {}
                        : () {
                            context
                                .read<AuthenticationCubit>()
                                .loginWithGoogle();
                          },
                    name: "google"),
                SocialButton(
                    func: state.submitStatus == AuthSubmitStatus.loading
                        ? () {}
                        : () {
                            context
                                .read<AuthenticationCubit>()
                                .loginWithFacebook();
                          },
                    name: "facebook")
              ],
            );
          },
        ),
      ],
    );
  }
}
