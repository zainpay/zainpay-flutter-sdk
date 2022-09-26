import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zainpay/models/request/create_va_request.dart';
import 'package:zainpay/models/response/create_va_response.dart';
import 'package:zainpay/zainpay.dart';

import '../models/response/va_balance_response.dart';
import 'Constants.dart';
import 'SuccessfulPayment.dart';

class BankTransferPayment extends StatefulWidget {

  final CreateVirtualAccountRequest request;
  final BuildContext context;

  const BankTransferPayment({
    Key? key,
    required this.request,
    required this.context
  }) : super(key: key);

  @override
  BankTransferPaymentState createState() => BankTransferPaymentState();
}

class BankTransferPaymentState extends State<BankTransferPayment>
    with WidgetsBindingObserver {

  String? accountNumber = "", accountName = "", bankName = "";
  bool isLoading = false;
  bool generalLoading = true;

  Future<CreateVirtualAccountResponse?> createVirtualAccount(final CreateVirtualAccountRequest request)
  async => await request.createVirtualAccount(widget.request.publicKey, widget.request.isTest);

  Future<VirtualAccountBalanceResponse?> virtualAccountBalance(final CreateVirtualAccountRequest request)
  async => await request.virtualAccountBalance(widget.request.publicKey, accountNumber, widget.request.isTest);

  init() async => await createVirtualAccount(widget.request)
      .then((value) {
    if(value != null) {
      setState(() {
        generalLoading = false;
        accountNumber = value.data?.accountNumber;
        accountName = value.data?.accountName;
        bankName = value.data?.bankName;
      });
    }else {
      Navigator.pop(context);
    }
  });

  checkVABalance() async {
    await virtualAccountBalance(widget.request)
        .then((value) async {
      if(value != null && value.data != null) {
        if (value.data?.balanceAmount >= widget.request.amount) {
          PaymentResponse paymentResponse = PaymentResponse(
              code: value.code,
              description: value.description,
              otpValidationDataResponse: value.data,
              status: value.status
          );
          setState(() => isLoading = false);
          await Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) =>
                SuccessfulPayment(
                    paymentResponse: paymentResponse,
                    request: widget.request,
                    context: widget.context
                ),
          )).then((value) {
            Navigator.pop(context, paymentResponse);
          });
        }else {
          checkVABalance();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> _copyToClipboard(text) async =>
      await Clipboard.setData(ClipboardData(text: text))
          .then((value) => showToast(message: 'Copied'));

  void reRouteToSuccess(isSuccessful) async =>
      Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) => SuccessfulPayment(
          paymentResponse: PaymentResponse(),
          request: widget.request,
          context: widget.context,
        ),
      ));

  @override
  Widget build(BuildContext context) {

    Text text = Text(accountNumber!,
        style: blackTextStyle.copyWith(
            color: hexToColor(blackColor),
            fontSize: 14,
            fontWeight: FontWeight.w400
        )
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: generalLoading ? Center(
          child: CircularProgressIndicator(
            color: hexToColor(paymentBlueBackgroundColor),
            strokeWidth: .5,
          ),
        ) : Container(
          margin: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20, right: 16, left: 16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.request.email,
                          style: blackTextStyle.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w400
                          ),),
                        const SizedBox(height: 4,),
                        Text('NGN ${formatter.format(widget.request.amount)}',
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
                        onPressed: () => Navigator.pop(context),
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
              Divider(
                height: 1,
                thickness: 1,
                color: hexToColor(dividerGreyColor),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, top: 10, bottom: 12),
                child: Text('Pay with Bank Transfer',
                  style: blackTextStyle.copyWith(
                      color: hexToColor(blackColor),
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16),
                child: SizedBox(
                  height: 50,
                  child : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Make a bank transfer of ',
                                  style: blackTextStyle.copyWith(
                                      color: hexToColor(paymentTextColor),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400
                                  )
                              ),
                              Text('N${formatter.format(widget.request.amount.abs())}',
                                  style: blackTextStyle.copyWith(
                                      color: hexToColor(blackColor),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                            ],
                          ),
                          Text('to the account number below',
                              style: blackTextStyle.copyWith(
                                  color: hexToColor(paymentTextColor),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: hexToColor(dividerGreyColor),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Text('Bank',
                            style: blackTextStyle.copyWith(
                                color: hexToColor(paymentTextColor),
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            )
                        ),
                        const Spacer(),
                        Text(bankName!,
                            style: blackTextStyle.copyWith(
                                color: hexToColor(blackColor),
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            )
                        ),
                      ],
                    ),
                  ) ,
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: hexToColor(dividerGreyColor),
                  ),
                  Container (
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Text('Account Number',
                            style: blackTextStyle.copyWith(
                                color: hexToColor(paymentTextColor),
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            )
                        ),
                        const SizedBox(width: 10,),
                        GestureDetector(
                            onTap: () => _copyToClipboard(text.data),
                            child: Icon(FontAwesomeIcons.solidClone, size: 12, color: hexToColor(blackColor),)
                        ),
                        const Spacer(),
                        text,
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: hexToColor(dividerGreyColor),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Text('Account Name',
                            style: blackTextStyle.copyWith(
                                color: hexToColor(paymentTextColor),
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            )
                        ),
                        const Spacer(),
                        Text(accountName!,
                            style: blackTextStyle.copyWith(
                                color: hexToColor(blackColor),
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            )
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: hexToColor(dividerGreyColor),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Text('Amount To Pay',
                            style: blackTextStyle.copyWith(
                                color: hexToColor(paymentTextColor),
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            )
                        ),
                        const Spacer(),
                        Text('N${formatter.format((widget.request.amount).abs())}',
                            style: blackTextStyle.copyWith(
                                color: hexToColor(blackColor),
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            )
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: hexToColor(dividerGreyColor),
                  ),
                  isLoading ? Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        strokeWidth: .5,
                        color: hexToColor(paymentBlueBackgroundColor),
                      ),
                    ),
                  ) : Center(
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            color: hexToColor(paymentBlueBackgroundColor)
                        ),
                        width: 328,
                        height: 48,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() => isLoading = true);
                            checkVABalance();
                          },
                          child: Text('Confirm Payment',
                              style: blackTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                              )
                          ),
                        )
                    ),
                  )
                ],
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: hexToColor(paymentIconBlueBackgroundColor)
                  ),
                  width: 180,
                  height: 40,
                  child: MaterialButton(
                      onPressed: () => Navigator.pop(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.arrowLeft, size: 12, color: hexToColor(paymentBlueBackgroundColor)),
                          const SizedBox(width: 7),
                          Text('Cancel Transaction',
                              style: blackTextStyle.copyWith(
                                  color: hexToColor(paymentBlueBackgroundColor),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400
                              )
                          ),
                        ],
                      )
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(text: 'secured by ',
                  style: blackTextStyle.copyWith(
                      color: hexToColor(paymentBlueBackgroundColor),
                      fontSize: 12,
                      fontWeight: FontWeight.w300
                  ),
                    children: [
                      TextSpan(
                        text: 'zainpay',
                        style: blackTextStyle.copyWith(
                          color: hexToColor(paymentBlueBackgroundColor),
                          fontSize: 12,
                          fontWeight: FontWeight.w500
                        )
                      )
                    ]
                  )
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
