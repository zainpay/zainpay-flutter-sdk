class Utils {

  static String getBaseUrl(final bool isTest) => isTest ? sandboxBaseURL : liveBaseURL;

  static const sandboxBaseURL = "https://sandbox.zainpay.ng";
  static const liveBaseURL = "https://api.zainpay.ng";

  static const cardBaseURL = "zainbox/card";
  static const initializePaymentUrl = "$cardBaseURL/initialize/payment";

  static const createVirtualAccountUrl = "virtual-account/create/request";
  static const virtualAccountBalanceUrl = "virtual-account/wallet/balance";
  static const transactionVerificationUrl = "virtual-account/wallet/transaction/verify";

}