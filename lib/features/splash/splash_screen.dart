import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_example/core/theme/color_scheme.dart';
import 'package:login_example/main.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    logger.debug('Init splash screen');
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToLogin();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Liberar recursos
    super.dispose();
  }

  void _navigateToLogin() async {
    // await Future.delayed(const Duration(seconds: 3)); // Simula la carga
    if (mounted) {
      context.goNamed('login');
      logger.debug('go to login after 3 seconds');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: LottieBuilder.asset(
          backgroundLoading: true,
          'assets/images/splash_screen/animation_splash.json', // Animación Lottie
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          controller: _controller,
          onLoaded: (composition) {
            logger.debug("Animación cargada y lista.");
            _controller.duration =
                composition.duration; // Configurar la duración de la animación
            logger.debug('duracion de la animacion: ${composition.duration}');
            _controller.forward();
          },
        ),
      ),
    );
  }
}
