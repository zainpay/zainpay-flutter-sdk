class Utils {
  static String getBaseUrl(final bool isTest) =>
      isTest ? sandboxBaseURL : liveBaseURL;

  static const sandboxBaseURL = "https://sandbox.zainpay.ng";
  static const liveBaseURL = "https://api.zainpay.ng";

  // Card payment endpoints
  static const cardBaseURL = "zainbox/card";
  static const initializePaymentUrl = "$cardBaseURL/initialize/payment";
  static const cardPaymentStatusUrl = "$cardBaseURL/payment/status";
  static const cardPaymentReconciliationUrl =
      "$cardBaseURL/payment/reconciliation";

  // Card tokenization endpoints
  static const cardTokenizationBaseURL = "card/tokenization";
  static const tokenizeCardUrl = "$cardTokenizationBaseURL/tokenize";
  static const chargeTokenizedCardUrl = "$cardTokenizationBaseURL/charge";
  static const removeTokenizedCardUrl = "$cardTokenizationBaseURL/remove";

  // Virtual account endpoints
  static const createVirtualAccountUrl = "virtual-account/create/request";
  static const virtualAccountBalanceUrl = "virtual-account/wallet/balance";
  static const transactionVerificationUrl =
      "virtual-account/wallet/transaction/verify";

  // Webhook endpoints
  static const webhookEventsUrl = "webhook/events";
  static const webhookLogsUrl = "webhook/logs";

  // Status codes
  static const statusSuccess = "00";
  static const statusPending = "01";
  static const statusFailed = "02";
  static const statusInvalidRequest = "03";
  static const statusInvalidTransaction = "04";
  static const statusInsufficientFunds = "05";
  static const statusSystemError = "06";
  static const statusDuplicateTransaction = "07";

  // Status code messages
  static String getStatusMessage(String code) {
    switch (code) {
      case statusSuccess:
        return "Success";
      case statusPending:
        return "Pending";
      case statusFailed:
        return "Failed";
      case statusInvalidRequest:
        return "Invalid request";
      case statusInvalidTransaction:
        return "Invalid transaction";
      case statusInsufficientFunds:
        return "Insufficient funds";
      case statusSystemError:
        return "System error";
      case statusDuplicateTransaction:
        return "Duplicate transaction";
      default:
        return "Unknown status";
    }
  }
}
