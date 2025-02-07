import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:login_example/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:login_example/features/examples/text_form_input_example.dart';
import 'package:login_example/features/shared/widgets/g66_material_button.dart';

import '../../auth/presentation/blocs/auth/auth_event.dart';

class FormExampleScreen extends StatelessWidget {
  const FormExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: FormExample(),
          ),
          G66MaterialButton(text: 'Exchange', onPressed: () {
            context.push('/exchange');
          },)
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        context.read<AuthBloc>().add(LoggedOut());
      }),
    );
  }
}
