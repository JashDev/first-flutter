import 'package:logger/logger.dart';

class AppLogger {
  final Logger _logger;

  AppLogger._internal(this._logger);

  factory AppLogger() {
    return AppLogger._internal(Logger(
      printer: PrefixPrinter(PrettyPrinter(
          methodCount: 0, errorMethodCount: 8, lineLength: 120, colors: true, printEmojis: true, printTime: true)),
      filter: DevelopmentFilter(),
    ));
  }

  void trace(String message) => _logger.t(' $message');
  void debug(String message) => _logger.d(message);
  void info(String message) => _logger.i(message);
  void warning(String message) => _logger.w(message);
  void error(String message) => _logger.e(message);
  void fatal(String message) => _logger.f(message);
}
