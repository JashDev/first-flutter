import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:login_example/core/widgets/lottie_view.dart';
import 'package:login_example/main.dart';

class Loader {
  static final Loader _instance = Loader._internal();

  factory Loader() => _instance;

  late OverlayEntry _overlayEntry;
  bool _isVisible = false;

  Loader._internal();

  void show() {
    if (_isVisible) return;

    final navigatorKey = GetIt.instance<GlobalKey<NavigatorState>>();
    final overlayState = navigatorKey.currentState?.overlay;

    if (overlayState == null) {
      logger.error('Error: No Overlay widget found.');
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (_) => Container(
          color: Colors.black.withAlpha(125),
          child: LottieView(lottiePath: 'assets/lottie/preloader_white.json')),
    );

    overlayState.insert(_overlayEntry);
    _isVisible = true;
  }

  void hide() {
    if (!_isVisible) return;

    _overlayEntry.remove();
    _isVisible = false;
  }
}
