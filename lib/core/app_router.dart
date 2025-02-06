import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_example/features/examples/presentation/form_example_screen.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/splash/splash_screen.dart';
import 'config/service_locator.dart';

bool isLoggedIn = false;

final GlobalKey<NavigatorState> navigatorKey =
    getIt<GlobalKey<NavigatorState>>();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/splash',
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
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Ruta no encontrada', style: TextStyle(fontSize: 20)),
    ),
  ),
  redirect: (context, GoRouterState state) {
    final isGoingToLogin = state.fullPath == '/login';
    print('ejecutar redirect $isGoingToLogin ${state.fullPath} => ${state.name}');

    if (!isLoggedIn && !isGoingToLogin) {
      return '/login';
    }

    if (isLoggedIn && isGoingToLogin) {
      return '/home';
    }

    return null;
  },
);
