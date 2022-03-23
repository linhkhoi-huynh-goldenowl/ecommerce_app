import 'package:ecommerce_app/config/routes/router.dart';
import 'package:ecommerce_app/config/styles/text_style.dart';
import 'package:ecommerce_app/modules/bloc/login/login_bloc.dart';
import 'package:ecommerce_app/modules/repositories/auth_repository.dart';
import 'package:ecommerce_app/widgets/button_intro.dart';
import 'package:ecommerce_app/widgets/social_button.dart';
import 'package:ecommerce_app/widgets/text_button_intro.dart';
import 'package:ecommerce_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            Navigator.of(context).pushNamed(Routes.landing);
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
          context: context,
        ),
        child: _loginForm(),
      ),
    );
  }

  Widget _loginForm() {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is LoginWrongPassword) {
          _showSnackBar(context, formStatus.message);
        }
        if (formStatus is LoginFailed) {
          _showSnackBar(context, formStatus.exception.toString());
        }
      },
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
                  labelText: 'Email',
                  validatorText: 'Name must more than 3',
                  isValid: state.isValidEmail,
                  func: (value) => context.read<LoginBloc>().add(
                        LoginEmailChanged(email: value),
                      ),
                  isPassword: false),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  labelText: 'Password',
                  validatorText: 'Password must more than 6',
                  isValid: state.isValidPassword,
                  func: (value) => context.read<LoginBloc>().add(
                        LoginPasswordChanged(password: value),
                      ),
                  isPassword: true),
              Align(
                alignment: Alignment.topRight,
                child:
                    TextButtonIntro(func: () {}, text: "Forgot your password?"),
              ),
              state.formStatus is FormLoginSubmitting
                  ? const CircularProgressIndicator()
                  : ButtonIntro(
                      func: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(LoginSubmitted());
                        }
                      },
                      title: 'Login'),
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

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
