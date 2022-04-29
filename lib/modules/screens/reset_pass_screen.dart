import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/utils/helpers/show_snackbar.dart';
import 'package:e_commerce_shop_app/widgets/button_intro.dart';
import 'package:e_commerce_shop_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/authentication/authentication_cubit.dart';

class ResetPassScreen extends StatelessWidget {
  ResetPassScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
        listenWhen: (previous, current) =>
            previous.resetPassStatus != current.resetPassStatus,
        listener: (context, state) {
          if (state.resetPassStatus == ResetPassStatus.failure) {
            AppSnackBar.showSnackBar(context, state.messageError);
          }
          if (state.resetPassStatus == ResetPassStatus.success) {
            AppSnackBar.showSnackBar(context, "An email has been send");
            Navigator.of(context).pop();
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
          body: _resetForm(),
        ));
  }

  Widget _resetForm() {
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
              "Reset Password",
              style:
                  ETextStyle.metropolis(fontSize: 40, weight: FontWeight.bold),
            ),
            alignment: Alignment.center,
          ),
          const SizedBox(
            height: 80,
          ),
          BlocBuilder<AuthenticationCubit, AuthenticationState>(
              buildWhen: (previous, current) =>
                  previous.emailReset != current.emailReset,
              builder: (context, state) {
                return TextFieldWidget(
                    labelText: 'Email Reset',
                    validatorText: 'Email reset must contain @',
                    isValid: state.isValidEmailReset,
                    func: (value) => context
                        .read<AuthenticationCubit>()
                        .emailResetChanged(value),
                    isPassword: false);
              }),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<AuthenticationCubit, AuthenticationState>(
              buildWhen: (previous, current) =>
                  previous.resetPassStatus != current.resetPassStatus,
              builder: (context, stateAuth) {
                return stateAuth.resetPassStatus == ResetPassStatus.loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ButtonIntro(
                        func: () async {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<AuthenticationCubit>()
                                .resetPass(stateAuth.emailReset);
                          }
                        },
                        title: 'Send Email');
              }),
        ],
      ),
    );
  }
}
