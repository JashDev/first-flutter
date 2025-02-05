import 'package:flutter/material.dart';
import 'package:login_example/features/examples/text_form_input_example.dart';

class FormExampleScreen extends StatelessWidget {
  const FormExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: FormExample(),
      ),
    );
  }
}
