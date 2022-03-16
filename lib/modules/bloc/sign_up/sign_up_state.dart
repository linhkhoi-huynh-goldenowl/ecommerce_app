part of 'sign_up_bloc.dart';

class SignUpState {
  final String name;
  bool get isValidName => name.length > 3;

  final String email;
  bool get isValidEmail => email.contains('@');

  final String password;
  bool get isValidPassword => password.length > 6;

  final FormSignUpStatus formStatus;

  SignUpState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormSignUpStatus(),
  });

  SignUpState copyWith({
    String? name,
    String? email,
    String? password,
    FormSignUpStatus? formStatus,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}

abstract class FormSignUpStatus {
  const FormSignUpStatus();
}

class InitialFormSignUpStatus extends FormSignUpStatus {
  const InitialFormSignUpStatus();
}

class FormSignUpTyping extends FormSignUpStatus {}

class FormSignUpSubmitting extends FormSignUpStatus {}

class SignUpSuccess extends FormSignUpStatus {}

class SignUpExistsEmail extends FormSignUpStatus {
  final String message = "Email Exists";
}

class SignUpFailed extends FormSignUpStatus {
  final Exception exception;

  SignUpFailed(this.exception);
}
