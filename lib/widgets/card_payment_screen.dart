import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:zainpay/models/payment_request.dart';
import 'package:zainpay/models/payment_response.dart';
import 'package:zainpay/theme/zainpay_theme.dart';
import 'package:zainpay/utils/zainpay_utils.dart';

/// Screen for card payment
class CardPaymentScreen extends StatefulWidget {
  /// Payment request
  final PaymentRequest request;
  
  /// Session ID for the payment
  final String? sessionId;

  /// Creates a new card payment screen
  const CardPaymentScreen({
    super.key,
    required this.request,
    required this.sessionId,
  });

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  /// Whether the screen is loading
  bool _isLoading = true;
  
  /// InAppWebView controller
  late InAppWebViewController _webViewController;
  
  /// Progress of the web view
  double _progress = 0;
  
  /// Payment URL
  String _paymentUrl = '';
  
  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  /// Initializes the payment and gets the payment URL
  Future<void> _initializePayment() async {
    try {
      final response = await widget.request.initializePayment();
      if (response != null && response.data != null) {
        setState(() {
          _paymentUrl = response.data!;
          _isLoading = false;
        });
      } else {
        _showError('Failed to initialize payment');
      }
    } catch (e) {
      _showError('Error initializing payment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          if (_isLoading || _progress < 1.0)
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(ZainpayTheme.primaryColor),
            ),
          
          // Web view
          Expanded(
            child: _paymentUrl.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri(_paymentUrl),
                    ),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      clearCache: true,
                    ),
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      _handleUrlChange(url);
                    },
                    onLoadStop: (controller, url) {
                      setState(() {
                        _isLoading = false;
                      });
                      _handleUrlChange(url);
                    },
                    onProgressChanged: (controller, progress) {
                      setState(() {
                        _progress = progress / 100;
                      });
                    },
                    onReceivedError: (controller, request, error) {
                      setState(() {
                        _isLoading = false;
                      });
                      _showError('Error loading payment page: ${error.description}');
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Handles URL changes in the web view
  void _handleUrlChange(WebUri? url) {
    if (url == null) return;
    
    // Check if the URL contains payment status parameters
    final status = url.queryParameters['status'];
    final txRef = url.queryParameters['txnRef'];
    
    if (status != null && txRef != null) {
      if (status.toLowerCase() == 'success') {
        // Payment successful
        final response = PaymentResponse(
          code: '00',
          status: 'success',
          description: 'Payment successful',
          data: PaymentData(
            txnRef: txRef,
            callBackUrl: url.toString(),
          ),
        );
        
        Navigator.of(context).pop(response);
      } else {
        // Payment failed
        _showError('Payment failed or was cancelled');
        Navigator.of(context).pop();
      }
    }
  }

  /// Shows an error message
  void _showError(String message) {
    ZainpayUtils.showToast(message, context);
  }
}
