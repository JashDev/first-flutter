import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  static Future<void> loadEnv() async {
    const String env = String.fromEnvironment('FLAVOR', defaultValue: 'ci');
    await dotenv.load(fileName: '.env.$env');
  }

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://default.api.com';

  static String get strapiBaseUrl =>
      dotenv.env['STRAPI_BASE_URL'] ?? 'https://default.strapi.com';

  static int get maxRequestRetries =>
      int.tryParse(dotenv.env['MAX_REQUEST_RETRIES'] ?? '3') ?? 3;

  static String get currentEnv => dotenv.env['APP_ENV'] ?? 'development';
}
