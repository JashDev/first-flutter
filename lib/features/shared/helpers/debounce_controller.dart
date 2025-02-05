import 'dart:async';
import 'dart:ui';

class DebounceController {
  final Duration duration;
  final VoidCallback action;

  Timer? _debounceTimer;

  DebounceController({
    required this.duration,
    required this.action,
  });

  void run() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, action);
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}
