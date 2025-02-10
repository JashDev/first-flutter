import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:login_example/core/config/logger/app_logger.dart';
import 'package:login_example/core/config/service_locator.dart';
import 'package:login_example/core/theme/app_theme.dart';
import 'package:login_example/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:login_example/features/auth/presentation/blocs/login/login_bloc.dart';
import 'package:login_example/features/shared/presentation/blocs/theme/theme_cubit.dart';
import 'core/app_router.dart';
import 'core/config/app_lycicle_handler.dart';
import 'core/config/environment_config.dart';

var logger = AppLogger();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await EnvironmentConfig.loadEnv();
    logger.debug(
        'Archivo .env.${EnvironmentConfig.currentEnv} cargado correctamente.');
  } catch (e) {
    logger.error('Error al cargar el archivo .env: $e');
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
    initialization();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lifecycleHandler =
          AppLifecycleHandler(this.navigatorKey.currentContext!);
      _lifecycleHandler.startObserving();
    });
  }

  void initialization() async {
    logger.debug('pausing....');
    await Future.delayed(const Duration(seconds: 3));
    logger.debug('unpaussing...');
    FlutterNativeSplash.remove();
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
