import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:login_example/features/auth/presentation/login_bloc.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/domain/login_usercase.dart';

GetIt getIt = GetIt.instance;

void serviceLocatorInit() {
  getIt.registerSingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>());
  getIt.registerSingleton(LoginBloc(loginUseCase: LoginUseCase(AuthRepository())));
}