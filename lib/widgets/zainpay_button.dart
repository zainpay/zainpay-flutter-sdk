import 'package:flutter/material.dart';
import 'package:zainpay/theme/zainpay_theme.dart';

/// Button types for ZainpayButton
enum ZainpayButtonType {
  /// Primary button with filled background
  primary,

  /// Secondary button with outlined border
  secondary,

  /// Text button with no background or border
  text,
}

/// A styled button for Zainpay
class ZainpayButton extends StatelessWidget {
  /// Text to display on the button
  final String text;

  /// Icon to display on the button (optional)
  final IconData? icon;

  /// Function to call when the button is pressed
  final VoidCallback onPressed;

  /// Whether the button is disabled
  final bool isDisabled;

  /// Whether to show a loading indicator
  final bool isLoading;

  /// Button type (primary, secondary, or text)
  final ZainpayButtonType buttonType;

  /// Button width (defaults to double.infinity)
  final double? width;

  /// Button height (defaults to 50)
  final double height;

  /// Creates a new Zainpay button
  const ZainpayButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isDisabled = false,
    this.isLoading = false,
    this.buttonType = ZainpayButtonType.primary,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    // Determine button style based on type
    ButtonStyle buttonStyle;
    switch (buttonType) {
      case ZainpayButtonType.primary:
        buttonStyle = ZainpayTheme.primaryButtonStyle;
        break;
      case ZainpayButtonType.secondary:
        buttonStyle = ZainpayTheme.secondaryButtonStyle;
        break;
      case ZainpayButtonType.text:
        buttonStyle = ZainpayTheme.textButtonStyle;
        break;
    }

    // Create button content
    Widget buttonContent;
    if (isLoading) {
      // Show loading indicator
      buttonContent = SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            buttonType == ZainpayButtonType.primary
                ? Colors.white
                : ZainpayTheme.primaryColor,
          ),
        ),
      );
    } else if (icon != null) {
      // Show icon and text
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    } else {
      // Show text only
      buttonContent = Text(text);
    }

    // Create button based on type
    Widget button;
    switch (buttonType) {
      case ZainpayButtonType.primary:
        button = ElevatedButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            minimumSize:
                WidgetStateProperty.all(Size(width ?? double.infinity, height)),
          ),
          child: buttonContent,
        );
        break;
      case ZainpayButtonType.secondary:
        button = OutlinedButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            minimumSize:
                WidgetStateProperty.all(Size(width ?? double.infinity, height)),
          ),
          child: buttonContent,
        );
        break;
      case ZainpayButtonType.text:
        button = TextButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            minimumSize:
                WidgetStateProperty.all(Size(width ?? double.infinity, height)),
          ),
          child: buttonContent,
        );
        break;
    }

    return button;
  }
}
