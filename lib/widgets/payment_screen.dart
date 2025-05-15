import 'package:flutter/material.dart';
import 'package:zainpay/models/payment_request.dart';
import 'package:zainpay/models/payment_response.dart';
import 'package:zainpay/theme/zainpay_theme.dart';
import 'package:zainpay/utils/zainpay_utils.dart';
import 'package:zainpay/widgets/card_payment_screen.dart';
import 'package:zainpay/widgets/payment_method_card.dart';
import 'package:zainpay/widgets/bank_transfer_screen.dart';
import 'package:zainpay/widgets/zainpay_button.dart';

/// Main payment screen for Zainpay
class PaymentScreen extends StatefulWidget {
  /// Payment request
  final PaymentRequest request;

  /// Creates a new payment screen
  const PaymentScreen({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  /// Whether the screen is loading
  bool _isLoading = false;
  
  /// Session ID for the payment
  String? _sessionId;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  /// Initializes the payment
  Future<void> _initializePayment() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Initialize payment
      final response = await widget.request.initializePayment();
      
      if (response != null) {
        setState(() {
          _sessionId = response.sessionId;
          _isLoading = false;
        });
      } else {
        // Show error
        if (mounted) {
          ZainpayUtils.showErrorDialog(
            context: context,
            title: 'Payment Initialization Failed',
            message: 'Unable to initialize payment. Please try again.',
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          );
        }
      }
    } catch (e) {
      // Show error
      if (mounted) {
        ZainpayUtils.showErrorDialog(
          context: context,
          title: 'Payment Initialization Failed',
          message: 'An error occurred: ${e.toString()}',
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      }
    }
  }

  /// Handles payment method selection
  Future<void> _handlePaymentMethodSelection(PaymentMethodType type) async {
    PaymentResponse? response;
    
    switch (type) {
      case PaymentMethodType.card:
        // Navigate to card payment screen
        response = await Navigator.push<PaymentResponse>(
          context,
          MaterialPageRoute(
            builder: (context) => CardPaymentScreen(
              request: widget.request,
              sessionId: _sessionId,
            ),
          ),
        );
        break;
      case PaymentMethodType.bankTransfer:
        // Navigate to bank transfer screen
        response = await Navigator.push<PaymentResponse>(
          context,
          MaterialPageRoute(
            builder: (context) => BankTransferScreen(
              request: VirtualAccountRequest(
                fullName: widget.request.fullName,
                amount: double.tryParse(widget.request.amount) ?? 0,
                publicKey: widget.request.publicKey,
                transactionRef: widget.request.transactionRef,
                email: widget.request.email,
                mobileNumber: widget.request.mobileNumber,
                zainboxCode: widget.request.zainboxCode,
                isTest: widget.request.isTest,
              ),
            ),
          ),
        );
        break;
      default:
        // Show not implemented message
        ZainpayUtils.showToast('This payment method is not yet available', context);
        return;
    }
    
    // Return response if available
    if (response != null && mounted) {
      Navigator.of(context).pop(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment amount
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ZainpayTheme.secondaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          color: ZainpayTheme.primaryColor,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount to Pay',
                              style: ZainpayTheme.bodyMedium.copyWith(
                                color: ZainpayTheme.textLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ZainpayUtils.formatCurrency(widget.request.amount),
                              style: ZainpayTheme.headlineMedium.copyWith(
                                color: ZainpayTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Payment methods title
                  Text(
                    'Select Payment Method',
                    style: ZainpayTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  // Payment methods
                  PaymentMethodCard(
                    type: PaymentMethodType.card,
                    onTap: () => _handlePaymentMethodSelection(PaymentMethodType.card),
                  ),
                  const SizedBox(height: 12),
                  PaymentMethodCard(
                    type: PaymentMethodType.bankTransfer,
                    onTap: () => _handlePaymentMethodSelection(PaymentMethodType.bankTransfer),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Cancel button
                  ZainpayButton(
                    text: 'Cancel Payment',
                    onPressed: () => Navigator.of(context).pop(),
                    buttonType: ZainpayButtonType.secondary,
                  ),
                ],
              ),
            ),
    );
  }
}
