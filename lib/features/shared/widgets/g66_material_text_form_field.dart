import 'package:flutter/material.dart';

class G66MaterialTextFormField extends FormField<String> {
  final String label;
  final String? placeholder;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final bool secure;
  final bool multiline;
  final int maxLines;
  final bool allowClear;
  final TextInputType keyboardType;

  final Color? focusBorderColor;
  final Color errorBorderColor;
  final Color normalBorderColor;

  final Function(String)? onChanged;
  final Function()? onLeftIconTap;
  final Function()? onRightIconTap;

  G66MaterialTextFormField({
    super.key,
    this.label = '',
    this.placeholder,
    this.leftIcon,
    this.rightIcon,
    this.secure = false,
    this.multiline = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.allowClear = false,
    this.focusBorderColor,
    this.errorBorderColor = Colors.red,
    this.normalBorderColor = const Color(0xFFCCCCCC),

    // FormField Props
    super.initialValue,
    super.validator,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onLeftIconTap,
    this.onRightIconTap,
  }) : super(
          builder: (FormFieldState<String> state) {
            return _G66MaterialTextFormFieldContent(
              fieldState: state,
              label: label,
              placeholder: placeholder,
              leftIcon: leftIcon,
              rightIcon: rightIcon,
              secure: secure,
              multiline: multiline,
              maxLines: maxLines,
              keyboardType: keyboardType,
              allowClear: allowClear,
              focusBorderColor: focusBorderColor,
              errorBorderColor: errorBorderColor,
              normalBorderColor: normalBorderColor,
              onChanged: onChanged,
              onLeftIconTap: onLeftIconTap,
              onRightIconTap: onRightIconTap,
            );
          },
        );
}

class _G66MaterialTextFormFieldContent extends StatefulWidget {
  final FormFieldState<String> fieldState;
  final String label;
  final String? placeholder;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final bool secure;
  final bool multiline;
  final int maxLines;
  final TextInputType keyboardType;
  final bool allowClear;

  final Color? focusBorderColor;
  final Color errorBorderColor;
  final Color normalBorderColor;

  final Function(String)? onChanged;
  final Function()? onLeftIconTap;
  final Function()? onRightIconTap;

  const _G66MaterialTextFormFieldContent({
    required this.fieldState,
    required this.label,
    this.placeholder,
    this.leftIcon,
    this.rightIcon,
    this.secure = false,
    this.multiline = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.allowClear = false,
    this.focusBorderColor,
    this.errorBorderColor = Colors.red,
    this.normalBorderColor = const Color(0xFFCCCCCC),
    this.onChanged,
    this.onLeftIconTap,
    this.onRightIconTap,
  });

  @override
  State<_G66MaterialTextFormFieldContent> createState() =>
      __G66MaterialTextFormFieldContentState();
}

class __G66MaterialTextFormFieldContentState
    extends State<_G66MaterialTextFormFieldContent> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.secure;
    _controller = TextEditingController(text: widget.fieldState.value);
    _focusNode = FocusNode();

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (!_isFocused) {
      widget.fieldState.validate(); // Valida al perder el foco
    } else {
      widget.fieldState.reset();
    }
  }

  void _clearText() {
    _controller.clear();
    widget.fieldState.didChange(''); // Actualiza el estado del formulario
    widget.onChanged?.call('');
  }

  void _toggleSecureVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final focusBorderColorCalculated =
        widget.focusBorderColor ?? Theme.of(context).primaryColor;
    final hasError = widget.fieldState.hasError;
    final mainColor = hasError
        ? widget.errorBorderColor
        : _isFocused
            ? focusBorderColorCalculated
            : widget.normalBorderColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: mainColor, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (widget.leftIcon != null)
                GestureDetector(
                  onTap: widget.onLeftIconTap,
                  child: Icon(widget.leftIcon, color: Colors.grey),
                ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  obscureText: _obscureText,
                  maxLines: widget.multiline ? widget.maxLines : 1,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: TextStyle(
                        color: hasError
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).primaryColor),
                    border: InputBorder.none,
                    labelText: widget.label,
                    labelStyle: TextStyle(
                        color: hasError
                            ? Theme.of(context).colorScheme.error
                            : mainColor),
                  ),
                  keyboardType: widget.keyboardType,
                  onChanged: (value) {
                    widget.fieldState.didChange(value);
                    widget.onChanged?.call(value);
                  },
                ),
              ),
              if (widget.secure)
                GestureDetector(
                  onTap: _toggleSecureVisibility,
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                ),
              if (widget.allowClear && _controller.text.isNotEmpty)
                GestureDetector(
                  onTap: _clearText,
                  child: const Icon(Icons.clear, color: Colors.grey),
                ),
              if (widget.rightIcon != null)
                GestureDetector(
                  onTap: widget.onRightIconTap,
                  child: Icon(widget.rightIcon, color: Colors.grey),
                ),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              widget.fieldState.errorText ?? '',
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
