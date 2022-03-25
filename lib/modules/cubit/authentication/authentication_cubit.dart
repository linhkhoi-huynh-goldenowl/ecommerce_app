import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/repositories/auth_repository.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthRepository authRepo;

  AuthenticationCubit({required this.authRepo}) : super(AuthenticationState()) {
    checkAuth();
  }

  void checkAuth() async {
    try {
      final checkAuth = await authRepo.checkAuthentication();
      if (checkAuth) {
        emit(state.copyWith(status: LoginStatus.authenticated));
      } else {
        emit(state.copyWith(status: LoginStatus.unauthenticated));
      }
    } on Exception {
      emit(state.copyWith(status: LoginStatus.unauthenticated));
    }
  }

  // // void showAuth() => emit(Unauthenticated());
  // void navigateDashboard(AuthCredentials credentials) {
  //   // emit(Authenticated());
  // }

  void signOut() async {
    await authRepo.signOut();
    checkAuth();
  }
}
