import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_example/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:login_example/main.dart';

import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final String? token = await secureStorage.read(key: 'auth_token');

    if (token != null) {
      emit(AuthAuthenticated(token: token));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    try {
      await secureStorage.write(key: 'auth_token', value: event.token);
      logger.debug('on loggen in ${event.token}');
      emit(AuthAuthenticated(token: event.token));
    } catch (e) {
      logger.error(e.toString());
    }
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await secureStorage.delete(key: 'auth_token');
    emit(AuthUnauthenticated());
  }

  Stream<AuthState> get authStream => stream;

  void onAunthenticated(String token) {
    add(LoggedIn(token: token));
  }

  void onAppStarted() {
    add(AppStarted());
  }
}
