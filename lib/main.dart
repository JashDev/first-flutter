import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_example/core/config/service_locator.dart';
import 'package:login_example/core/theme/app_theme.dart';
import 'package:login_example/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:login_example/features/auth/presentation/blocs/login/login_bloc.dart';
import 'package:login_example/features/shared/presentation/blocs/theme/theme_cubit.dart';
import 'core/app_router.dart';
import 'core/config/app_lycicle_handler.dart';
import 'core/config/environment_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await EnvironmentConfig.loadEnv();
    log('Archivo .env.${EnvironmentConfig.currentEnv} cargado correctamente.');
  } catch (e) {
    debugPrint('Error al cargar el archivo .env: $e');
  }
  serviceLocatorInit();
  runApp(const BlocProviders());
}

class BlocProviders extends StatelessWidget {
  const BlocProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => getIt<AuthBloc>()),
      BlocProvider(create: (context) => getIt<LoginBloc>()),
      BlocProvider(create: (context) => getIt<ThemeCubit>()),
    ], child: MyApp());
  }
}

class MyApp extends StatefulWidget {

  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  late AppLifecycleHandler _lifecycleHandler;
  final navigatorKey = getIt<GlobalKey<NavigatorState>>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lifecycleHandler = AppLifecycleHandler(this.navigatorKey.currentContext!);
      _lifecycleHandler.startObserving();
    });
  }

  @override
  void dispose() {
    _lifecycleHandler.stopObserving();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Global66',
      themeMode: themeCubit.state == ThemeModeState.light
          ? ThemeMode.light
          : ThemeMode.dark,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
