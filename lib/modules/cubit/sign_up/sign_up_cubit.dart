import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

  void signUpNameChanged(String name) {
    emit(state.copyWith(name: name, status: SignUpStatus.typing));
    if (state.isValidName) {
      emit(state.copyWith(status: SignUpStatus.typed));
    } else {
      emit(state.copyWith(status: SignUpStatus.typing));
    }
  }

  void signUpEmailChanged(String email) {
    emit(state.copyWith(email: email, status: SignUpStatus.typing));
    if (state.isValidEmail) {
      emit(state.copyWith(status: SignUpStatus.typed));
    } else {
      emit(state.copyWith(status: SignUpStatus.typing));
    }
  }

  void signUpPasswordChanged(String password) {
    emit(state.copyWith(password: password, status: SignUpStatus.typing));
    if (state.isValidPassword) {
      emit(state.copyWith(status: SignUpStatus.typed));
    } else {
      emit(state.copyWith(status: SignUpStatus.typing));
    }
  }
}
