part of 'authentication_cubit.dart';

enum AuthenticationStatus {
  unKnow,
  authenticated,
  unauthenticated,
}

enum AuthSubmitStatus { none, loading, success, error }

class AuthenticationState extends Equatable {
  const AuthenticationState(
      {this.status = AuthenticationStatus.unKnow,
      this.eUser,
      this.messageError = "",
      this.submitStatus = AuthSubmitStatus.none});

  final AuthenticationStatus status;
  final EUser? eUser;
  final String messageError;
  final AuthSubmitStatus submitStatus;

  AuthenticationState copyWith(
          {AuthenticationStatus? status,
          EUser? eUser,
          String? messageError,
          AuthSubmitStatus? submitStatus}) =>
      AuthenticationState(
          status: status ?? this.status,
          eUser: eUser ?? this.eUser,
          messageError: messageError ?? this.messageError,
          submitStatus: submitStatus ?? this.submitStatus);

  @override
  List<Object?> get props => [status, eUser, messageError, submitStatus];
}
