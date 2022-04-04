import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/cubit/login/login_cubit.dart';
import 'package:e_commerce_app/widgets/button_intro.dart';
import 'package:e_commerce_app/widgets/social_button.dart';
import 'package:e_commerce_app/widgets/text_button_intro.dart';
import 'package:e_commerce_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/authentication/authentication_cubit.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final FocusNode focusPass = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state.submitStatus == AuthSubmitStatus.error) {
            _showSnackBar(context, state.messageError);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          body: BlocProvider(
            create: (context) => LoginCubit(),
            child: _loginForm(),
          ),
        ));
  }

  Widget _loginForm() {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              const SizedBox(
                height: 10,
              ),
              Align(
                child: Text(
                  "Login",
                  style: ETextStyle.metropolis(
                      fontSize: 40, weight: FontWeight.bold),
                ),
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(
                height: 80,
              ),
              TextFieldWidget(
                  onEditComplete: () =>
                      FocusScope.of(context).requestFocus(focusPass),
                  labelText: 'Email',
                  validatorText: 'Email must contain @',
                  isValid: state.isValidEmail,
                  func: (value) =>
                      context.read<LoginCubit>().loginEmailChanged(value),
                  isPassword: false),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  onEditComplete: () => focusPass.unfocus(),
                  focusNode: focusPass,
                  labelText: 'Password',
                  validatorText: 'Password must more than 6',
                  isValid: state.isValidPassword,
                  func: (value) =>
                      context.read<LoginCubit>().loginPasswordChanged(value),
                  isPassword: true),
              Align(
                alignment: Alignment.topRight,
                child:
                    TextButtonIntro(func: () {}, text: "Forgot your password?"),
              ),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                  buildWhen: (previous, current) =>
                      previous.submitStatus != current.submitStatus,
                  builder: (context, stateAuth) {
                    return stateAuth.submitStatus == AuthSubmitStatus.loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ButtonIntro(
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
                  }),
              const SizedBox(
                height: 150,
              ),
              Column(
                children: [
                  Text("Or login with social account",
                      style: ETextStyle.metropolis(
                          color: const Color(0xff414141), fontSize: 18)),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialButton(func: () {}, name: "google"),
                      SocialButton(func: () {}, name: "facebook")
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
