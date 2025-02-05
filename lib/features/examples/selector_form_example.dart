import 'package:flutter/material.dart';

import '../shared/widgets/g66_selector_form_field.dart';


class SelectorFormExample extends StatefulWidget {
  const SelectorFormExample({super.key});

  @override
  State<SelectorFormExample> createState() => _SelectorFormExampleState();
}

class _SelectorFormExampleState extends State<SelectorFormExample> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedCurrency;
  bool _selectorEnabled = false;

  final List<String> _currencies = ['PEN', 'USD', 'EUR', 'MXN', 'CLP'];

  void _submitForm() {
    setState(() {
      _selectorEnabled = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Moneda seleccionada: $_selectedCurrency');
    } else {
      print('Por favor selecciona una moneda.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario con Selector')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              G66SelectorFormField<String>(
                normalDecoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                title: 'Selecciona una moneda',
                items: _currencies,
                placeholder: 'Elige tu moneda',
                initialValue: _selectedCurrency,
                itemBuilder: (item) => Text(item),
                iconBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 16)),
                // validator: (value) {
                //   if (value == null) {
                //     return 'Debes seleccionar una moneda';
                //   }
                //   return null;
                // },
                onChanged: (value) {
                  print('On change $value');
                  setState(() {
                    _selectedCurrency = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Enviar $_selectedCurrency'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
