import 'package:flutter/material.dart';
import 'package:login_example/main.dart';

import '../shared/widgets/g66_material_text_input.dart';

class TextInputExample extends StatefulWidget {
  const TextInputExample({super.key});

  @override
  State<TextInputExample> createState() => _TextInputExampleState();
}

class _TextInputExampleState extends State<TextInputExample> {
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        G66MaterialTextInput(
          label: 'Nombre de Usuario',
          placeholder: 'Introduce tu nombre',
          required: true,
          // allowClear: true,
          validateOnType: true,
          customValidators: [
            (value) async {
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
              if (!emailRegex.hasMatch(value)) {
                return CustomValidatorResponse(
                    status: ValidationStatus.error,
                    message: 'Introduce un correo valido');
              }
              return null;
            }
          ],
          onValidated: (isValid) {
            logger.debug('¿El nombre de usuario es válido? $isValid');
          },
          onChanged: (value) {
            setState(() {
              _name = value;
            });
          },
        ),
        const SizedBox(height: 20),
        G66MaterialTextInput(
          label: 'Contraseña',
          placeholder: 'Introduce tu contraseña',
          secure: true,
          // Campo de contraseña con opción de mostrar/ocultar
          required: true,
          // requiredErrorText: 'La contraseña no puede estar vacía',
          onValidated: (isValid) {
            logger.debug('¿La contraseña es válida? $isValid');
          },
        ),
        const SizedBox(height: 20),
        Text('Nombre: $_name')
      ],
    );
  }
}
