import 'package:flutter/material.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    stream.asBroadcastStream().listen((_) {
      print('notifiy router======>');
      notifyListeners();
    });
  }
}