import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/e_user.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';
import 'package:e_commerce_shop_app/modules/repositories/x_result.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(const AuthenticationState()) {
    checkAuth();
  }

  void checkAuth() async {
    try {
      final XResult<EUser> result = await Domain().auth.checkAuthentication();
      if (result.isSuccess) {
        await Domain().profile.setCurrentUser(result.data!);
        emit(state.copyWith(
            status: AuthenticationStatus.authenticated,
            eUser: result.data,
            messageError: ""));
      } else {
        emit(state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            messageError: result.error));
      }
    } on Exception {
      emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          messageError: "Something wrong"));
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      emit(state.copyWith(submitStatus: AuthSubmitStatus.loading));
      final XResult<EUser> result = await Domain().auth.login(email, password);
      if (result.isSuccess) {
        Domain().profile.setCurrentUser(result.data!);
        emit(state.copyWith(
            status: AuthenticationStatus.authenticated,
            eUser: result.data,
            submitStatus: AuthSubmitStatus.success,
            messageError: ""));
        return true;
      } else {
        emit(state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            messageError: result.error,
            submitStatus: AuthSubmitStatus.error));
        return false;
      }
    } on Exception {
      emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          messageError: "Something wrong"));
    }
    return false;
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      emit(state.copyWith(submitStatus: AuthSubmitStatus.loading));
      final XResult<EUser> result = await Domain().auth.signUp(
            name,
            email,
            password,
          );
      if (result.isSuccess) {
        Domain().profile.setCurrentUser(result.data!);
        emit(state.copyWith(
            status: AuthenticationStatus.authenticated,
            eUser: result.data,
            submitStatus: AuthSubmitStatus.success,
            messageError: ""));
        return true;
      } else {
        emit(state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            messageError: result.error,
            submitStatus: AuthSubmitStatus.error));
        return false;
      }
    } on Exception {
      emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          messageError: "Something wrong"));
    }
    return false;
  }

  Future<bool> loginWithGoogle() async {
    try {
      emit(state.copyWith(submitStatus: AuthSubmitStatus.loading));
      final XResult<EUser> result = await Domain().auth.loginWithGoogle();

      if (result.isSuccess) {
        Domain().profile.setCurrentUser(result.data!);
        emit(state.copyWith(
            status: AuthenticationStatus.authenticated,
            eUser: result.data,
            submitStatus: AuthSubmitStatus.success,
            messageError: ""));
      } else {
        emit(state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            messageError: result.error,
            submitStatus: AuthSubmitStatus.error));
      }
      return true;
    } on Exception {
      emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          messageError: "Something wrong"));
    }
    return false;
  }

  Future<bool> loginWithFacebook() async {
    try {
      emit(state.copyWith(submitStatus: AuthSubmitStatus.loading));
      final XResult<EUser> result = await Domain().auth.loginWithFacebook();
      if (result.isSuccess) {
        Domain().profile.setCurrentUser(result.data!);
        emit(state.copyWith(
            status: AuthenticationStatus.authenticated,
            eUser: result.data,
            submitStatus: AuthSubmitStatus.success,
            messageError: ""));
      } else {
        emit(state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            messageError: result.error,
            submitStatus: AuthSubmitStatus.error));
      }
      return true;
    } on Exception {
      emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          messageError: "Something wrong"));
    }
    return false;
  }

  void resetPass(String emailReset) async {
    try {
      emit(state.copyWith(resetPassStatus: ResetPassStatus.loading));
      final XResult<String> res = await Domain().auth.resetPassword(emailReset);
      if (res.isSuccess) {
        emit(state.copyWith(resetPassStatus: ResetPassStatus.success));

        emit(state.copyWith(
            resetPassStatus: ResetPassStatus.initial,
            messageError: "",
            emailReset: ""));
      } else {
        emit(state.copyWith(
            resetPassStatus: ResetPassStatus.failure, messageError: res.error));
      }
    } catch (_) {
      emit(state.copyWith(
          resetPassStatus: ResetPassStatus.failure,
          messageError: "Something wrong"));
    }
  }

  void emailResetChanged(String email) {
    emit(state.copyWith(emailReset: email));
  }

  void signOut(BuildContext context, VoidCallback navigateLogin) async {
    try {
      await Domain().auth.signOut();
      navigateLogin();
      emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          eUser: null,
          messageError: ""));
    } on Exception {
      emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          messageError: "Something wrong"));
    }
  }
}
