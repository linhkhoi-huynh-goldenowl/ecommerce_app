part of 'login_bloc.dart';

class LoginState {
  final String email;
  bool get isValidEmail => email.contains('@');

  final String password;
  bool get isValidPassword => password.length > 6;

  final FormLoginStatus formStatus;

  LoginState({
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormLoginStatus(),
  });

  LoginState copyWith({
    String? email,
    String? password,
    FormLoginStatus? formStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}

abstract class FormLoginStatus {
  const FormLoginStatus();
}

class InitialFormLoginStatus extends FormLoginStatus {
  const InitialFormLoginStatus();
}

class FormLoginTyping extends FormLoginStatus {}

class FormLoginSubmitting extends FormLoginStatus {}

class LoginSuccess extends FormLoginStatus {}

class LoginWrongPassword extends FormLoginStatus {
  final String message = "Wrong Password";
}

class LoginFailed extends FormLoginStatus {
  final Exception exception;

  LoginFailed(this.exception);
}
