import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/modules/repositories/auth_repository.dart';

import '../../models/auth_credentials.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final AuthRepository authRepo;

  DashboardCubit({required this.authRepo}) : super(UnknownDashboardState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final checkAuth = await authRepo.attemptAutoLogin();
      if (checkAuth) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());
  void showDashboard(AuthCredentials credentials) {
    emit(Authenticated());
  }

  void signOut() {
    authRepo.signOut();
    emit(Unauthenticated());
  }
}
