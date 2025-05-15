import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zainpay/models/response/create_va_response.dart';

import '../../utils.dart';
import '../response/va_balance_response.dart';

class CreateVirtualAccountRequest {
  final String fullName;
  final double amount;
  final String publicKey;
  final String transactionRef;
  final String email;
  final String mobileNumber;
  final String zainboxCode;
  final bool isTest;

  CreateVirtualAccountRequest(
      {required this.publicKey,
      required this.fullName,
      required this.transactionRef,
      required this.email,
      required this.mobileNumber,
      required this.zainboxCode,
      required this.amount,
      required this.isTest});

  @override
  String toString() => jsonEncode(toJson());

  /// Converts this instance to json
  Map<String, dynamic> toJson() {
    final names = fullName.split(' ');
    final firstName = names.isNotEmpty ? names[0] : '';
    final surname = names.length > 1 ? names[1] : '';

    return {
      "bankType": "wemaBank",
      "firstName": firstName,
      "surname": surname,
      "email": email,
      "mobileNumber": mobileNumber,
      "dob": DateTime.now()
          .toString()
          .substring(0, 10), // Current date in YYYY-MM-DD format
      "gender": "O", // O for Other/Not specified
      "address": "Address", // Generic address
      "title": "Mx", // Gender-neutral title
      "state": "Lagos", // Default state
      "zainboxCode": zainboxCode
    };
  }

  /// Executes network call to initiate transactions
  Future<CreateVirtualAccountResponse?> createVirtualAccount(
      publicKey, isTest) async {
    CreateVirtualAccountResponse? createVirtualAccountResponse =
        CreateVirtualAccountResponse();

    final url = "${Utils.getBaseUrl(isTest)}/${Utils.createVirtualAccountUrl}";

    final response = await http.post(Uri.parse(url),
        headers: {
          "Authorization": "Bearer $publicKey",
          "Content-Type": "application/json"
        },
        body: toString());

    if (response.statusCode == 200 &&
        jsonDecode(response.body)["code"] == "00") {
      final responseBody = jsonDecode(response.body);
      createVirtualAccountResponse =
          CreateVirtualAccountResponse.fromJson(responseBody);
    } else {
      createVirtualAccountResponse = null;
    }

    return createVirtualAccountResponse;
  }

  /// Executes network call to initiate transactions
  Future<VirtualAccountBalanceResponse?> virtualAccountBalance(
      publicKey, accountNumber, isTest) async {
    VirtualAccountBalanceResponse? virtualAccountBalanceResponse =
        VirtualAccountBalanceResponse();

    final url =
        "${Utils.getBaseUrl(isTest)}/${Utils.virtualAccountBalanceUrl}/$accountNumber";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $publicKey",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200 &&
        jsonDecode(response.body)["code"] == "00") {
      final responseBody = jsonDecode(response.body);
      virtualAccountBalanceResponse =
          VirtualAccountBalanceResponse.fromJson(responseBody);
    } else {
      virtualAccountBalanceResponse = null;
    }

    return virtualAccountBalanceResponse;
  }
}
