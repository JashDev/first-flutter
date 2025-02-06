import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_example/core/utils/loader.dart';
import '../domain/login_usercase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      Loader().show();
      emit(LoginLoading());

      if (event.email.isEmpty || event.password.isEmpty) {
        emit(LoginValidationFailed(
          emailError:
              event.email.isEmpty ? 'El correo no puede estar vacío' : null,
          passwordError: event.password.isEmpty
              ? 'La contraseña no puede estar vacía'
              : null,
        ));
        return;
      }

      try {
        final success = await loginUseCase.execute(event.email, event.password);
        if (success) {
          emit(LoginSuccess());
        } else {
          emit(LoginValidationFailed(
              emailError: 'Email incorrecto',
              passwordError: 'Contraseña incorrecta'));
          emit(LoginFailure(error: 'Email o contraseña incorrectos'));
        }
      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      } finally {
        Loader().hide();
      }
    });
  }

  void login({required String email, required String password}) async {
    add(LoginButtonPressed(email: email, password: password));
  }
}
