import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/modules/cubit/auth/auth_cubit.dart';
import 'package:ecommerce_app/modules/repositories/auth_repository.dart';

import '../../models/auth_credentials.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(
      {required AuthRepository authenticationRepository,
      required this.authCubit})
      : _authenticationRepository = authenticationRepository,
        super(LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthRepository _authenticationRepository;
  final AuthCubit authCubit;

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(email: event.email, formStatus: FormLoginTyping()),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(password: event.password, formStatus: FormLoginTyping()),
    );
  }

  void _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(formStatus: FormLoginSubmitting()));
    try {
      if (await _authenticationRepository.login(
            email: state.email,
            password: state.password,
          ) ==
          true) {
        authCubit.launchDashboard(AuthCredentials(email: state.email));
        emit(state.copyWith(formStatus: LoginSuccess()));
      } else {
        emit(state.copyWith(formStatus: LoginWrongPassword()));
      }
    } catch (e) {
      emit(state.copyWith(formStatus: LoginFailed(e as Exception)));
    }
  }
}
