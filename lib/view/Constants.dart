import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

// Colors
const String blackColor = "#0C0C0C";
const String dividerGreyColor = "#E6E6E6";
const String pendingColor = "#F7CE4D";
const String pendingDeliveryColor = "#5B5B5B";
const String failedColor = "#EB8481";
const String greenColor = "#02B133";
const String redColor = "#FC5D53";
const String darkRed = "#FC5D53";
const String textGreyColor = "#807F86";
const String paymentIconBlueBackgroundColor = "#E0EDFF";
const String paymentBlueBackgroundColor = "#006AFB";
const String textEmailColor = "#808080";
const String paymentCancelButtonColor = "#EAEEF3";
const String paymentTextColor = "#55586F";
var formatter = NumberFormat('#,###,###');
const paymentFontFamily = 'Airbnb Cereal App';

TextStyle blackTextStyle = TextStyle(
    fontFamily: paymentFontFamily,
    color: hexToColor(blackColor),
    fontWeight: FontWeight.w600,
    fontSize: 18
);

Color hexToColor(String code) => Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);

void showNotification({required String message, required bool error}) {
  showSimpleNotification(
    Container(
      height: 50,
      width: 328,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: error ? hexToColor(redColor) : hexToColor(greenColor),
          borderRadius: BorderRadius.circular(4.0)
      ),
      child: Row(
        children: [
          error ? const Icon(FontAwesomeIcons.xmark, size: 10, color: Colors.white,)
              : const Icon(FontAwesomeIcons.checkDouble, size: 10, color: Colors.white,),
          const SizedBox(width: 18,),
          Center(
            child: Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: blackTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
        ],
      ),
    ),
    background: Colors.white,
    elevation: 0,
    duration: const Duration(seconds: 3),
  );
}

void showToast({required String message}) {
  showSimpleNotification(
      Container(
        margin: const EdgeInsets.only(bottom: 40, left: 120, right: 120),
        height: 40,
        width: 30,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: hexToColor(paymentIconBlueBackgroundColor),
            borderRadius: BorderRadius.circular(36)
        ),
        child: Center(
          child: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: blackTextStyle.copyWith(
                color: hexToColor(paymentBlueBackgroundColor),
                fontSize: 14,
                fontWeight: FontWeight.w400
            ),),
        ),
      ),
      background: Colors.white54.withAlpha(25),
      elevation: 0,
      position: NotificationPosition.bottom
  );
}
