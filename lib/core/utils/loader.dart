import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
      debugPrint('Error: No Overlay widget found.');
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (_) => Container(
        color: Colors.black.withAlpha(125),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
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
