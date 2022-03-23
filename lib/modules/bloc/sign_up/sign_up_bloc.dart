import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/config/routes/router.dart';
import 'package:flutter/material.dart';
import '../../repositories/auth_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required this.authRepo, required this.context})
      : super(SignUpState()) {
    on<SignUpNameChanged>(_onSignUpNameChanged);
    on<SignUpEmailChanged>(_onSignUpEmailChanged);
    on<SignUpPasswordChanged>(_onSignUpPasswordChanged);
    on<SignUpSubmitted>(_onSubmitted);
  }

  final AuthRepository authRepo;
  final BuildContext context;

  void _onSignUpNameChanged(
    SignUpNameChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(name: event.name, formStatus: FormSignUpTyping()),
    );
  }

  void _onSignUpEmailChanged(
    SignUpEmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(email: event.email, formStatus: FormSignUpTyping()),
    );
  }

  void _onSignUpPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      state.copyWith(password: event.password, formStatus: FormSignUpTyping()),
    );
  }

  void _onSubmitted(SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(formStatus: FormSignUpSubmitting()));
    try {
      if (await authRepo.signUp(
            name: state.name,
            email: state.email,
            password: state.password,
          ) ==
          false) {
        emit(state.copyWith(formStatus: SignUpExistsEmail()));
      } else {
        emit(state.copyWith(formStatus: SignUpSuccess()));
        Navigator.of(context).pushNamed(Routes.dashboard);
      }
    } catch (e) {
      emit(state.copyWith(formStatus: SignUpFailed(e as Exception)));
    }
  }
}
