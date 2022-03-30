import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void loginEmailChanged(String email) {
    emit(state.copyWith(email: email, status: LoginStatus.typing));
    if (state.isValidEmail) {
      emit(state.copyWith(status: LoginStatus.typed));
    } else {
      emit(state.copyWith(status: LoginStatus.typing));
    }
  }

  void loginPasswordChanged(String password) {
    emit(state.copyWith(password: password, status: LoginStatus.typing));
    if (state.isValidPassword) {
      emit(state.copyWith(status: LoginStatus.typed));
    } else {
      emit(state.copyWith(status: LoginStatus.typing));
    }
  }
}
