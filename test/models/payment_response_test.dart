import 'package:flutter_test/flutter_test.dart';
import 'package:zainpay/models/payment_response.dart';

void main() {
  group('Payment response models', () {
    test('BaseResponse.fromJson maps fields', () {
      final response = BaseResponse.fromJson({
        'code': '00',
        'description': 'Success',
        'status': '200 OK',
      });

      expect(response.code, '00');
      expect(response.description, 'Success');
      expect(response.status, '200 OK');
    });

    test('InitPaymentResponse extracts sessionId from data URL', () {
      final response = InitPaymentResponse.fromJson({
        'code': '00',
        'description': 'Initialized',
        'status': '200 OK',
        'data': 'https://pay.example.com/checkout?e=session_abc123',
      });

      expect(response.sessionId, 'session_abc123');
      expect(response.data, 'https://pay.example.com/checkout?e=session_abc123');
    });

    test('PaymentResponse parses nested payment data', () {
      final response = PaymentResponse.fromJson({
        'code': '00',
        'description': 'Payment successful',
        'status': 'success',
        'data': {
          'callBackUrl': 'https://example.com/callback',
          'txnRef': 'txn_123',
        },
      });

      expect(response.code, '00');
      expect(response.status, 'success');
      expect(response.data?.txnRef, 'txn_123');
      expect(response.data?.callBackUrl, 'https://example.com/callback');
    });

    test('VirtualAccountBalanceResponse converts numeric balance to double', () {
      final response = VirtualAccountBalanceResponse.fromJson({
        'code': '00',
        'description': 'Balance fetched',
        'status': 'success',
        'data': {
          'accountName': 'Jane Doe',
          'accountNumber': '1234567890',
          'balanceAmount': 5000,
          'transactionDate': '2024-05-01',
        },
      });

      expect(response.data?.balanceAmount, 5000.0);
      expect(response.data?.accountNumber, '1234567890');
    });
  });
}

