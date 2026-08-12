import 'package:flutter/material.dart';
import '../src/zainpay_core.dart';
import '../models/payment_response.dart';

@Deprecated('Use ZainpayCore.startPayment(...) from package:zainpay/zainpay.dart')
class Zainpay {

  final BuildContext context;
  final String publicKey;
  final String transactionRef;
  final String email;
  final String fullName;
  final String mobileNumber;
  final String zainboxCode;
  final String callBackUrl;
  final String amount;
  final bool isTest;

  const Zainpay({
    required this.context,
    required this.publicKey,
    required this.transactionRef,
    required this.email,
    required this.fullName,
    required this.mobileNumber,
    required this.zainboxCode,
    required this.callBackUrl,
    required this.amount,
    required this.isTest,
  });

  /// Starts a transaction using the canonical ZainpayCore facade.
  Future<PaymentResponse?> charge() async {
    return ZainpayCore.startPayment(
      context: context,
      publicKey: publicKey,
      transactionRef: transactionRef,
      email: email,
      fullName: fullName,
      mobileNumber: mobileNumber,
      zainboxCode: zainboxCode,
      callBackUrl: callBackUrl,
      amount: amount,
      isTest: isTest,
    );
  }
}
