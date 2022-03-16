import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/social_button.dart';
import '../../bloc/sign_up/sign_up_bloc.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../../repositories/auth_repository.dart';

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
            context.read<AuthCubit>().showIntro();
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
          authCubit: context.read<AuthCubit>(),
        ),
        child: _signUpForm(context),
      ),
    );
  }

  Widget _signUpForm(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SignUpFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          }
          if (formStatus is SignUpExistsEmail) {
            _showSnackBar(context, formStatus.message);
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              const Align(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Color(0xff222222),
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(
                height: 60,
              ),
              _usernameField(),
              const SizedBox(
                height: 20,
              ),
              _emailField(),
              const SizedBox(
                height: 20,
              ),
              _passwordField(),
              Align(
                alignment: Alignment.topRight,
                child: _haveAccountButton(context),
              ),
              _signUpButton(),
              const SizedBox(
                height: 70,
              ),
              Column(
                children: [
                  const Text(
                    "Or login with social account",
                    style: TextStyle(color: Color(0xff414141), fontSize: 18),
                  ),
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
        ));
  }

  Widget _usernameField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: TextFormField(
            decoration: InputDecoration(
              suffix: state.isValidEmail
                  ? const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
              border: InputBorder.none,
              labelStyle: const TextStyle(color: Color(0xffbcbcbc)),
              floatingLabelStyle: const TextStyle(color: Color(0xffbcbcbc)),
              labelText: 'Name',
              fillColor: const Color(0xffbcbcbc),
              hoverColor: const Color(0xffbcbcbc),
              focusColor: const Color(0xffbcbcbc),
            ),
            validator: (value) =>
                state.isValidName ? null : 'Name is too short',
            onChanged: (value) => context.read<SignUpBloc>().add(
                  SignUpNameChanged(name: value),
                ),
          ));
    });
  }

  Widget _emailField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: TextFormField(
            decoration: InputDecoration(
              suffix: state.isValidEmail
                  ? const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
              border: InputBorder.none,
              labelStyle: const TextStyle(color: Color(0xffbcbcbc)),
              floatingLabelStyle: const TextStyle(color: Color(0xffbcbcbc)),
              labelText: 'Email',
              fillColor: const Color(0xffbcbcbc),
              hoverColor: const Color(0xffbcbcbc),
              focusColor: const Color(0xffbcbcbc),
            ),
            validator: (value) => state.isValidEmail ? null : 'Invalid email',
            onChanged: (value) => context.read<SignUpBloc>().add(
                  SignUpEmailChanged(email: value),
                ),
          ));
    });
  }

  Widget _passwordField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              suffix: state.isValidPassword
                  ? const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
              border: InputBorder.none,
              labelStyle: const TextStyle(color: Color(0xffbcbcbc)),
              floatingLabelStyle: const TextStyle(color: Color(0xffbcbcbc)),
              labelText: 'Password',
              fillColor: const Color(0xffbcbcbc),
              hoverColor: const Color(0xffbcbcbc),
              focusColor: const Color(0xffbcbcbc),
            ),
            validator: (value) =>
                state.isValidPassword ? null : 'Password is too short',
            onChanged: (value) => context.read<SignUpBloc>().add(
                  SignUpPasswordChanged(password: value),
                ),
          ));
    });
  }

  Widget _haveAccountButton(BuildContext context) {
    return TextButton(
        onPressed: () => context.read<AuthCubit>().showLogin(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "Already have an account?",
              style: TextStyle(color: Color(0xff7d7d7d)),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xffdb3325),
            )
          ],
        ));
  }

  Widget _signUpButton() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return state.formStatus is FormSignUpSubmitting
          ? const CircularProgressIndicator()
          : SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  primary: const Color(0xffdb3022),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 15.0,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<SignUpBloc>().add(SignUpSubmitted());
                  }
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18, color: Color(0xfffbedec)),
                ),
              ),
            );
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
