import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zainpay/models/request/create_va_request.dart';
import 'package:zainpay/models/request/standard_request.dart';
import 'package:zainpay/models/response/init_payment_response.dart';

import 'BankTransferPayment.dart';
import 'CardPayment.dart';
import 'Constants.dart';

class PaymentIntro extends StatefulWidget {

  final StandardRequest standardRequest;
  final BuildContext context;

  const PaymentIntro({
    Key? key,
    required this.standardRequest,
    required this.context
  }) : super(key: key);

  @override
  PaymentIntroState createState() => PaymentIntroState();
}

class PaymentIntroState extends State<PaymentIntro> {

  String? sessionId;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async => await startTransaction(widget.standardRequest)
      .then((value) {
    if(value != null) {
      setState(() => sessionId = value.sessionId);
    }
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: sessionId == null ? Container(
            margin: const EdgeInsets.only(top: 150, left: 150),
            child: CircularProgressIndicator(
              strokeWidth: .5,
              color: hexToColor(paymentBlueBackgroundColor),
            ),
          ) : Container(
            margin: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20, right: 16, left: 16),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.standardRequest.email,
                            style: blackTextStyle.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w400
                            ),),
                          const SizedBox(height: 4,),
                          Text('NGN ${formatter.format(double.parse(widget.standardRequest.amount))}',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            ),),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(right: 0),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            color: hexToColor(paymentCancelButtonColor)
                        ),
                        width: 75,
                        height: 32,
                        child: MaterialButton(
                          onPressed: () => Navigator.pop(widget.context),
                          child: Text('Cancel',
                              style: blackTextStyle.copyWith(
                                  color: hexToColor(paymentTextColor),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 18,
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: hexToColor(dividerGreyColor),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => CardPayment(
                          context: widget.context,
                          sessionId: sessionId,
                          request: widget.standardRequest,
                        ),
                      ),
                    ).then((value) async {
                      if(value != null) {
                        Navigator.pop(context, value);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              color: hexToColor(paymentIconBlueBackgroundColor),
                              borderRadius: BorderRadius.circular(4)
                          ),
                          child: Icon(FontAwesomeIcons.ccVisa, size: 12,
                              color: hexToColor(blackColor)),
                        ),
                        const SizedBox(width: 16,),
                        Text('Pay with Card',
                            style: blackTextStyle.copyWith(
                                color: hexToColor(blackColor),
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            )
                        ),
                        const Spacer(),
                        Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                                color: hexToColor(paymentCancelButtonColor),
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Icon(FontAwesomeIcons.chevronRight, size: 12,
                                color: hexToColor(blackColor))
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: hexToColor(dividerGreyColor),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    CreateVirtualAccountRequest createVARequest = CreateVirtualAccountRequest(
                        publicKey: widget.standardRequest.publicKey,
                        transactionRef: widget.standardRequest.transactionRef,
                        email: widget.standardRequest.email,
                        mobileNumber: widget.standardRequest.mobileNumber,
                        zainboxCode: widget.standardRequest.zainboxCode,
                        amount: double.parse(widget.standardRequest.amount),
                        fullName: widget.standardRequest.fullName,
                        isTest: widget.standardRequest.isTest
                    );
                    await Navigator.push(context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => BankTransferPayment(
                          context: context,
                          request: createVARequest,
                        ),
                      ),
                    ).then((value) => Navigator.pop(context, value));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                                color: hexToColor(paymentIconBlueBackgroundColor),
                                borderRadius: BorderRadius.circular(4)
                            ),
                            child: Icon(FontAwesomeIcons.buildingColumns, size: 12, color: hexToColor(blackColor),)
                        ),
                        const SizedBox(width: 16,),
                        Text('Pay with Bank Transfer',
                            style: blackTextStyle.copyWith(
                                color: hexToColor(blackColor),
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            )
                        ),
                        const Spacer(),
                        Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                                color: hexToColor(paymentCancelButtonColor),
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Icon(FontAwesomeIcons.chevronRight, size: 12, color: hexToColor(blackColor),)
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: hexToColor(dividerGreyColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<InitPaymentResponse?> startTransaction(final StandardRequest request) async =>
      await request.initializePayment(widget.standardRequest.publicKey);

}
