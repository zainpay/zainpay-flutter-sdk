import 'package:flutter/material.dart';
import 'package:zainpay/models/response/payment_response.dart';
import 'package:zainpay/models/request/standard_request.dart';
import 'package:zainpay/view/view_utils.dart';
import '../core/navigation_controller.dart';
import '../core/transaction_callback.dart';

class CardPayment extends StatefulWidget {

  final StandardRequest request;
  final String? sessionId;
  final BuildContext context;

  const CardPayment({
    Key? key,
    required this.request,
    required this.sessionId,
    required this.context
  }) : super(key: key);

  @override
  CardPaymentState createState() => CardPaymentState();
}

class CardPaymentState extends State<CardPayment>
    implements TransactionCallBack {

  final _navigatorKey = GlobalKey<NavigatorState>();
  bool _isDisabled = false;
  late NavigationController controller;

  @override
  void initState() {
    _isDisabled = false;
    controller = NavigationController(this);
    super.initState();
    _handlePayment();
  }

  void _handlePayment() async {
    try {
      controller.startTransaction(widget.request);
    } catch (error) {
      _showErrorAndClose(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: const Scaffold(
        body: SafeArea(
          child: Center(),
        ),
      ),
    );
  }

  void _showErrorAndClose(final String errorMessage) {
    ZainpayViewUtils.showToast(widget.context, errorMessage);
    Navigator.pop(widget.context);
  }

  @override
  onTransactionError() {
    _showErrorAndClose("transaction error");
  }

  @override
  onCancelled() {
    ZainpayViewUtils.showToast(widget.context, "Transaction Cancelled");
    Navigator.pop(widget.context);
  }

  @override
  onTransactionSuccess(String id, String txRef, String callbackUrl) {
    OTPValidationDataResponse otpValidationDataResponse = OTPValidationDataResponse(
        callBackUrl: callbackUrl,
        txnRef: txRef
    );

    final PaymentResponse chargeResponse = PaymentResponse(
        status: "success",
        description: 'Payment Successful',
        code: "00",
        otpValidationDataResponse: otpValidationDataResponse
    );

    Navigator.pop(widget.context, chargeResponse);
  }
}
