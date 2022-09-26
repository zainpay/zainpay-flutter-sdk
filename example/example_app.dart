import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zainpay/core/zainpay.dart';
import 'package:zainpay/models/response/payment_response.dart';

class TestApp extends StatefulWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final narrationController = TextEditingController();
  final publicKeyController = TextEditingController();
  final encryptionKeyController = TextEditingController();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final Random _rnd = Random();
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  String getPublicKey() => "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3phaW5wYXkubmciLCJpYXQiOjE2NDU3ODY3MzcsImlkIjozNzkwYjE5OC05ZGQ1LTQ5YjAtOWQ4Zi0yZjc0YzViOWUyNGEsIm5hbWUiOnRlc3QsInJvbGUiOnRlc3QsInNlY3JldEtleSI6eVpDRE1hWEpic3Nka3ZYbmlzc1B0c3Y0fQ.gNwiA_PK6IOmaprSLvQom_xYjAMP84SL-iADLJTlLms";
  String getZainBoxCode() => "THbfnDvK5o";

  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))
      ));

  Future<void> showLoading(String message) async => showDialog(
      context: context, barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        content: Container(
          margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
          width: double.infinity,
          height: 50,
          child: Text(message),
        ),
      )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zainpay"),
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: amountController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(hintText: "Amount"),
                  // validator: (value) => value!.isNotEmpty ? null : "Amount is required",
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: fullNameController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: phoneNumberController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: narrationController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Narration",
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: ElevatedButton(
                  onPressed: _onPressed,
                  child: const Text(
                    "Make Payment",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onPressed() {
    if (formKey.currentState!.validate()) {
      _handlePaymentInitialization();
    }
  }

  _handlePaymentInitialization() async {

    final Zainpay zainpay = Zainpay(
        context: context,
        fullName: fullNameController.text,
        email: emailController.text,
        publicKey: getPublicKey(),
        callBackUrl: "https://zainpay.ng/success",
        mobileNumber: phoneNumberController.text,
        zainboxCode: getZainBoxCode(),
        transactionRef: getRandomString(12),
        amount: amountController.text,
        isTest: true
    );

    final PaymentResponse? response = await zainpay.charge();

    if (response != null) {
      debugPrint("${response.toJson()}");
    } else {
      debugPrint("No Response");
    }
  }

}

