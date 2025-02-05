import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_example/features/shared/widgets/g66_material_button.dart';
import '../../shared/widgets/g66_material_text_input.dart';
import '../data/auth_repository.dart';
import '../domain/login_usercase.dart';
import 'login_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(loginUseCase: LoginUseCase(AuthRepository())),
      child: Scaffold(
        appBar: AppBar(title: const Text('Iniciar Sesión')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  String _email = '';
  String _password = '';
  bool _isFormValid = false;

  void _validateForm(isValid) {
    setState(() {
      _isFormValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de Correo Electrónico
            G66MaterialTextInput(
              label: 'Correo Electrónico',
              placeholder: 'Introduce tu correo',
              required: true,
              validateOnType: true,
              customValidators: [
                (value) async {
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return CustomValidatorResponse(status: ValidationStatus.error, message: 'Correo invalido');
                  }
                  return null;
                },
              ],
              onChanged: (value) {
                _email = value;
              },
              onValidated: (value) {
                _validateForm(value);
              },
            ),
            const SizedBox(height: 16),

            // Campo de Contraseña
            G66MaterialTextInput(
              label: 'Contraseña',
              placeholder: 'Introduce tu contraseña',
              rightIcon: Icons.visibility_off,
              secure: true,
              required: true,
              validateOnType: true,
              customValidators: [
                (value) async {
                  if (value.length < 6) {
                    return CustomValidatorResponse(status: ValidationStatus.error, message: 'La contraseña debe tener al menos 6 caracteres');
                  }
                  return null;
                },
              ],
              onChanged: (value) {
                _password = value;
              },
              onValidated: (value) {
                _validateForm(value);
              },
            ),
            const SizedBox(height: 24),

            // Botón de Iniciar Sesión
            G66MaterialButton(
              text: 'Iniciar Sesión',
              isEnabled: _isFormValid,
              isLoading: state is LoginLoading,
              onPressed: () {
                print('email $_email, password $_password');
                if (!_isFormValid) return;
                context.read<LoginBloc>().add(
                      LoginButtonPressed(
                        email: _email,
                        password: _password,
                      ),
                    );
              },
              fullWidth: true,
            )
          ],
        );
      }),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('¡Bienvenido a la aplicación!'),
      ),
    );
  }
}
