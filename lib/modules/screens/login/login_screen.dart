import 'package:ecommerce_app/modules/bloc/login/login_bloc.dart';
import 'package:ecommerce_app/modules/repositories/auth_repository.dart';
import 'package:ecommerce_app/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/auth/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

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
        create: (context) => LoginBloc(
          authenticationRepository: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
        ),
        child: _loginForm(),
      ),
    );
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is LoginWrongPassword) {
          _showSnackBar(context, formStatus.message);
        }
        if (formStatus is LoginFailed) {
          _showSnackBar(context, formStatus.exception.toString());
        }
      },
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            const SizedBox(
              height: 10,
            ),
            const Align(
              child: Text(
                "Login",
                style: TextStyle(
                    color: Color(0xff222222),
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.centerLeft,
            ),
            const SizedBox(
              height: 80,
            ),
            _emailField(),
            const SizedBox(
              height: 20,
            ),
            _passwordField(),
            Align(
              alignment: Alignment.topRight,
              child: _forgotButton(),
            ),
            _loginButton(),
            const SizedBox(
              height: 150,
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
      ),
    );
  }

  Widget _emailField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
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
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Email',
              floatingLabelStyle: TextStyle(color: Color(0xffbcbcbc)),
              labelStyle: TextStyle(color: Color(0xffbcbcbc)),
              fillColor: Color(0xffbcbcbc),
              hoverColor: Color(0xffbcbcbc),
              focusColor: Color(0xffbcbcbc),
            ),
            validator: (value) =>
                state.isValidEmail ? null : 'Email is too short',
            onChanged: (value) => context.read<LoginBloc>().add(
                  LoginEmailChanged(email: value),
                ),
          ));
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
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
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelStyle: TextStyle(color: Color(0xffbcbcbc)),
              floatingLabelStyle: TextStyle(color: Color(0xffbcbcbc)),
              labelText: 'Password',
              fillColor: Color(0xffbcbcbc),
              hoverColor: Color(0xffbcbcbc),
              focusColor: Color(0xffbcbcbc),
            ),
            validator: (value) =>
                state.isValidPassword ? null : 'Password is too short',
            onChanged: (value) => context.read<LoginBloc>().add(
                  LoginPasswordChanged(password: value),
                ),
          ));
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.formStatus is FormLoginSubmitting
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
                    context.read<LoginBloc>().add(LoginSubmitted());
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Color(0xfffbedec)),
                ),
              ),
            );
    });
  }

  Widget _forgotButton() {
    return TextButton(
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "Forgot your password?",
              style: TextStyle(color: Color(0xff7d7d7d)),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xffdb3325),
            )
          ],
        ));
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
