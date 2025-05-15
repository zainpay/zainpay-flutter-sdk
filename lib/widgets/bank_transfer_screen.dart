import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zainpay/models/payment_request.dart';
import 'package:zainpay/models/payment_response.dart';
import 'package:zainpay/theme/zainpay_theme.dart';
import 'package:zainpay/utils/zainpay_utils.dart';
import 'package:zainpay/widgets/zainpay_button.dart';

/// Screen for bank transfer payment
class BankTransferScreen extends StatefulWidget {
  /// Virtual account request
  final VirtualAccountRequest request;

  /// Creates a new bank transfer screen
  const BankTransferScreen({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  State<BankTransferScreen> createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen> {
  /// Whether the screen is loading
  bool _isLoading = true;
  
  /// Whether the payment is being verified
  bool _isVerifying = false;
  
  /// Account details
  String? _accountNumber;
  String? _accountName;
  String? _bankName;
  
  /// Timer for checking payment status
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _createVirtualAccount();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Creates a virtual account
  Future<void> _createVirtualAccount() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Create virtual account
      final response = await widget.request.createVirtualAccount();
      
      if (response != null && response.data != null) {
        setState(() {
          _accountNumber = response.data!.accountNumber;
          _accountName = response.data!.accountName;
          _bankName = response.data!.bankName;
          _isLoading = false;
        });
      } else {
        // Show error
        if (mounted) {
          ZainpayUtils.showErrorDialog(
            context: context,
            title: 'Virtual Account Creation Failed',
            message: 'Unable to create virtual account. Please try again.',
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
          title: 'Virtual Account Creation Failed',
          message: 'An error occurred: ${e.toString()}',
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      }
    }
  }

  /// Verifies the payment
  Future<void> _verifyPayment() async {
    if (_accountNumber == null) return;
    
    setState(() {
      _isVerifying = true;
    });
    
    try {
      // Check virtual account balance
      final response = await widget.request.checkVirtualAccountBalance(_accountNumber!);
      
      if (response != null && response.data != null) {
        // Check if payment is complete
        if (response.data!.balanceAmount != null && 
            response.data!.balanceAmount! >= widget.request.amount) {
          // Payment successful
          _timer?.cancel();
          
          final paymentResponse = PaymentResponse(
            code: response.code,
            status: response.status,
            description: response.description,
            data: PaymentData(
              txnRef: widget.request.transactionRef,
              callBackUrl: null,
            ),
          );
          
          if (mounted) {
            Navigator.of(context).pop(paymentResponse);
          }
        } else {
          // Payment not yet complete
          setState(() {
            _isVerifying = false;
          });
        }
      } else {
        // Error checking balance
        setState(() {
          _isVerifying = false;
        });
      }
    } catch (e) {
      // Error checking balance
      setState(() {
        _isVerifying = false;
      });
    }
  }

  /// Starts automatic payment verification
  void _startAutoVerification() {
    // Cancel existing timer
    _timer?.cancel();
    
    // Start new timer
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isVerifying) {
        _verifyPayment();
      }
    });
    
    // Show message
    ZainpayUtils.showToast('Waiting for payment...', context);
  }

  /// Copies text to clipboard
  Future<void> _copyToClipboard(String text) async {
    await ZainpayUtils.copyToClipboard(text, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Transfer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                              ZainpayUtils.formatCurrency(widget.request.amount.toString()),
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
                  
                  // Instructions
                  Text(
                    'Transfer Instructions',
                    style: ZainpayTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please transfer the exact amount to the account details below. The payment will be automatically confirmed once received.',
                    style: ZainpayTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  
                  // Account details
                  _buildAccountDetailItem(
                    title: 'Bank Name',
                    value: _bankName ?? 'N/A',
                    canCopy: true,
                  ),
                  const Divider(),
                  _buildAccountDetailItem(
                    title: 'Account Number',
                    value: _accountNumber ?? 'N/A',
                    canCopy: true,
                  ),
                  const Divider(),
                  _buildAccountDetailItem(
                    title: 'Account Name',
                    value: _accountName ?? 'N/A',
                    canCopy: true,
                  ),
                  const Divider(),
                  _buildAccountDetailItem(
                    title: 'Amount',
                    value: ZainpayUtils.formatCurrency(widget.request.amount.toString()),
                    canCopy: false,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Verify payment button
                  ZainpayButton(
                    text: _isVerifying ? 'Verifying Payment...' : 'I have made the transfer',
                    onPressed: _isVerifying ? () {} : _startAutoVerification,
                    isLoading: _isVerifying,
                  ),
                  
                  const SizedBox(height: 16),
                  
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

  /// Builds an account detail item
  Widget _buildAccountDetailItem({
    required String title,
    required String value,
    required bool canCopy,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Title
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: ZainpayTheme.bodyMedium.copyWith(
                color: ZainpayTheme.textLight,
              ),
            ),
          ),
          
          // Value
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: ZainpayTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Copy button
          if (canCopy)
            IconButton(
              icon: const Icon(
                Icons.copy,
                size: 18,
                color: ZainpayTheme.primaryColor,
              ),
              onPressed: () => _copyToClipboard(value),
            ),
        ],
      ),
    );
  }
}
