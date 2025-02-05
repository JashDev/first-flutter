import 'package:flutter/material.dart';

class G66SelectorFormField<T> extends FormField<T> {
  final List<T> items;
  final String title;
  final String placeholder;

  final BoxDecoration? normalDecoration; // Decoración para estado normal
  final BoxDecoration? inactiveDecoration; // Decoración para estado inactivo
  final BoxDecoration? errorDecoration; // Decoración para estado de error

  final Widget Function(T) itemBuilder;
  final Widget Function(T) iconBuilder;

  final ValueChanged<T>? onChanged;

  G66SelectorFormField({
    super.key,
    required this.items,
    required this.title,
    required this.itemBuilder,
    required this.iconBuilder,
    this.placeholder = "Selecciona item",
    this.normalDecoration, // Nueva decoración normal
    this.inactiveDecoration, // Nueva decoración inactiva
    this.errorDecoration, // Nueva decoración de error
    super.enabled = true,
    this.onChanged,
    super.onSaved,
    super.validator,
    super.initialValue,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) : super(
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<T> state) {
            final hasError = state.hasError;

            // Determinar qué decoración aplicar según el estado
            final BoxDecoration? currentDecoration = hasError
                ? errorDecoration ??
                    BoxDecoration(
                      border: Border.all(color: Colors.red, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    )
                : !enabled
                    ? inactiveDecoration ??
                        BoxDecoration(
                          color: Colors.grey.shade100,
                        )
                    : normalDecoration;

            return GestureDetector(
              onTap: enabled ? () => _openSelector(state.context, state) : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    decoration: currentDecoration,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: state.value != null
                              ? iconBuilder(state.value as T)
                              : Text(
                                  placeholder,
                                  style: TextStyle(
                                    color: enabled
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade400,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: enabled ? Colors.grey : Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                  if (hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                      child: Text(
                        state.errorText ?? '',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            );
          },
        );

  static void _openSelector<T>(BuildContext context, FormFieldState<T> state) {
    final field = (state.widget as G66SelectorFormField<T>);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _buildSelectorList(context, state, field);
      },
    );
  }

  static Widget _buildSelectorList<T>(
    BuildContext context,
    FormFieldState<T> state,
    G66SelectorFormField<T> field,
  ) {
    if (field.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            'No hay elementos disponibles.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            field.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: field.items.length,
            itemBuilder: (context, index) {
              final item = field.items[index];
              return ListTile(
                title: field.itemBuilder(item),
                onTap: () {
                  state.didChange(item);
                  field.onChanged?.call(item);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

enum G66SelectorDecorationType {
  basic,
}

extension DecorationTypeExtension on G66SelectorDecorationType {
  BoxDecoration get decoration {
    switch (this) {
      case G66SelectorDecorationType.basic:
        return BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        );
    }
  }
}
