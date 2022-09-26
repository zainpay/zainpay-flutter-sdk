class PaymentInfo {

  String? code;
  PaymentInfoData? data;
  String? description;
  String? status;

  PaymentInfo({
    this.code,
    this.data,
    this.description,
    this.status
  });

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = PaymentInfoData.fromJson(json['data']);
    description = json['description'];
    status = json['status'];
  }

  /// Converts this instance to json
  Map<String, dynamic> toJson() => {
    'code' : code,
    'data' : data,
    'description' : description,
    'status' : status
  };
}


class PaymentInfoData {
  String? amount;
  String? emailAddress;
  String? failureCallBackUrl;

  PaymentInfoData({
    this.amount,
    this.emailAddress,
    this.failureCallBackUrl
  });

  PaymentInfoData.fromJson(Map<String, dynamic> data) {
    amount = data['amount'];
    emailAddress = data['emailAddress'];
    failureCallBackUrl = data['failureCallBackUrl'];
  }

  /// Converts this instance to json
  Map<String, dynamic> toJson() => {
    'amount' : amount,
    'emailAddress' : emailAddress,
    'failureCallBackUrl' : failureCallBackUrl
  };

}