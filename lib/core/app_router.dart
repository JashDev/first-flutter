import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:login_example/core/router/go_router_refresh_stream.dart';
import 'package:login_example/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:login_example/features/examples/presentation/exchange_view.dart';
import 'package:login_example/features/examples/presentation/form_example_screen.dart';

import '../features/auth/presentation/blocs/auth/auth_state.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/pin_screen.dart';
import '../features/splash/splash_screen.dart';
import 'config/service_locator.dart';

final GlobalKey<NavigatorState> navigatorKey =
    getIt<GlobalKey<NavigatorState>>();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/splash',
  refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => FormExampleScreen(),
    ),
    GoRoute(
      path: '/exchange',
      name: 'exchange',
      builder: (context, state) => ExchangeView(),
    ),

    GoRoute(
      path: '/pin',
      name: 'pin',
      builder: (context, state) => PinScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Ruta no encontrada', style: TextStyle(fontSize: 20)),
    ),
  ),
  redirect: (context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    final bool isLoggedIn = authState is AuthAuthenticated;
    final isGoingToLogin = state.fullPath == '/login';
    print('ejecutar redirect logged => $isLoggedIn ---- $isGoingToLogin ${state.fullPath} => ${state.name}');

    if (!isLoggedIn && !isGoingToLogin && state.fullPath != '/splash') {
      return '/login';
    }

    if (isLoggedIn && isGoingToLogin) {
      return '/pin';
    }

    return null;
  },
);
