import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zainpay/models/payment_request.dart';
import 'package:zainpay/models/payment_response.dart';
import 'package:zainpay/models/request/charge_tokenized_card_request.dart';
import 'package:zainpay/models/request/remove_tokenized_card_request.dart';
import 'package:zainpay/models/request/tokenize_card_request.dart';
import 'package:zainpay/models/response/base_response.dart';
import 'package:zainpay/models/response/tokenize_card_response.dart';
import 'package:zainpay/theme/zainpay_theme.dart';
import 'package:zainpay/utils/zainpay_utils.dart';
import 'package:zainpay/widgets/payment_screen.dart';

/// ZainpayCore is the main class for interacting with the Zainpay payment gateway
class ZainpayCore {
  /// Creates a new ZainpayCore instance
  const ZainpayCore._();

  /// Initializes a payment transaction
  ///
  /// This method displays a payment screen with the provided payment details
  /// and returns a [PaymentResponse] when the payment is complete.
  static Future<PaymentResponse?> startPayment({
    required BuildContext context,
    required String publicKey,
    required String fullName,
    required String email,
    required String mobileNumber,
    required String amount,
    required String zainboxCode,
    required String callBackUrl,
    String? transactionRef,
    bool isTest = true,
    ThemeData? theme,
  }) async {
    // Generate a transaction reference if not provided
    final txRef = transactionRef ?? ZainpayUtils.generateRandomString(12);

    // Create a payment request
    final request = PaymentRequest(
      fullName: fullName,
      amount: amount,
      publicKey: publicKey,
      transactionRef: txRef,
      email: email,
      mobileNumber: mobileNumber,
      zainboxCode: zainboxCode,
      callBackUrl: callBackUrl,
      isTest: isTest,
    );

    // Show the payment screen
    return await Navigator.push<PaymentResponse>(
      context,
      MaterialPageRoute(
        builder: (context) => Theme(
          data: theme ?? ZainpayTheme.getThemeData(),
          child: PaymentScreen(
            request: request,
          ),
        ),
      ),
    );
  }

  /// Creates a virtual account for bank transfer payments
  ///
  /// This method creates a virtual account with the provided details
  /// and returns a [VirtualAccountResponse] when the account is created.
  static Future<VirtualAccountResponse?> createVirtualAccount({
    required String publicKey,
    required String fullName,
    required String email,
    required String mobileNumber,
    required double amount,
    required String zainboxCode,
    String? transactionRef,
    bool isTest = true,
  }) async {
    // Generate a transaction reference if not provided
    final txRef = transactionRef ?? ZainpayUtils.generateRandomString(12);

    // Create a virtual account request
    final request = VirtualAccountRequest(
      fullName: fullName,
      amount: amount,
      publicKey: publicKey,
      transactionRef: txRef,
      email: email,
      mobileNumber: mobileNumber,
      zainboxCode: zainboxCode,
      isTest: isTest,
    );

    // Create the virtual account
    return await request.createVirtualAccount();
  }

  /// Checks the balance of a virtual account
  ///
  /// This method checks the balance of a virtual account with the provided details
  /// and returns a [VirtualAccountBalanceResponse] with the balance information.
  static Future<VirtualAccountBalanceResponse?> checkVirtualAccountBalance({
    required String publicKey,
    required String accountNumber,
    required String fullName,
    required String email,
    required String mobileNumber,
    required double amount,
    required String zainboxCode,
    String? transactionRef,
    bool isTest = true,
  }) async {
    // Generate a transaction reference if not provided
    final txRef = transactionRef ?? ZainpayUtils.generateRandomString(12);

    // Create a virtual account request
    final request = VirtualAccountRequest(
      fullName: fullName,
      amount: amount,
      publicKey: publicKey,
      transactionRef: txRef,
      email: email,
      mobileNumber: mobileNumber,
      zainboxCode: zainboxCode,
      isTest: isTest,
    );

    // Check the virtual account balance
    return await request.checkVirtualAccountBalance(accountNumber);
  }

  /// Tokenizes a card for future payments
  ///
  /// This method tokenizes a card with the provided details
  /// and returns a [TokenizeCardResponse] with the token information.
  static Future<TokenizeCardResponse?> tokenizeCard({
    required String publicKey,
    required String email,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required String pin,
    bool isTest = true,
  }) async {
    // Create a tokenize card request
    final request = TokenizeCardRequest(
      publicKey: publicKey,
      email: email,
      cardNumber: cardNumber,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvv: cvv,
      pin: pin,
      isTest: isTest,
    );

    // Tokenize the card
    return await request.tokenizeCard();
  }

  /// Charges a tokenized card
  ///
  /// This method charges a tokenized card with the provided details
  /// and returns a [PaymentResponse] with the payment information.
  static Future<PaymentResponse?> chargeTokenizedCard({
    required String publicKey,
    required String email,
    required String token,
    required String amount,
    required String zainboxCode,
    required String callBackUrl,
    String? transactionRef,
    bool isTest = true,
  }) async {
    // Generate a transaction reference if not provided
    final txRef = transactionRef ?? ZainpayUtils.generateRandomString(12);

    // Create a charge tokenized card request
    final request = ChargeTokenizedCardRequest(
      publicKey: publicKey,
      email: email,
      token: token,
      amount: amount,
      zainboxCode: zainboxCode,
      transactionRef: txRef,
      callBackUrl: callBackUrl,
      isTest: isTest,
    );

    // Charge the tokenized card
    return request.chargeTokenizedCard();
  }

  /// Removes a tokenized card
  ///
  /// This method removes a tokenized card with the provided details
  /// and returns a [BaseResponse] with the removal information.
  static Future<BaseResponse?> removeTokenizedCard({
    required String publicKey,
    required String email,
    required String token,
    bool isTest = true,
  }) async {
    // Create a remove tokenized card request
    final request = RemoveTokenizedCardRequest(
      publicKey: publicKey,
      email: email,
      token: token,
      isTest: isTest,
    );

    // Remove the tokenized card
    return request.removeTokenizedCard();
  }

  /// Verifies a transaction
  ///
  /// This method verifies a transaction with the provided details
  /// and returns a [PaymentResponse] with the verification information.
  static Future<PaymentResponse?> verifyTransaction({
    required String publicKey,
    required String transactionRef,
    bool isTest = true,
  }) async {
    try {
      final url =
          "${ZainpayUtils.getBaseUrl(isTest)}/${ZainpayUtils.transactionVerificationUrl}/$transactionRef";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $publicKey",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return PaymentResponse.fromJson(responseBody);
      }
    } catch (e) {
      // Return null on error
    }

    return null;
  }
}
