import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/blocs/auth/auth_bloc.dart';
import '../../features/auth/presentation/blocs/auth/auth_state.dart';

class AppLifecycleHandler with WidgetsBindingObserver {

  // final GlobalKey<NavigatorState> navigatorKey = getIt<GlobalKey<NavigatorState>>();
  final BuildContext context;
  DateTime? _backgroundTimestamp;
  String? _lastRoute;
  Timer? _timer;

  AppLifecycleHandler(this.context);

  void startObserving() {
    WidgetsBinding.instance.addObserver(this);
  }

  void stopObserving() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _onAppSuspended();
    } else if (state == AppLifecycleState.resumed) {
      _onAppResumed();
    }
  }

  void _onAppSuspended() {
    _backgroundTimestamp = DateTime.now();
    _lastRoute = GoRouter.of(context).routeInformationProvider.value.location;
    print('last ROute $_lastRoute');
    _startSuspensionTimer();
  }

  void _onAppResumed() {
    final now = DateTime.now();
    if (_backgroundTimestamp != null) {
      final duration = now.difference(_backgroundTimestamp!);
      if (duration.inSeconds >= 5) {
        _handleResumeLogic();
      }
    }
    _timer?.cancel();
  }

  void _startSuspensionTimer() {
    _timer = Timer(const Duration(minutes: 1), () {
      // Si la app sigue suspendida después de 1 minuto
      print('La app ha estado suspendida por más de un minuto.');
    });
  }

  void _handleResumeLogic() {
    final authState = BlocProvider.of<AuthBloc>(context).state;

    if (authState is AuthAuthenticated) {
      _navigateToPinScreen();  // Si está autenticado, mostrar la pantalla de PIN
    } else {
      print('Usuario no autenticado, no se mostrará la pantalla de PIN.');
    }
  }

  void _navigateToPinScreen() {
    context.push('/pin', extra: {'returnRoute': _lastRoute});
  }
}