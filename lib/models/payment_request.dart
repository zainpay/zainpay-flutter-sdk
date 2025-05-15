import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zainpay/models/payment_response.dart';
import 'package:zainpay/utils/zainpay_utils.dart';

/// PaymentRequest represents a payment request to be sent to Zainpay API
class PaymentRequest {
  /// Full name of the customer
  final String fullName;
  
  /// Amount to be charged
  final String amount;
  
  /// Public key for authentication
  final String publicKey;
  
  /// Unique transaction reference
  final String transactionRef;
  
  /// Customer's email address
  final String email;
  
  /// Customer's mobile number
  final String mobileNumber;
  
  /// Zainbox code for the merchant
  final String zainboxCode;
  
  /// URL to redirect to after payment
  final String callBackUrl;
  
  /// Whether to use test environment
  final bool isTest;

  /// Creates a new payment request
  PaymentRequest({
    required this.fullName,
    required this.amount,
    required this.publicKey,
    required this.transactionRef,
    required this.email,
    required this.mobileNumber,
    required this.zainboxCode,
    required this.callBackUrl,
    required this.isTest,
  });

  /// Converts this instance to a JSON string
  @override
  String toString() => jsonEncode(toJson());

  /// Converts this instance to a JSON map
  Map<String, dynamic> toJson() => {
    "amount": amount,
    "txnRef": transactionRef,
    "mobileNumber": mobileNumber,
    "zainboxCode": zainboxCode,
    "emailAddress": email,
    "callBackUrl": callBackUrl,
    "isTest": isTest
  };

  /// Initializes a payment transaction
  /// 
  /// Returns an [InitPaymentResponse] if successful, null otherwise
  Future<InitPaymentResponse?> initializePayment() async {
    try {
      final url = "${ZainpayUtils.getBaseUrl(isTest)}/${ZainpayUtils.initializePaymentUrl}";
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $publicKey",
          "Content-Type": "application/json"
        },
        body: toString()
      );
      
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody["code"] == "00") {
          return InitPaymentResponse.fromJson(responseBody);
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
}

/// VirtualAccountRequest represents a request to create a virtual account
class VirtualAccountRequest {
  /// Full name of the customer
  final String fullName;
  
  /// Amount to be charged
  final double amount;
  
  /// Public key for authentication
  final String publicKey;
  
  /// Unique transaction reference
  final String transactionRef;
  
  /// Customer's email address
  final String email;
  
  /// Customer's mobile number
  final String mobileNumber;
  
  /// Zainbox code for the merchant
  final String zainboxCode;
  
  /// Whether to use test environment
  final bool isTest;

  /// Creates a new virtual account request
  VirtualAccountRequest({
    required this.fullName,
    required this.amount,
    required this.publicKey,
    required this.transactionRef,
    required this.email,
    required this.mobileNumber,
    required this.zainboxCode,
    required this.isTest,
  });

  /// Converts this instance to a JSON string
  @override
  String toString() => jsonEncode(toJson());

  /// Converts this instance to a JSON map
  Map<String, dynamic> toJson() => {
    "bankType": "wemaBank",
    "firstName": fullName.split(' ').first,
    "surname": fullName.split(' ').length > 1 ? fullName.split(' ').last : "",
    "email": email,
    "mobileNumber": mobileNumber,
    "dob": "01-01-2000", // Default date of birth
    "gender": "M", // Default gender
    "address": "Address", // Default address
    "title": "Mr", // Default title
    "state": "Lagos", // Default state
    "zainboxCode": zainboxCode
  };

  /// Creates a virtual account
  /// 
  /// Returns a [VirtualAccountResponse] if successful, null otherwise
  Future<VirtualAccountResponse?> createVirtualAccount() async {
    try {
      final url = "${ZainpayUtils.getBaseUrl(isTest)}/${ZainpayUtils.createVirtualAccountUrl}";
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $publicKey",
          "Content-Type": "application/json"
        },
        body: toString()
      );
      
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody["code"] == "00") {
          return VirtualAccountResponse.fromJson(responseBody);
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Checks the balance of a virtual account
  /// 
  /// Returns a [VirtualAccountBalanceResponse] if successful, null otherwise
  Future<VirtualAccountBalanceResponse?> checkVirtualAccountBalance(String accountNumber) async {
    try {
      final url = "${ZainpayUtils.getBaseUrl(isTest)}/${ZainpayUtils.virtualAccountBalanceUrl}/$accountNumber";
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $publicKey",
          "Content-Type": "application/json"
        },
      );
      
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody["code"] == "00") {
          return VirtualAccountBalanceResponse.fromJson(responseBody);
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
}
