part of 'dashboard_cubit.dart';

enum LoginStatus {
  unKnow,
  authenticated,
  unauthenticated,
}

class DashboardState {
  final LoginStatus status;
  DashboardState({this.status = LoginStatus.unKnow});

  DashboardState copyWith({LoginStatus? status}) =>
      DashboardState(status: status ?? this.status);
}
