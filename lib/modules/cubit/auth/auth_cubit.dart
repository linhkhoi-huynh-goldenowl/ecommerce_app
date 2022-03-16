import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/modules/models/auth_credentials.dart';

import '../dashboard/dashboard_cubit.dart';

enum AuthState { login, signUp, confirmSignUp }

class AuthCubit extends Cubit<AuthState> {
  final DashboardCubit dashboardCubit;

  AuthCubit({required this.dashboardCubit}) : super(AuthState.login);

  late AuthCredentials credentials;

  void showLogin() => emit(AuthState.login);
  void showSignUp() => emit(AuthState.signUp);

  void launchDashboard(AuthCredentials credentials) =>
      dashboardCubit.showDashboard(credentials);
}
