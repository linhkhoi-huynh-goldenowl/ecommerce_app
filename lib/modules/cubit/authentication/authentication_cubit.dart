import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/models/e_user.dart';
import 'package:e_commerce_app/modules/repositories/domain.dart';
import 'package:e_commerce_app/modules/repositories/x_result.dart';
import 'package:equatable/equatable.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(const AuthenticationState()) {
    checkAuth();
  }

  void checkAuth() async {
    try {
      final XResult<EUser> result = await Domain().auth.checkAuthentication();
      if (result.isSuccess) {
        emit(state.copyWith(
            status: AuthenticationStatus.authenticated, eUser: result.data));
      } else {
        emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
      }
    } on Exception {
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    }
  }

  void login(String email, String password) async {
    try {
      emit(state.copyWith(submitStatus: AuthSubmitStatus.loading));
      final XResult<EUser> result = await Domain().auth.login(email, password);
      if (result.data != null) {
        emit(state.copyWith(
            status: AuthenticationStatus.authenticated,
            eUser: result.data,
            submitStatus: AuthSubmitStatus.success));
      } else {
        emit(state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            messageError: result.error,
            submitStatus: AuthSubmitStatus.error));
      }
    } on Exception {
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    }
  }

  void signUp(String name, String email, String password) async {
    try {
      emit(state.copyWith(submitStatus: AuthSubmitStatus.loading));
      final XResult<EUser> result = await Domain().auth.signUp(
            name,
            email,
            password,
          );
      if (result.isSuccess) {
        emit(state.copyWith(
            status: AuthenticationStatus.authenticated,
            eUser: result.data,
            submitStatus: AuthSubmitStatus.success));
      } else {
        emit(state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            messageError: result.error,
            submitStatus: AuthSubmitStatus.error));
      }
    } on Exception {
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    }
  }

  void signOut() async {
    try {
      await Domain().auth.signOut();

      emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated, eUser: null));
    } on Exception {
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    }
  }
}
