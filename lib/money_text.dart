import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:login_example/main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Formato de Moneda')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: CurrencyInputExample(),
        ),
      ),
    );
  }
}

class CurrencyInputExample extends StatefulWidget {
  const CurrencyInputExample({super.key});

  @override
  _CurrencyInputExampleState createState() => _CurrencyInputExampleState();
}

class _CurrencyInputExampleState extends State<CurrencyInputExample> {
  final TextEditingController _controller = TextEditingController();
  String selectedLocale = 'en_US'; // Locale por defecto
  CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter.currency();

  @override
  void initState() {
    super.initState();
    _formatter = CurrencyTextInputFormatter.currency(
      locale: selectedLocale, // Cambia el locale aquí
      decimalDigits:
          _getDecimalPresicion(selectedLocale), // Número de decimales
      symbol: _getCurrencySymbol(selectedLocale), // Símbolo de moneda
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Campo de texto con formateo de moneda
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          inputFormatters: [_formatter],
          decoration: const InputDecoration(
            labelText: 'Ingrese un monto',
            hintText: 'Ej: \$10,000.34',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),

        // Botón para obtener el valor limpio (sin formato)
        ElevatedButton(
          onPressed: () {
            logger.debug(_formatter.getFormattedValue()); // $ 2,000
            logger
                .debug(_formatter.getUnformattedValue().toString()); // 2000.00
            logger.debug(_formatter.format.toString()); // $ 2,000
            logger.debug(_formatter.formatDouble(20.00)); // $ 20

            // String rawValue = _controller.text.replaceAll(RegExp(r'[^0-9.]'), '');
            // double? numericValue = double.tryParse(rawValue) ?? 0.0;
            // print('Valor sin formato: $numericValue');
          },
          child: const Text('Obtener Valor Numérico'),
        ),
        const SizedBox(height: 20),

        // Dropdown para cambiar el locale
        DropdownButton<String>(
          value: selectedLocale,
          onChanged: (String? newLocale) {
            setState(() {
              selectedLocale = newLocale!;
              _formatter = CurrencyTextInputFormatter.currency(
                  locale: selectedLocale, // Cambia el locale aquí
                  decimalDigits: _getDecimalPresicion(
                      selectedLocale), // Número de decimales
                  symbol:
                      _getCurrencySymbol(selectedLocale), // Símbolo de moneda
                  name: '\$');
              _controller.clear(); // Limpia el campo al cambiar de formato
            });
          },
          items: <String>['en_US', 'es_ES', 'es_AR', 'pt_BR', 'es_CL', 'es_PE']
              .map<DropdownMenuItem<String>>((String locale) {
            return DropdownMenuItem<String>(
              value: locale,
              child: Text('Formato: $locale'),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Obtener el símbolo de moneda según el locale seleccionado
  String _getCurrencySymbol(String locale) {
    switch (locale) {
      case 'es_ES':
        return '€';
      case 'es_AR':
        return '\$';
      case 'es_CL':
        return '\$';
      // case 'es_PE':
      // return 'S/';
      case 'pt_BR':
        return 'R\$';
      case 'en_US':
      default:
        return '\$'; // Dólar estadounidense
    }
  }

  int _getDecimalPresicion(String locale) {
    switch (locale) {
      case 'es_ES':
        return 2;
      case 'es_AR':
        return 2;
      case 'es_CL':
        return 0;
      case 'es_PE':
        return 2;
      case 'pt_BR':
        return 2;
      case 'en_US':
        return 2;
      default:
        return 2; // Dólar estadounidense
    }
  }
}
