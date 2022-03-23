import 'package:ecommerce_app/config/styles/text_style.dart';
import 'package:ecommerce_app/widgets/button_intro.dart';
import 'package:ecommerce_app/widgets/text_button_intro.dart';
import 'package:ecommerce_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/routes/router.dart';
import '../../widgets/social_button.dart';
import '../bloc/sign_up/sign_up_bloc.dart';
import '../repositories/auth_repository.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        create: (context) => SignUpBloc(
          authRepo: context.read<AuthRepository>(),
          context: context,
        ),
        child: _signUpForm(context),
      ),
    );
  }

  Widget _signUpForm(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SignUpFailed) {
          _showSnackBar(context, formStatus.exception.toString());
        }
        if (formStatus is SignUpExistsEmail) {
          _showSnackBar(context, formStatus.message);
        }
      },
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
                labelText: 'Name',
                validatorText: 'Name must more than 3',
                isValid: state.isValidName,
                func: (value) => context.read<SignUpBloc>().add(
                      SignUpNameChanged(name: value),
                    ),
                isPassword: false,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                labelText: 'Email',
                validatorText: 'Email must contain @',
                isValid: state.isValidEmail,
                func: (value) => context.read<SignUpBloc>().add(
                      SignUpEmailChanged(email: value),
                    ),
                isPassword: false,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                labelText: 'Password',
                validatorText: 'Password must more than 6',
                isValid: state.isValidPassword,
                func: (value) => context.read<SignUpBloc>().add(
                      SignUpPasswordChanged(password: value),
                    ),
                isPassword: true,
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButtonIntro(
                    func: () => Navigator.of(context)
                        .pushReplacementNamed(Routes.logIn),
                    text: "Already have an account?"),
              ),
              state.formStatus is FormSignUpSubmitting
                  ? const CircularProgressIndicator()
                  : ButtonIntro(
                      func: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<SignUpBloc>().add(SignUpSubmitted());
                        }
                      },
                      title: 'Sign Up'),
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

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
