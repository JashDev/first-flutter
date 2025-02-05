import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:equatable/equatable.dart';

import 'g66_selector_form_field.dart';

class G66AmountInput extends StatefulWidget {
  final String decimalSeparator;
  final String thousandSeparator;
  final int decimalPrecision;
  final String? labelText;
  final String? errorText;
  final String rightSymbol;
  final String leftSymbol;
  final double? initialValue;

  final bool showCurrencySelector;
  final List<CurrencyItem>? availableCurrencies;
  final String? initialCurrency;
  final Function(String)? onCurrencyChanged;

  final Function(String)? onChanged;
  final Function(double)? onCleanValueChanged;

  const G66AmountInput({
    super.key,
    this.decimalSeparator = '.',
    this.thousandSeparator = ',',
    this.decimalPrecision = 2,
    this.labelText,
    this.errorText,
    this.onChanged,
    this.onCleanValueChanged,
    this.rightSymbol = '',
    this.leftSymbol = '',
    this.initialValue,
    this.showCurrencySelector = false,
    this.availableCurrencies,
    this.initialCurrency,
    this.onCurrencyChanged,
  });

  @override
  State<G66AmountInput> createState() => _G66AmountInputState();
}

class _G66AmountInputState extends State<G66AmountInput> {
  late MoneyMaskedTextController _controller;
  late CurrencyItem _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _initializeController();

    if (widget.showCurrencySelector &&
        (widget.availableCurrencies == null ||
            widget.availableCurrencies!.isEmpty)) {
      throw FlutterError(
          'Se requiere una lista de monedas si showCurrencySelector está habilitado.');
    }

    _selectedCurrency = widget.availableCurrencies?.firstWhere(
          (currency) => currency.code == widget.initialCurrency,
          orElse: () =>
              widget.availableCurrencies?.first ??
              const CurrencyItem(
                  'USD', 'Dólar estadounidense', 0.0, 'assets/flags/us.png'),
        ) ??
        const CurrencyItem(
            'USD', 'Dólar estadounidense', 0.0, 'assets/flags/us.png');
  }

  void _initializeController() {
    _controller = MoneyMaskedTextController(
      decimalSeparator:
          widget.decimalPrecision == 0 ? '' : widget.decimalSeparator,
      thousandSeparator: widget.thousandSeparator,
      precision: widget.decimalPrecision,
      leftSymbol: widget.leftSymbol,
      rightSymbol: widget.rightSymbol,
      initialValue: widget.initialValue ?? 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant G66AmountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFlag(String assetPath) {
    return Image.asset(
      assetPath,
      width: 24,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.public, size: 24, color: Colors.grey);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Text(widget.labelText!,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              flex: widget.showCurrencySelector ? 3 : 4,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  errorText: widget.errorText,
                ),
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  widget.onCleanValueChanged?.call(_controller.numberValue);
                },
              ),
            ),
            const SizedBox(width: 10),
            if (widget.showCurrencySelector &&
                widget.availableCurrencies != null)
              Expanded(
                flex: 2,
                child: G66SelectorFormField<CurrencyItem>(
                  items: widget.availableCurrencies!,
                  initialValue: _selectedCurrency,
                  title: 'Selecciona la moneda',
                  iconBuilder: (currency) => Row(
                    children: [
                      _buildFlag(currency.flagAsset),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(currency.code,
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  itemBuilder: (currency) => Row(
                    children: [
                      _buildFlag(currency.flagAsset),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${currency.code} • ${currency.name}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(
                                'Disponible: ${currency.available.toStringAsFixed(2)} ${currency.code}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onChanged: (currency) {
                    setState(() {
                      _selectedCurrency = currency;
                    });
                    widget.onCurrencyChanged?.call(currency.code);
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class CurrencyItem extends Equatable {
  final String code;
  final String name;
  final double available;
  final String flagAsset;

  const CurrencyItem(this.code, this.name, this.available, this.flagAsset);

  @override
  List<Object?> get props => [code, name, available, flagAsset];

  @override
  String toString() {
    return "$code - $name";
  }
}
