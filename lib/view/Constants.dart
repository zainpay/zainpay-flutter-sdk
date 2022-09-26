import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

const blackColor = "#0C0C0C";
const dividerGreyColor = "#E6E6E6";
const pendingColor = "#F7CE4D";
const pendingDeliveryColor = "#5B5B5B";
const failedColor = "#EB8481";
const greenColor = "#02B133";
const redColor = "#FC5D53";
const darkRed = "#FC5D53";
const textGreyColor = "#807F86";
const paymentIconBlueBackgroundColor = "#E0EDFF";
const paymentBlueBackgroundColor = "#006AFB";
const textEmailColor = "#808080";
const paymentCancelButtonColor = "#EAEEF3";
const paymentTextColor = "#55586F";
var formatter = NumberFormat('#,###,###');
const paymentFontFamily = 'Airbnb Cereal App';

TextStyle blackTextStyle = TextStyle(
    fontFamily: paymentFontFamily,
    color: hexToColor(blackColor),
    fontWeight: FontWeight.w600,
    fontSize: 18
);

Color hexToColor(String code) => Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);

void showNotification({required message, required error}) =>
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

void showToast({required message}){
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
      background: Colors.white54.withOpacity(0.1),
      elevation: 0,
      position:  NotificationPosition.bottom
  );
}