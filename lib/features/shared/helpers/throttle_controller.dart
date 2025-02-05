import 'dart:async';
import 'dart:ui';

class ThrottleController {
  final Duration duration;
  final VoidCallback action;
  bool _hasExecutedInitialAction = false;
  Timer? _debounceTimer;

  ThrottleController({
    required this.duration,
    required this.action,
  });

  void run() {
    if (!_hasExecutedInitialAction) {
      action();
      _hasExecutedInitialAction = true;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, () {
      _hasExecutedInitialAction = false;
    });
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}
