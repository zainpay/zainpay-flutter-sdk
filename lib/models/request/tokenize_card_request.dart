import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zainpay/models/response/tokenize_card_response.dart';
import 'package:zainpay/utils/zainpay_utils.dart';

/// Request model for tokenizing a card
class TokenizeCardRequest {
  final String publicKey;
  final String email;
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;
  final String cvv;
  final String pin;
  final bool isTest;

  /// Creates a new TokenizeCardRequest
  TokenizeCardRequest({
    required this.publicKey,
    required this.email,
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvv,
    required this.pin,
    required this.isTest,
  });

  /// Converts this instance to JSON
  Map<String, dynamic> toJson() => {
    "email": email,
    "cardNumber": cardNumber,
    "expiryMonth": expiryMonth,
    "expiryYear": expiryYear,
    "cvv": cvv,
    "pin": pin,
  };

  @override
  String toString() => jsonEncode(toJson());

  /// Tokenizes a card
  Future<TokenizeCardResponse?> tokenizeCard() async {
    TokenizeCardResponse? response;
    
    try {
      final url = "${ZainpayUtils.getBaseUrl(isTest)}/${ZainpayUtils.tokenizeCardUrl}";
      
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
        response = TokenizeCardResponse.fromJson(responseBody);
      }
    } catch (e) {
      // Return null on error
    }
    
    return response;
  }
}
