part of 'login_cubit.dart';

enum LoginStatus { initial, typing, typed, submitting }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.email = "",
    this.password = "",
  });
  final LoginStatus status;

  final String email;
  bool get isValidEmail => email.contains('@');

  final String password;
  bool get isValidPassword => password.length > 6;

  LoginState copyWith({
    LoginStatus? status,
    String? email,
    String? password,
  }) {
    return LoginState(
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password);
  }

  @override
  List<Object> get props => [status, email, password];
}
