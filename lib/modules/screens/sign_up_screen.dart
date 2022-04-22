import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/sign_up/sign_up_cubit.dart';
import 'package:e_commerce_shop_app/utils/helpers/show_snackbar.dart';
import 'package:e_commerce_shop_app/widgets/button_intro.dart';
import 'package:e_commerce_shop_app/widgets/text_button_intro.dart';
import 'package:e_commerce_shop_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/routes/router.dart';
import '../../widgets/social_button.dart';
import '../cubit/sign_up/sign_up_cubit.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignUpScreen({Key? key}) : super(key: key);

  final FocusNode focusEmail = FocusNode();
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
            create: (context) => SignUpCubit(),
            child: _signUpForm(context),
          ),
        ));
  }

  Widget _signUpForm(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              Align(
                child: Text("Sign Up",
                    style: ETextStyle.metropolis(
                        fontSize: 40, weight: FontWeight.bold)),
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(
                height: 60,
              ),
              TextFieldWidget(
                onEditComplete: () =>
                    FocusScope.of(context).requestFocus(focusEmail),
                labelText: 'Name',
                validatorText: 'Name must more than 3',
                isValid: state.isValidName,
                func: (value) =>
                    context.read<SignUpCubit>().signUpNameChanged(value),
                isPassword: false,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                focusNode: focusEmail,
                onEditComplete: () =>
                    FocusScope.of(context).requestFocus(focusPass),
                labelText: 'Email',
                validatorText: 'Email must contain @',
                isValid: state.isValidEmail,
                func: (value) =>
                    context.read<SignUpCubit>().signUpEmailChanged(value),
                isPassword: false,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                focusNode: focusPass,
                onEditComplete: () => focusPass.unfocus(),
                labelText: 'Password',
                validatorText: 'Password must more than 6',
                isValid: state.isValidPassword,
                func: (value) =>
                    context.read<SignUpCubit>().signUpPasswordChanged(value),
                isPassword: true,
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButtonIntro(
                    func: () => Navigator.of(context)
                        .pushReplacementNamed(Routes.logIn),
                    text: "Already have an account?"),
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
                                    .signUp(state.name, state.email,
                                        state.password);
                                if (result) {
                                  _formKey.currentState!.reset();
                                }
                              }
                            },
                            title: 'Sign Up');
                  }),
              const SizedBox(
                height: 70,
              ),
              Column(
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
                              func:
                                  state.submitStatus == AuthSubmitStatus.loading
                                      ? () {}
                                      : () {
                                          context
                                              .read<AuthenticationCubit>()
                                              .loginWithGoogle();
                                        },
                              name: "google"),
                          SocialButton(
                              func:
                                  state.submitStatus == AuthSubmitStatus.loading
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
              )
            ],
          ),
        );
      },
    );
  }
}
