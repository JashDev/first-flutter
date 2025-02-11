import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:login_example/features/auth/presentation/blocs/login/login_bloc.dart';
import 'package:login_example/features/shared/widgets/g66_material_button.dart';
import 'package:login_example/features/shared/widgets/g66_material_text_form_field.dart';
import 'package:login_example/main.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/login/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isFormValid = false;

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.watch<LoginBloc>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.read<AuthBloc>().add(LoggedIn(token: state.token));
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login Fallido: ${state.error}')),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Color(0xFF6A6FBA)),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Image.asset('assets/images/logo_circle.png'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '¡Te damos la bienvenida a Global66!',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          G66MaterialTextFormField(
                            label: 'Email',
                            initialValue: _email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              final RegExp emailRegex = RegExp(
                                r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              return emailRegex.hasMatch(value)
                                  ? null
                                  : 'El email no es válido';
                            },
                            onChanged: (value) {
                              _validateForm();
                              setState(() {
                                _email = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          G66MaterialTextFormField(
                              label: 'Contraseña',
                              secure: true,
                              initialValue: _password,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Este campo es obligatorio';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _validateForm();
                                setState(() {
                                  _password = value;
                                });
                              }),
                        ],
                      )),
                  const SizedBox(height: 30),
                  G66MaterialButton(
                    text: 'Iniciar Sesión',
                    fullWidth: true,
                    isEnabled: _isFormValid,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      loginBloc.login(email: _email, password: _password);
                    },
                  ),
                  // BlocBuilder<LoginBloc, LoginState>(
                  //   builder: (context, state) {
                  //     // if (state is LoginSuccess) {
                  //     //   context.goNamed('home');
                  //     // }
                  //     return   G66MaterialButton(
                  //       text: 'Iniciar Sesión',
                  //       fullWidth: true,
                  //       isEnabled: _isFormValid,
                  //       onPressed: () {
                  //         FocusScope.of(context).unfocus();
                  //         loginBloc.login(email: _email, password: _password);
                  //       },
                  //     );
                  //   },
                  // ),

                  const SizedBox(height: 20),
                  const Text(
                    'O CONTINUAR CON',
                    style: TextStyle(
                        color: Color(0xFF4A4E69),
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _socialButton(Icons.facebook, Colors.blue),
                      _socialButton(Icons.g_mobiledata, Colors.red),
                      _socialButton(Icons.apple, Colors.black),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(' ¿Aún no tienes cuenta?',
                          style: TextStyle(
                              color: Color(0xFF4A4E69), fontSize: 11)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          logger.debug('ir a crear cueta');
                        },
                        child: Text('Crear cuenta',
                            style: TextStyle(
                                color: Color(0xFF2746C7),
                                fontWeight: FontWeight.bold,
                                fontSize: 11)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('¿Olvidaste tu contraseña?',
                          style: TextStyle(
                              color: Color(0xFF4A4E69), fontSize: 11)),
                      SizedBox(width: 8),
                      Text('Recuperar contraseña',
                          style: TextStyle(
                              color: Color(0xFF2746C7),
                              fontWeight: FontWeight.bold,
                              fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 30),
    );
  }
}
