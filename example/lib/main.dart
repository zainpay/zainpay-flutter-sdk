import 'package:flutter/material.dart';
import 'package:zainpay/zainpay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zainpay Example',
      theme: ZainpayTheme.getThemeData(),
      home: const PaymentForm(),
    );
  }
}

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _amountController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Loading state
  bool _isLoading = false;

  // Transaction history
  final List<TransactionRecord> _transactions = [];

  @override
  void dispose() {
    _amountController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Get test public key
  String _getPublicKey() =>
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3phaW5wYXkubmciLCJpYXQiOjE2NDU3ODY3MzcsImlkIjozNzkwYjE5OC05ZGQ1LTQ5YjAtOWQ4Zi0yZjc0YzViOWUyNGEsIm5hbWUiOnRlc3QsInJvbGUiOnRlc3QsInNlY3JldEtleSI6eVpDRE1hWEpic3Nka3ZYbmlzc1B0c3Y0fQ.gNwiA_PK6IOmaprSLvQom_xYjAMP84SL-iADLJTlLms";

  // Get test zainbox code
  String _getZainBoxCode() => "THbfnDvK5o";

  // Handle payment
  Future<void> _handlePayment() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Start payment
      final response = await ZainpayCore.startPayment(
        context: context,
        publicKey: _getPublicKey(),
        fullName: _fullNameController.text,
        email: _emailController.text,
        mobileNumber: _phoneController.text,
        amount: _amountController.text,
        zainboxCode: _getZainBoxCode(),
        callBackUrl: "https://zainpay.ng/success",
        isTest: true,
      );

      // Handle response
      if (response != null) {
        // Add to transaction history
        setState(() {
          _transactions.add(
            TransactionRecord(
              amount: _amountController.text,
              date: DateTime.now(),
              status: response.status ?? 'unknown',
              reference: response.data?.txnRef ?? 'N/A',
            ),
          );
        });

        // Show success message
        if (mounted) {
          ZainpayUtils.showSuccessDialog(
            context: context,
            title: 'Payment Successful',
            message:
                'Your payment of ${ZainpayUtils.formatCurrency(_amountController.text)} was successful.',
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ZainpayUtils.showErrorDialog(
          context: context,
          title: 'Payment Failed',
          message: 'An error occurred: ${e.toString()}',
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zainpay Example'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Tab bar
            const TabBar(
              tabs: [
                Tab(text: 'Payment Form'),
                Tab(text: 'Transaction History'),
              ],
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                children: [
                  // Payment form
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          const Text(
                            'Make a Payment',
                            style: ZainpayTheme.headlineMedium,
                          ),
                          const SizedBox(height: 24),

                          // Amount field
                          TextFormField(
                            controller: _amountController,
                            decoration: ZainpayTheme.inputDecoration(
                              labelText: 'Amount',
                              hintText: 'Enter amount',
                              prefixIcon: const Icon(Icons.attach_money),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Full name field
                          TextFormField(
                            controller: _fullNameController,
                            decoration: ZainpayTheme.inputDecoration(
                              labelText: 'Full Name',
                              hintText: 'Enter your full name',
                              prefixIcon: const Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            decoration: ZainpayTheme.inputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              prefixIcon: const Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Phone field
                          TextFormField(
                            controller: _phoneController,
                            decoration: ZainpayTheme.inputDecoration(
                              labelText: 'Phone Number',
                              hintText: 'Enter your phone number',
                              prefixIcon: const Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),

                          // Pay button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handlePayment,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text('Pay Now'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Transaction history
                  _transactions.isEmpty
                      ? const Center(
                          child: Text('No transactions yet'),
                        )
                      : ListView.builder(
                          itemCount: _transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = _transactions[index];
                            return ListTile(
                              title: Text(ZainpayUtils.formatCurrency(
                                  transaction.amount)),
                              subtitle: Text('Ref: ${transaction.reference}'),
                              trailing: Text(
                                transaction.status,
                                style: TextStyle(
                                  color: transaction.status.toLowerCase() ==
                                          'success'
                                      ? ZainpayTheme.successColor
                                      : ZainpayTheme.errorColor,
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Transaction record for history
class TransactionRecord {
  final String amount;
  final DateTime date;
  final String status;
  final String reference;

  TransactionRecord({
    required this.amount,
    required this.date,
    required this.status,
    required this.reference,
  });
}
