import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zainpay/models/response/payment_response.dart';
import 'package:zainpay/utils/zainpay_utils.dart';

/// Request model for charging a tokenized card
class ChargeTokenizedCardRequest {
  final String publicKey;
  final String email;
  final String token;
  final String amount;
  final String zainboxCode;
  final String transactionRef;
  final String callBackUrl;
  final bool isTest;

  /// Creates a new ChargeTokenizedCardRequest
  ChargeTokenizedCardRequest({
    required this.publicKey,
    required this.email,
    required this.token,
    required this.amount,
    required this.zainboxCode,
    required this.transactionRef,
    required this.callBackUrl,
    required this.isTest,
  });

  /// Converts this instance to JSON
  Map<String, dynamic> toJson() => {
    "email": email,
    "token": token,
    "amount": amount,
    "zainboxCode": zainboxCode,
    "txnRef": transactionRef,
    "callBackUrl": callBackUrl,
  };

  @override
  String toString() => jsonEncode(toJson());

  /// Charges a tokenized card
  Future<PaymentResponse?> chargeTokenizedCard() async {
    PaymentResponse? response;
    
    try {
      final url = "${ZainpayUtils.getBaseUrl(isTest)}/${ZainpayUtils.chargeTokenizedCardUrl}";
      
      final httpResponse = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $publicKey",
          "Content-Type": "application/json"
        },
        body: toString()
      );
      
      if (httpResponse.statusCode == 200) {
        final responseBody = jsonDecode(httpResponse.body);
        response = PaymentResponse.fromJson(responseBody);
      }
    } catch (e) {
      // Return null on error
    }
    
    return response;
  }
}
