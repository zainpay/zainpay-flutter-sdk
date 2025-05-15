import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../core/transaction_callback.dart';

class ZainpayInAppBrowser extends InAppBrowser {
  final TransactionCallBack callBack;
  var hasCompletedProcessing = false;
  var haveCallBacksBeenCalled = false;

  ZainpayInAppBrowser({required this.callBack});

  @override
  Future onBrowserCreated() async {
    // Browser created
  }

  @override
  Future onLoadStart(WebUri? url) async {
    if (url == null) return;

    final status = url.queryParameters["status"];
    final txRef = url.queryParameters["txnRef"];
    final id = url.queryParameters["txnRef"];
    final hasRedirected = status != null && txRef != null;
    if (hasRedirected) {
      hasCompletedProcessing = hasRedirected;
      _processResponse(url, status, txRef, id);
    }
  }

  _processResponse(WebUri url, String? status, String? txRef, String? id) {
    if ("success" == status) {
      callBack.onTransactionSuccess(id!, txRef!, url.toString());
    } else {
      callBack.onCancelled();
    }
    haveCallBacksBeenCalled = true;
    close();
  }

  @override
  Future onLoadStop(WebUri? url) async {}

  @override
  void onLoadError(Uri? url, int code, String message) {
    callBack.onTransactionError();
  }

  @override
  void onProgressChanged(int progress) {}

  @override
  void onExit() {
    if (!haveCallBacksBeenCalled) {
      callBack.onCancelled();
    }
  }
}
