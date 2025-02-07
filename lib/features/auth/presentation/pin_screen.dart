import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PinScreen extends StatelessWidget {
  final TextEditingController _pinController = TextEditingController();

  PinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(title: const Text('Ingrese su PIN')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _pinController,
                decoration: const InputDecoration(labelText: 'PIN'),
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_pinController.text == '1234') {
                    // Si hay una ruta guardada, volver a ella
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(
                          '/home'); // Por defecto, volver a home si no hay ruta guardada
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PIN incorrecto')),
                    );
                  }
                },
                child: const Text('Desbloquear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
