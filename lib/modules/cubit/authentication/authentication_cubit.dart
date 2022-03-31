import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthRepository authRepo;

  AuthenticationCubit({required this.authRepo})
      : super(const AuthenticationState());

  void login(String email, String password) async {
    try {
      if (await authRepo.login(email, password)) {
        emit(state.copyWith(status: AuthenticationStatus.authenticated));
      } else {
        emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
      }
    } on Exception {
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    }
  }

  void signUp(String name, String email, String password) async {
    try {
      if (await authRepo.signUp(
        name,
        email,
        password,
      )) {
        emit(state.copyWith(status: AuthenticationStatus.authenticated));
      } else {
        emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
      }

      emit(state.copyWith(status: AuthenticationStatus.authenticated));
    } on Exception {
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    }
  }

  void signOut() async {
    try {
      await authRepo.signOut();

      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    } on Exception {
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    }
  }
}
