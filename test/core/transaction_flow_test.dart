import 'package:flutter_test/flutter_test.dart';
import 'package:zainpay/core/transaction_status.dart';
import 'package:zainpay/utils/zainpay_utils.dart';
import 'package:zainpay/webhook/webhook_handler.dart';

void main() {
  group('Transaction utilities', () {
    test('TransactionStatus constants are stable', () {
      expect(TransactionStatus.successful, 'successful');
      expect(TransactionStatus.cancelled, 'cancelled');
      expect(TransactionStatus.error, 'error');
    });

    test('generateRandomString returns expected length', () {
      final value = ZainpayUtils.generateRandomString(12);

      expect(value.length, 12);
      expect(RegExp(r'^[A-Za-z0-9]+$').hasMatch(value), isTrue);
    });

    test('getStatusMessage returns fallback for unknown codes', () {
      expect(ZainpayUtils.getStatusMessage('99'), 'Unknown status');
    });
  });

  group('WebhookHandler.processWebhookEvent', () {
    test('routes known event payloads to the right callback', () {
      bool successCalled = false;
      bool failedCalled = false;
      bool pendingCalled = false;
      bool unknownCalled = false;

      WebhookHandler.processWebhookEvent(
        payload: '{"event":"payment.success","data":{"id":"1"}}',
        onPaymentSuccess: (_) => successCalled = true,
        onPaymentFailed: (_) => failedCalled = true,
        onPaymentPending: (_) => pendingCalled = true,
        onUnknownEvent: (_) => unknownCalled = true,
      );

      expect(successCalled, isTrue);
      expect(failedCalled, isFalse);
      expect(pendingCalled, isFalse);
      expect(unknownCalled, isFalse);
    });

    test('routes malformed payloads to onUnknownEvent', () {
      Map<String, dynamic>? unknownPayload;

      WebhookHandler.processWebhookEvent(
        payload: '{invalid-json',
        onPaymentSuccess: (_) {},
        onPaymentFailed: (_) {},
        onPaymentPending: (_) {},
        onUnknownEvent: (payload) => unknownPayload = payload,
      );

      expect(unknownPayload, isNotNull);
      expect(unknownPayload!.containsKey('error'), isTrue);
    });
  });
}

