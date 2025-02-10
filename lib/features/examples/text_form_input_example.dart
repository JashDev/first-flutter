import 'package:flutter/material.dart';
import 'package:login_example/main.dart';

import '../shared/widgets/g66_amount_input.dart';
import '../shared/widgets/g66_material_text_form_field.dart';
import '../shared/widgets/g66_material_text_input.dart';
import '../shared/widgets/g66_selector_form_field.dart';
import '../shared/widgets/g66_material_button.dart';

class CurrencySettings {
  final String thousandSeparator;
  final String decimalSeparator;
  final int decimalPrecision;

  CurrencySettings({
    this.thousandSeparator = ',',
    this.decimalSeparator = '.',
    this.decimalPrecision = 2,
  });

  @override
  String toString() {
    return 'CurrencySettings(thousandSeparator: $thousandSeparator, decimalSeparator: $decimalSeparator, decimalPrecision: $decimalPrecision)';
  }
}

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final _formKey = GlobalKey<FormState>();
  String? _itemSelected;
  bool _isFormValid = false;

  double _amount = 1000.0;
  String _selectedCurrency = 'USD';

  CurrencySettings _currencySettings = CurrencySettings();

  CurrencySettings _getCurrencySettings(String currency) {
    switch (currency.toUpperCase()) {
      case 'CLP': // Peso Chileno
        return CurrencySettings(
          thousandSeparator: ',',
          decimalSeparator: '',
          decimalPrecision: 0,
        );
      case 'USD': // Dólar Estadounidense
        return CurrencySettings(
          thousandSeparator: ',',
          decimalSeparator: '.',
          decimalPrecision: 2,
        );
      case 'EUR': // Euro
        return CurrencySettings(
          thousandSeparator: '.',
          decimalSeparator: ',',
          decimalPrecision: 2,
        );
      case 'MXN': // Peso Mexicano
        return CurrencySettings(
          thousandSeparator: ',',
          decimalSeparator: '.',
          decimalPrecision: 2,
        );
      case 'PEN': // Sol Peruano
        return CurrencySettings(
          thousandSeparator: '.',
          decimalSeparator: ',',
          decimalPrecision: 2,
        );
      default: // Configuración por defecto
        return CurrencySettings(
          thousandSeparator: ',',
          decimalSeparator: '.',
          decimalPrecision: 2,
        );
    }
  }

  final List<CurrencyItem> _currencies = [
    CurrencyItem('USD', 'Dólar estadounidense', 1500.75, 'assets/flags/us.png'),
    CurrencyItem('EUR', 'Euro', 1200.00, 'assets/flags/eu.png'),
    CurrencyItem('CLP', 'Peso Chileno', 200000.00, 'assets/flags/jp.png'),
    CurrencyItem('PEN', 'Soles', 200000.00, 'assets/flags/jp.png'),
  ];

  void _handleAmountChange(double amount) {
    setState(() {
      _amount = amount;
    });
  }

  void _handleCurrencyChange(String currencyCode) {
    setState(() {
      _selectedCurrency = currencyCode;
      _currencySettings = _getCurrencySettings(currencyCode);
      logger.debug('hanlde $_currencySettings');
    });
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Enviado: $_amount $_selectedCurrency')),
    );
  }

  String? _email;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      logger.debug("Formulario válido");
    } else {
      logger.debug("Formulario con errores");
    }
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            G66MaterialTextFormField(
              label: 'Correo Electrónico',
              placeholder: 'Ingresa tu correo',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                if (value.length != 8) {
                  return 'Este campo debe tener 8';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Correo no válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            G66MaterialTextInput(
              label: "Username",
              validateOnType: true,
              placeholder: "Enter your username",
              customValidators: [
                (value) async {
                  await Future.delayed(const Duration(
                      seconds: 1)); // Simulación de llamada a API
                  if (value == "jash") {
                    return CustomValidatorResponse(
                        status: ValidationStatus.error,
                        message: 'Username en uso');
                  }
                  return CustomValidatorResponse(
                      status: ValidationStatus.success,
                      message: 'Username oki');
                  // return null;
                },
              ],
              onChanged: (value) {
                logger.debug('username $value');
              },
              onValidated: (isValid) {
                setState(() {
                  _isFormValid = isValid;
                });
              },
            ),
            const SizedBox(height: 20),
            G66SelectorFormField<String>(
              normalDecoration: G66SelectorDecorationType.basic.decoration,
              items: ['USD', 'PEN'],
              initialValue: _itemSelected,
              validator: (value) {
                if (value == null) {
                  return 'Debe seleccionar';
                }
                return null;
              },
              onChanged: (item) {
                logger.debug('item selected $item');
                setState(() {
                  _itemSelected = item;
                });
              },
              title: 'Selecciona un item',
              itemBuilder: (item) => Text('item $item'),
              iconBuilder: (item) => Text('item $item'),
            ),
            const SizedBox(height: 20),
            // G66AmountInput(
            //   labelText: 'Tu envias',
            //   decimalPrecision: _currencySettings.decimalPrecision,
            //   decimalSeparator: _currencySettings.decimalSeparator,
            //   thousandSeparator: _currencySettings.thousandSeparator,
            //   showCurrencySelector: true,
            //   availableCurrencies: _currencies,
            //   initialCurrency: _selectedCurrency,
            //   initialValue: _amount,
            //   onCleanValueChanged: _handleAmountChange,
            //   onCurrencyChanged: _handleCurrencyChange,
            // ),
            const SizedBox(height: 20),
            G66MaterialButton(
              text: 'Enviar',
              onPressed: _isFormValid ? _submitForm : null,
              isEnabled: _isFormValid,
              fullWidth: true,
              type: ButtonType.outline,
            ),
          ],
        ),
      ),
    );
  }
}
