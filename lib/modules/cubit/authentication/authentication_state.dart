part of 'authentication_cubit.dart';

enum AuthenticationStatus {
  unKnow,
  authenticated,
  unauthenticated,
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  const AuthenticationState(
      {this.status = AuthenticationStatus.unauthenticated});

  AuthenticationState copyWith({AuthenticationStatus? status}) =>
      AuthenticationState(status: status ?? this.status);

  @override
  List<Object?> get props => [status];
}
