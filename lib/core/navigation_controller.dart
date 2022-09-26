import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:zainpay/core/transaction_callback.dart';
import 'package:zainpay/models/response/init_payment_response.dart';
import 'package:zainpay/view/inapp_browser.dart';

import '../models/request/standard_request.dart';

class NavigationController {

  final TransactionCallBack _callBack;

  NavigationController(this._callBack);

  /// Initiates initial transaction to get web url
  startTransaction(final StandardRequest request) async {
    try {
      final InitPaymentResponse? initPaymentResponse =
      await request.initializePayment(request.publicKey);
      if (initPaymentResponse?.status == "200 OK") {
      openBrowser(initPaymentResponse?.data ?? "", request.callBackUrl);
      }
    } catch (error) {
      rethrow;
    }
  }

  /// Opens browser with URL returned from startTransaction()
  openBrowser(final String url, final String redirectUrl, [final bool isTestMode = false]) async {
    final ZainpayInAppBrowser browser = ZainpayInAppBrowser(callBack: _callBack);

    var options = InAppBrowserClassOptions(
      crossPlatform: InAppBrowserOptions(
          hideUrlBar: true,
        hideToolbarTop: true,
      ),
      inAppWebViewGroupOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
          clearCache: true
        ),
      ),
    );

    await browser.openUrlRequest(
        urlRequest: URLRequest(url: Uri.parse(url)), options: options);
  }
}