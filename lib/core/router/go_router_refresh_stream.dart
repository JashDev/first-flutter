import 'package:flutter/material.dart';
import 'package:login_example/main.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    stream.asBroadcastStream().listen((_) {
      logger.debug('notifiy router======>');
      notifyListeners();
    });
  }
}
