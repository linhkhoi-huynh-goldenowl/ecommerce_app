part of 'authentication_cubit.dart';

enum AuthenticationStatus {
  unKnow,
  authenticated,
  unauthenticated,
}

enum ResetPassStatus {
  initial,
  success,
  failure,
  loading,
}

enum AuthSubmitStatus { none, loading, success, error }

class AuthenticationState extends Equatable {
  const AuthenticationState(
      {this.status = AuthenticationStatus.unKnow,
      this.eUser,
      this.messageError = "",
      this.submitStatus = AuthSubmitStatus.none,
      this.resetPassStatus = ResetPassStatus.initial,
      this.emailReset = ""});

  final AuthenticationStatus status;
  final EUser? eUser;
  final String messageError;
  final AuthSubmitStatus submitStatus;
  final ResetPassStatus resetPassStatus;
  final String emailReset;
  bool get isValidEmailReset => emailReset.contains('@');

  AuthenticationState copyWith(
          {AuthenticationStatus? status,
          EUser? eUser,
          String? messageError,
          AuthSubmitStatus? submitStatus,
          ResetPassStatus? resetPassStatus,
          String? emailReset}) =>
      AuthenticationState(
          status: status ?? this.status,
          eUser: eUser ?? this.eUser,
          messageError: messageError ?? this.messageError,
          submitStatus: submitStatus ?? this.submitStatus,
          resetPassStatus: resetPassStatus ?? this.resetPassStatus,
          emailReset: emailReset ?? this.emailReset);

  @override
  List<Object?> get props =>
      [status, eUser, messageError, submitStatus, resetPassStatus, emailReset];
}
