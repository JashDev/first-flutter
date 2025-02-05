import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ValidationStatus { success, error }

class CustomValidatorResponse {
  final ValidationStatus status;
  final String message;

  CustomValidatorResponse({required this.status, required this.message});

  bool get isSuccess => status == ValidationStatus.success;

  bool get isError => status == ValidationStatus.error;
}

class G66MaterialTextInput extends StatefulWidget {
  final String label;
  final String? placeholder;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final bool secure;
  final bool multiline;
  final int maxLines;
  final bool required;
  final String? requiredErrorText;
  final bool validateOnType;
  final bool validateOnBlur;
  final Duration debounceDuration;
  final int? length;
  final int? minLength;
  final int? maxLength;

  final String lengthError;
  final String minLengthError;
  final String maxLengthError;

  final List<Future<CustomValidatorResponse?> Function(String)>?
      customValidators;

  final TextInputType keyboardType;
  final bool enabled;
  final bool allowClear;

  final Color focusBorderColor;
  final Color errorBorderColor;
  final Color successBorderColor;
  final Color normalBorderColor;

  final Function(String)? onChanged;
  final Function(bool)? onValidated;
  final Function()? onLeftIconTap;
  final Function()? onRightIconTap;

  const G66MaterialTextInput({
    super.key,
    this.label = '',
    this.placeholder,
    this.leftIcon,
    this.rightIcon,
    this.secure = false,
    this.multiline = false,
    this.maxLines = 1,
    this.required = false,
    this.requiredErrorText,
    this.onChanged,
    this.onValidated,
    this.validateOnType = false,
    this.validateOnBlur = true,
    this.debounceDuration = const Duration(milliseconds: 800),
    this.customValidators,
    this.onLeftIconTap,
    this.onRightIconTap,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.allowClear = false,
    this.focusBorderColor = Colors.blue,
    this.errorBorderColor = Colors.red,
    this.successBorderColor = Colors.green,
    this.normalBorderColor = const Color(0xFFCCCCCC),
    this.minLength,
    this.maxLength,
    this.length,
    this.lengthError = 'Este campo debe contener exactamente {} carácteres',
    this.minLengthError =
        'Este campo debe contener como mínimo exactamente {} carácteres',
    this.maxLengthError =
        'Este campo debe contener como máximo exactamente {} carácteres',
  });

  @override
  State<G66MaterialTextInput> createState() => _MaterialTextInputState();
}

class _MaterialTextInputState extends State<G66MaterialTextInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  String? _errorText;
  String? _successMessage;
  bool _isFocused = false;
  bool _obscureText = false;
  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.secure;

    _focusNode.addListener(_handleFocusChange);

    if (widget.validateOnType) {
      _controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (!_isFocused && widget.validateOnBlur) {
      _validateInput(_controller.text);
    }

    if (_isFocused) {
      setState(() {
        _errorText = null;
      });
    }
  }

  void _onTextChanged() {
    widget.onValidated?.call(false);
    if (_errorText == null && _controller.text.isEmpty) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      _validateInput(_controller.text);
    });

    widget.onChanged?.call(_controller.text);
  }

  Future<void> _validateInput(String value) async {
    setState(() {
      _errorText = null;
      _isValidating = true;
      _successMessage = null;
    });

    if (widget.required && value.isEmpty) {
      setState(() {
        _errorText = widget.requiredErrorText ?? 'Este campo es obligatorio';
        _isValidating = false;
        _successMessage = null;
      });
      widget.onValidated?.call(false);
      return;
    }

    if (!widget.required && value.isEmpty) {
      setState(() {
        _isValidating = false;
        _successMessage = null;
      });
      return;
    }

    if (widget.length != null && value.length != (widget.length)) {
      setState(() {
        _errorText =
            widget.lengthError.replaceFirst('{}', widget.length.toString());
        _isValidating = false;
        _successMessage = null;
      });
      widget.onValidated?.call(false);
      return;
    }

    if (widget.minLength != null && value.length < (widget.minLength ?? 0)) {
      setState(() {
        _errorText = widget.minLengthError
            .replaceFirst('{}', widget.minLength.toString());
        _isValidating = false;
        _successMessage = null;
      });
      widget.onValidated?.call(false);
      return;
    }

    if (widget.maxLength != null &&
        value.length > (widget.maxLength ?? double.infinity)) {
      setState(() {
        _errorText = widget.maxLengthError
            .replaceFirst('{}', widget.maxLength.toString());
        _successMessage = null;
        _isValidating = false;
      });
      widget.onValidated?.call(false);
      return;
    }

    if (widget.customValidators != null &&
        widget.customValidators!.isNotEmpty) {
      for (var validator in widget.customValidators!) {
        final validatorResponse = await validator(value);
        if (validatorResponse?.isError ?? false) {
          setState(() {
            _errorText = validatorResponse?.message;
            _successMessage = null;
            _isValidating = false;
          });
          widget.onValidated?.call(false);
          return;
        } else if (validatorResponse?.isSuccess ?? false) {
          setState(() {
            _successMessage = validatorResponse?.message;
          });
        }
      }
    }

    setState(() {
      _errorText = null;
      _isValidating = false;
    });
    widget.onValidated?.call(true);
  }

  void _toggleSecureVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
    _validateInput('');
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _errorText != null
        ? widget.errorBorderColor
        : _successMessage != null
            ? widget.successBorderColor
            : _isFocused
                ? widget.focusBorderColor
                : widget.normalBorderColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (widget.leftIcon != null)
                GestureDetector(
                  onTap: widget.onLeftIconTap,
                  child: Icon(widget.leftIcon,
                      color:
                          widget.enabled ? Colors.grey : Colors.grey.shade400),
                ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  obscureText: _obscureText,
                  enabled: widget.enabled,
                  maxLines: widget.multiline ? widget.maxLines : 1,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    border: InputBorder.none,
                    label: Text(widget.label),
                  ),
                  keyboardType: widget.keyboardType,
                  onChanged: widget.onChanged,
                ),
              ),
              if (_isValidating)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
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
              if (widget.allowClear &&
                  _controller.text.isNotEmpty &&
                  !widget.secure)
                GestureDetector(
                  onTap: _clearText,
                  child: const Icon(Icons.clear, color: Colors.grey),
                ),
              if (widget.rightIcon != null && !widget.secure)
                GestureDetector(
                  onTap: widget.onRightIconTap,
                  child: Icon(widget.rightIcon, color: Colors.grey),
                ),
            ],
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              _errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            _successMessage ?? '',
            style: const TextStyle(color: Colors.green, fontSize: 12),
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', widget.label));
    properties.add(StringProperty('placeholder', widget.placeholder));
    properties.add(
        FlagProperty('secure', value: widget.secure, ifTrue: 'Password Mode'));
    properties.add(FlagProperty('required',
        value: widget.required, ifTrue: 'Field is required'));
    properties.add(StringProperty('error', _errorText));
  }
}
