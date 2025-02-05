import 'package:flutter/material.dart';
import 'core/app_router.dart';
import 'core/config/environment_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await EnvironmentConfig.loadEnv();
    debugPrint(
        'Archivo .env.${EnvironmentConfig.currentEnv} cargado correctamente.');
  } catch (e) {
    debugPrint('Error al cargar el archivo .env: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
