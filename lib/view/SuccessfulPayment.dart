import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/response/payment_response.dart';
import 'Constants.dart';

class SuccessfulPayment extends StatefulWidget {

  final dynamic request;
  final PaymentResponse paymentResponse;
  final BuildContext context;

  const SuccessfulPayment({
    Key? key,
    required this.request,
    required this.paymentResponse,
    required this.context,
  }) : super(key: key);

  @override
  SuccessfulPaymentState createState() => SuccessfulPaymentState();
}

class SuccessfulPaymentState extends State<SuccessfulPayment> {

  @override
  void initState() {
    super.initState();
    reRoute();
  }

  Future<void> reRoute() async =>
      await Future.delayed(const Duration(seconds: 1), () =>
          Navigator.pop(context, widget.paymentResponse)
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 70),
                  Center(
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexToColor(paymentIconBlueBackgroundColor),
                      ),
                      child: Container(
                        height: 40.29,
                        width: 40.29,
                        margin: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hexToColor(paymentBlueBackgroundColor),
                        ),
                        child: const Icon(FontAwesomeIcons.checkDouble,
                          size: 15, color: Colors.white,),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Center(
                      child: Text('Transaction Successful',
                          textAlign: TextAlign.center,
                          style: blackTextStyle.copyWith(
                              color: hexToColor(blackColor),
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                          )
                      )
                  ),
                  const SizedBox(height: 16,),
                  Container(
                    width: 250,
                    margin: const EdgeInsets.all(10),
                    child: Center(
                      child: RichText(
                          text: TextSpan(
                              text: 'Payment of ',
                              style: blackTextStyle.copyWith(
                                  color: hexToColor(paymentTextColor),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400
                              ),
                              children: [
                                TextSpan(
                                  text: 'N${formatter.format(widget.request.amount)}',
                                  style: blackTextStyle.copyWith(
                                      color: hexToColor(paymentTextColor),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                TextSpan(
                                    text: ' is Successful',
                                    style: blackTextStyle.copyWith(
                                        color: hexToColor(paymentTextColor),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                    )
                                ),
                              ]
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: .5,
                      color: hexToColor(paymentBlueBackgroundColor),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        'You will be redirected automatically, please wait',
                        textAlign: TextAlign.center,
                        style: blackTextStyle.copyWith(
                            color: hexToColor(textGreyColor),
                            fontSize: 12,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}