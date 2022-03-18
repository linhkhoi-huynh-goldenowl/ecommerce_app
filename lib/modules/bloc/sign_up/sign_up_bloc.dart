import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/modules/cubit/auth/auth_cubit.dart';
import 'package:ecommerce_app/modules/models/auth_credentials.dart';
import '../../repositories/auth_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required this.authRepo, required this.authCubit})
      : super(SignUpState()) {
    on<SignUpUsernameChanged>(_onSignUpUsernameChanged);
    on<SignUpEmailChanged>(_onSignUpEmailChanged);
    on<SignUpPasswordChanged>(_onSignUpPasswordChanged);
    on<SignUpSubmitted>(_onSubmitted);
  }

  final AuthRepository authRepo;
  final AuthCubit authCubit;

  void _onSignUpUsernameChanged(
    SignUpUsernameChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(username: event.username, formStatus: FormSignUpTyping()),
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

  void _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(formStatus: FormSignUpSubmitting()));
    try {
      if (await authRepo.signUp(
            username: state.username,
            email: state.email,
            password: state.password,
          ) ==
          false) {
        emit(state.copyWith(formStatus: SignUpExistsUsername()));
      } else {
        emit(state.copyWith(formStatus: SignUpSuccess()));
        authCubit.launchDashboard(AuthCredentials(username: state.username));
      }
    } catch (e) {
      emit(state.copyWith(formStatus: SignUpFailed(e as Exception)));
    }
  }
}
