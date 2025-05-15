import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zainpay/models/response/base_response.dart';
import 'package:zainpay/utils/zainpay_utils.dart';

/// Request model for removing a tokenized card
class RemoveTokenizedCardRequest {
  final String publicKey;
  final String email;
  final String token;
  final bool isTest;

  /// Creates a new RemoveTokenizedCardRequest
  RemoveTokenizedCardRequest({
    required this.publicKey,
    required this.email,
    required this.token,
    required this.isTest,
  });

  /// Converts this instance to JSON
  Map<String, dynamic> toJson() => {
    "email": email,
    "token": token,
  };

  @override
  String toString() => jsonEncode(toJson());

  /// Removes a tokenized card
  Future<BaseResponse?> removeTokenizedCard() async {
    BaseResponse? response;
    
    try {
      final url = "${ZainpayUtils.getBaseUrl(isTest)}/${ZainpayUtils.removeTokenizedCardUrl}";
      
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
        response = BaseResponse.fromJson(responseBody);
      }
    } catch (e) {
      // Return null on error
    }
    
    return response;
  }
}
