import 'package:flutter_test/flutter_test.dart';
import 'package:zainpay/models/payment_request.dart';

void main() {
  group('PaymentRequest', () {
    test('toJson maps required API fields', () {
      final request = PaymentRequest(
        fullName: 'Jane Doe',
        amount: '5000',
        publicKey: 'pk_test',
        transactionRef: 'txn_123',
        email: 'jane@example.com',
        mobileNumber: '08012345678',
        zainboxCode: 'zb_001',
        callBackUrl: 'https://example.com/callback',
        isTest: true,
      );

      final payload = request.toJson();

      expect(payload['amount'], '5000');
      expect(payload['txnRef'], 'txn_123');
      expect(payload['mobileNumber'], '08012345678');
      expect(payload['zainboxCode'], 'zb_001');
      expect(payload['emailAddress'], 'jane@example.com');
      expect(payload['callBackUrl'], 'https://example.com/callback');
      expect(payload['isTest'], isTrue);
    });
  });

  group('VirtualAccountRequest', () {
    test('toJson splits fullName into firstName and surname', () {
      final request = VirtualAccountRequest(
        fullName: 'Jane Doe',
        amount: 2500,
        publicKey: 'pk_test',
        transactionRef: 'txn_va_123',
        email: 'jane@example.com',
        mobileNumber: '08012345678',
        zainboxCode: 'zb_001',
        isTest: true,
      );

      final payload = request.toJson();

      expect(payload['firstName'], 'Jane');
      expect(payload['surname'], 'Doe');
      expect(payload['zainboxCode'], 'zb_001');
    });

    test('toJson keeps surname empty for single-name fullName', () {
      final request = VirtualAccountRequest(
        fullName: 'Plato',
        amount: 2500,
        publicKey: 'pk_test',
        transactionRef: 'txn_va_456',
        email: 'plato@example.com',
        mobileNumber: '08012345678',
        zainboxCode: 'zb_001',
        isTest: true,
      );

      final payload = request.toJson();

      expect(payload['firstName'], 'Plato');
      expect(payload['surname'], '');
    });
  });
}

