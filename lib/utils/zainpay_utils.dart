import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zainpay/theme/zainpay_theme.dart';

/// ZainpayUtils provides utility methods for the Zainpay SDK
class ZainpayUtils {
  ZainpayUtils._(); // Private constructor to prevent instantiation

  /// API URLs and endpoints
  static String getBaseUrl(final bool isTest) =>
      isTest ? "https://sandbox.zainpay.ng" : "https://api.zainpay.ng";

  // Card payment endpoints
  static const String cardBaseURL = "zainbox/card";
  static const String initializePaymentUrl = "$cardBaseURL/initialize/payment";
  static const String cardPaymentStatusUrl = "$cardBaseURL/payment/status";
  static const String cardPaymentReconciliationUrl =
      "$cardBaseURL/payment/reconciliation";

  // Card tokenization endpoints
  static const String cardTokenizationBaseURL = "card/tokenization";
  static const String tokenizeCardUrl = "$cardTokenizationBaseURL/tokenize";
  static const String chargeTokenizedCardUrl =
      "$cardTokenizationBaseURL/charge";
  static const String removeTokenizedCardUrl =
      "$cardTokenizationBaseURL/remove";

  // Virtual account endpoints
  static const String createVirtualAccountUrl =
      "virtual-account/create/request";
  static const String virtualAccountBalanceUrl =
      "virtual-account/wallet/balance";
  static const String transactionVerificationUrl =
      "virtual-account/wallet/transaction/verify";

  // Webhook endpoints
  static const String webhookEventsUrl = "webhook/events";
  static const String webhookLogsUrl = "webhook/logs";

  // Status codes
  static const String statusSuccess = "00";
  static const String statusPending = "01";
  static const String statusFailed = "02";
  static const String statusInvalidRequest = "03";
  static const String statusInvalidTransaction = "04";
  static const String statusInsufficientFunds = "05";
  static const String statusSystemError = "06";
  static const String statusDuplicateTransaction = "07";

  /// Get status message from status code
  static String getStatusMessage(String code) {
    switch (code) {
      case statusSuccess:
        return "Success";
      case statusPending:
        return "Pending";
      case statusFailed:
        return "Failed";
      case statusInvalidRequest:
        return "Invalid request";
      case statusInvalidTransaction:
        return "Invalid transaction";
      case statusInsufficientFunds:
        return "Insufficient funds";
      case statusSystemError:
        return "System error";
      case statusDuplicateTransaction:
        return "Duplicate transaction";
      default:
        return "Unknown status";
    }
  }

  /// Generates a random string of specified length
  static String generateRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  /// Formats currency amount
  static String formatCurrency(String amount, {String currency = 'NGN'}) {
    try {
      final double parsedAmount = double.parse(amount);
      return '$currency ${parsedAmount.toStringAsFixed(2)}';
    } catch (e) {
      return '$currency $amount';
    }
  }

  /// Copies text to clipboard and shows a toast
  static Future<void> copyToClipboard(String text, BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      showToast('Copied to clipboard', context);
    }
  }

  /// Shows a toast message
  static void showToast(String message, BuildContext context) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: ZainpayTheme.primaryColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Shows a snackbar
  static void showSnackBar(String message, BuildContext context,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? ZainpayTheme.errorColor : ZainpayTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Shows a loading dialog
  static Future<void> showLoadingDialog(BuildContext context,
      {String message = 'Loading...'}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(ZainpayTheme.primaryColor),
              ),
              const SizedBox(width: 16),
              Text(
                message,
                style: ZainpayTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Shows a confirmation dialog
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: ZainpayTheme.titleLarge,
          ),
          content: Text(
            message,
            style: ZainpayTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: ZainpayTheme.labelLarge.copyWith(
                  color: ZainpayTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  /// Shows a success dialog
  static Future<void> showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(
                Icons.check_circle,
                color: ZainpayTheme.successColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: ZainpayTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            message,
            style: ZainpayTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onPressed != null) {
                  onPressed();
                }
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  /// Shows an error dialog
  static Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(
                Icons.error,
                color: ZainpayTheme.errorColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: ZainpayTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            message,
            style: ZainpayTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onPressed != null) {
                  onPressed();
                }
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}
