import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_example/core/utils/loader.dart';
import '../../../domain/login_usercase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  // final void Function(String token) onAuthenticated;

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
        final userLogged = await loginUseCase.execute(event.email, event.password);
        if (userLogged != null) {
          // await secureStorage.write(key: 'idToken', value: userLogged.idToken);
          // onAuthenticated(userLogged.idToken);
          emit(LoginSuccess(token:  userLogged.idToken));
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
