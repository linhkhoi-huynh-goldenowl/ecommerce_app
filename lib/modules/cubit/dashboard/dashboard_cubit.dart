import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/modules/repositories/auth_repository.dart';

import '../../models/auth_credentials.dart';

part 'dashboard_state.dart';

//TODO: sửa lại DashboardCubit => AccountBloc
// Vì DashboardCubit nhưng không sử dụng ở màn hình dashboard
class DashboardCubit extends Cubit<DashboardState> {
  final AuthRepository authRepo;

  DashboardCubit({required this.authRepo}) : super(DashboardState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final checkAuth = await authRepo.attemptAutoLogin();
      if (checkAuth) {
        emit(state.copyWith(status: LoginStatus.authenticated));
      } else {
        emit(state.copyWith(status: LoginStatus.unauthenticated));
      }
    } on Exception {
      emit(state.copyWith(status: LoginStatus.unauthenticated));
    }
  }

  // void showAuth() => emit(Unauthenticated());
  void navigateDashboard(AuthCredentials credentials) {
    // emit(Authenticated());
  }

  void signOut() {
    authRepo.signOut();
    // emit(Unauthenticated());
  }
}
