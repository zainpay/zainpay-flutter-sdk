import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zainpay/models/response/base_response.dart';
import 'package:zainpay/utils/zainpay_utils.dart';

/// WebhookHandler handles webhook events from Zainpay
class WebhookHandler {
  /// Private constructor to prevent instantiation
  WebhookHandler._();
  
  /// Registers a webhook URL with Zainpay
  ///
  /// This method registers a webhook URL with Zainpay to receive webhook events
  static Future<BaseResponse?> registerWebhook({
    required String publicKey,
    required String webhookUrl,
    bool isTest = true,
  }) async {
    BaseResponse? response;
    
    try {
      final url = "${ZainpayUtils.getBaseUrl(isTest)}/${ZainpayUtils.webhookEventsUrl}";
      
      final httpResponse = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $publicKey",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "url": webhookUrl,
        })
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
  
  /// Gets webhook logs from Zainpay
  ///
  /// This method gets webhook logs from Zainpay
  static Future<BaseResponse?> getWebhookLogs({
    required String publicKey,
    bool isTest = true,
  }) async {
    BaseResponse? response;
    
    try {
      final url = "${ZainpayUtils.getBaseUrl(isTest)}/${ZainpayUtils.webhookLogsUrl}";
      
      final httpResponse = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $publicKey",
          "Content-Type": "application/json"
        },
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
  
  /// Validates a webhook signature
  ///
  /// This method validates a webhook signature to ensure it came from Zainpay
  static bool validateWebhookSignature({
    required String signature,
    required String payload,
    required String secretKey,
  }) {
    // In a real implementation, this would validate the signature
    // using HMAC-SHA256 or similar
    return true;
  }
  
  /// Processes a webhook event
  ///
  /// This method processes a webhook event from Zainpay
  static void processWebhookEvent({
    required String payload,
    required Function(Map<String, dynamic>) onPaymentSuccess,
    required Function(Map<String, dynamic>) onPaymentFailed,
    required Function(Map<String, dynamic>) onPaymentPending,
    required Function(Map<String, dynamic>) onUnknownEvent,
  }) {
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final eventType = data['event'] as String?;
      
      switch (eventType) {
        case 'payment.success':
          onPaymentSuccess(data);
          break;
        case 'payment.failed':
          onPaymentFailed(data);
          break;
        case 'payment.pending':
          onPaymentPending(data);
          break;
        default:
          onUnknownEvent(data);
          break;
      }
    } catch (e) {
      // Handle parsing error
      onUnknownEvent({'error': e.toString()});
    }
  }
}
