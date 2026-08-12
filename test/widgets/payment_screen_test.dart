import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zainpay/models/payment_request.dart';
import 'package:zainpay/models/payment_response.dart';
import 'package:zainpay/widgets/payment_screen.dart';

void main() {
  group('PaymentScreen', () {
    testWidgets('renders payment options when initialization succeeds',
        (tester) async {
      final request = _FakePaymentRequest(
        initializationResponse: InitPaymentResponse(
          code: '00',
          description: 'Initialized',
          status: '200 OK',
          sessionId: 'session_123',
          data: 'https://pay.example.com/checkout?e=session_123',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: PaymentScreen(request: request),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Select Payment Method'), findsOneWidget);
      expect(find.text('Pay with Card'), findsOneWidget);
      expect(find.text('Pay with Bank Transfer'), findsOneWidget);
    });

    testWidgets('shows initialization failure dialog when request returns null',
        (tester) async {
      final request = _FakePaymentRequest(initializationResponse: null);

      await tester.pumpWidget(
        MaterialApp(
          home: PaymentScreen(request: request),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Payment Initialization Failed'), findsOneWidget);
      expect(find.text('Unable to initialize payment. Please try again.'),
          findsOneWidget);
    });

    testWidgets('close button pops back to previous route', (tester) async {
      final request = _FakePaymentRequest(
        initializationResponse: InitPaymentResponse(
          code: '00',
          description: 'Initialized',
          status: '200 OK',
          sessionId: 'session_123',
          data: 'https://pay.example.com/checkout?e=session_123',
        ),
      );

      await tester.pumpWidget(_PaymentLauncher(request: request));

      await tester.tap(find.text('Open Payment'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      expect(find.byType(PaymentScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Open Payment'), findsOneWidget);
    });
  });
}

class _FakePaymentRequest extends PaymentRequest {
  _FakePaymentRequest({required this.initializationResponse})
      : super(
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

  final InitPaymentResponse? initializationResponse;

  @override
  Future<InitPaymentResponse?> initializePayment() async {
    return initializationResponse;
  }
}

class _PaymentLauncher extends StatelessWidget {
  const _PaymentLauncher({required this.request});

  final PaymentRequest request;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(request: request),
                    ),
                  );
                },
                child: const Text('Open Payment'),
              ),
            );
          },
        ),
      ),
    );
  }
}

