import 'package:flutter/material.dart';
import 'package:zainpay/view/PaymentIntro.dart';

import '../models/request/standard_request.dart';
import '../models/response/payment_response.dart';

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

  /// Starts Standard Transaction
  Future<PaymentResponse?> charge() async {

    final StandardRequest request = StandardRequest(
      amount: amount,
      transactionRef: transactionRef,
      mobileNumber: mobileNumber,
      zainboxCode: zainboxCode,
      email: email,
      publicKey: publicKey,
      callBackUrl: callBackUrl,
      fullName: fullName,
      isTest: isTest
    );

    return await Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => PaymentIntro(
            context: context,
            standardRequest: request,
          ),
        ));
  }
}