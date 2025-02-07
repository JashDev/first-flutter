import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExchangeView extends StatelessWidget {
  ExchangeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exchange')),
      floatingActionButton: FloatingActionButton(onPressed: () {
        if (context.canPop()) {
          context.pop();
        }
      }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('home');
                }
              },
              child: const Text('Desbloquear'),
            ),
          ],
        ),
      ),
    );
  }
}