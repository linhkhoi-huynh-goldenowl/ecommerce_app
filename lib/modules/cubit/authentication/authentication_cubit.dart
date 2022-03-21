import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/modules/repositories/auth_repository.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthRepository authRepo;

  AuthenticationCubit({required this.authRepo}) : super(AuthenticationState()) {
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

  // // void showAuth() => emit(Unauthenticated());
  // void navigateDashboard(AuthCredentials credentials) {
  //   // emit(Authenticated());
  // }

  void signOut() {
    authRepo.signOut();
    attemptAutoLogin();
  }
}
