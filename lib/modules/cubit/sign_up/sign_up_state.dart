part of 'sign_up_cubit.dart';

enum SignUpStatus { initial, typing, typed, submitting }

class SignUpState extends Equatable {
  const SignUpState({
    this.status = SignUpStatus.initial,
    this.name = "",
    this.email = "",
    this.password = "",
  });
  final SignUpStatus status;

  final String email;
  bool get isValidEmail => email.contains('@');

  final String name;
  bool get isValidName => name.length > 3;

  final String password;
  bool get isValidPassword => password.length > 6;

  SignUpState copyWith({
    SignUpStatus? status,
    String? email,
    String? name,
    String? password,
  }) {
    return SignUpState(
        status: status ?? this.status,
        email: email ?? this.email,
        name: name ?? this.name,
        password: password ?? this.password);
  }

  @override
  List<Object> get props => [status, email, name, password];
}
