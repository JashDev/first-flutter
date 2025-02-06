import 'package:flutter/material.dart';
import '../helpers/throttle_controller.dart';

enum ButtonType { primary, outline, ghost, success }

enum ButtonSize { small, medium }

enum IconPosition { none, left, right }

class G66MaterialButton extends StatefulWidget {
  final String text;
  final bool isLoading;
  final bool isEnabled;
  final ButtonType type;
  final ButtonSize size;
  final bool fullWidth;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconPosition iconPosition;
  final Duration throttleTime;

  const G66MaterialButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.fullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.none,
    this.throttleTime = const Duration(milliseconds: 1000),
  });

  @override
  State<G66MaterialButton> createState() => _G66MaterialButtonState();
}

class _G66MaterialButtonState extends State<G66MaterialButton> {
  late ThrottleController _throttleController;

  _configureOnPressedThrottleController() {
    _throttleController = ThrottleController(
      duration: widget.throttleTime,
      action: widget.onPressed ?? () {},
    );
  }

  @override
  void initState() {
    super.initState();
    _configureOnPressedThrottleController();
  }

  @override
  void didUpdateWidget(covariant G66MaterialButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onPressed != widget.onPressed) {
      _configureOnPressedThrottleController();
    }
  }

  @override
  void dispose() {
    _throttleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isEnabled) return;
    _throttleController.run();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == ButtonType.outline) {
      return _buildOutlinedButton();
    } else if (widget.type == ButtonType.ghost) {
      return _buildGhostButton();
    } else {
      return _buildElevatedButton();
    }
  }

  Widget _buildOutlinedButton() {
    return SizedBox(
      width: widget.fullWidth ? double.infinity : null,
      height: _getButtonHeight(),
      child: OutlinedButton(
        onPressed: widget.isEnabled ? _handleTap : null,
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            padding: WidgetStatePropertyAll(_getPadding()),
            side: WidgetStatePropertyAll(BorderSide(
                color: widget.isEnabled
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).disabledColor))),
        child:
            _buildButtonContent(widget.isEnabled ? Colors.blue : Colors.grey),
      ),
    );
  }

  Widget _buildGhostButton() {
    return SizedBox(
      width: widget.fullWidth ? double.infinity : null,
      height: _getButtonHeight(),
      child: TextButton(
        onPressed: widget.isEnabled ? _handleTap : null,
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              padding: WidgetStatePropertyAll(_getPadding()),
            ),
        child:
            _buildButtonContent(widget.isEnabled ? Colors.blue : Colors.grey),
      ),
    );
  }

  Widget _buildElevatedButton() {
    return SizedBox(
      width: widget.fullWidth ? double.infinity : null,
      height: _getButtonHeight(),
      child: ElevatedButton(
        onPressed: widget.isEnabled ? _handleTap : null,
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              padding: WidgetStatePropertyAll(_getPadding()),
            ),
        child: _buildButtonContent(Colors.white),
      ),
    );
  }

  Widget _buildButtonContent(Color textColor) {
    if (widget.isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    }

    final textWidget = Text(
      widget.text,
      style: TextStyle(
        color: textColor,
        fontSize: widget.size == ButtonSize.small ? 14 : 16,
        fontWeight: FontWeight.w600,
      ),
    );

    if (widget.icon == null || widget.iconPosition == IconPosition.none) {
      return textWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.iconPosition == IconPosition.left)
          Icon(widget.icon, color: textColor),
        if (widget.iconPosition == IconPosition.left) const SizedBox(width: 8),
        textWidget,
        if (widget.iconPosition == IconPosition.right) const SizedBox(width: 8),
        if (widget.iconPosition == IconPosition.right)
          Icon(widget.icon, color: textColor),
      ],
    );
  }

  double _getButtonHeight() {
    switch (widget.size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 48;
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20);
    }
  }
}
