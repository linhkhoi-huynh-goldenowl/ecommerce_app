part of 'sign_up_bloc.dart';

abstract class SignUpEvent {}

class SignUpNameChanged extends SignUpEvent {
  final String name;

  SignUpNameChanged({required this.name});
}

class SignUpEmailChanged extends SignUpEvent {
  final String email;

  SignUpEmailChanged({required this.email});
}

class SignUpPasswordChanged extends SignUpEvent {
  final String password;

  SignUpPasswordChanged({required this.password});
}

class SignUpSubmitted extends SignUpEvent {}
