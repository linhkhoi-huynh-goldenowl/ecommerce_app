part of 'authentication_cubit.dart';

enum LoginStatus {
  unKnow,
  authenticated,
  unauthenticated,
}

class AuthenticationState {
  LoginStatus status;
  AuthenticationState({this.status = LoginStatus.unKnow});

  AuthenticationState copyWith({LoginStatus? status}) =>
      AuthenticationState(status: status ?? this.status);
}
