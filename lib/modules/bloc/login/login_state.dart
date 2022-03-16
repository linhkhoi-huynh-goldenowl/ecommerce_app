part of 'login_bloc.dart';

class LoginState {
  final String username;
  bool get isValidUsername => username.length > 3;

  final String password;
  bool get isValidPassword => password.length > 6;

  final FormLoginStatus formStatus;

  LoginState({
    this.username = '',
    this.password = '',
    this.formStatus = const InitialFormLoginStatus(),
  });

  LoginState copyWith({
    String? username,
    String? password,
    FormLoginStatus? formStatus,
  }) {
    return LoginState(
      username: username ?? this.username,
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
