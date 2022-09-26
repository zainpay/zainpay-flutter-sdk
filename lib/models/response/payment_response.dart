class PaymentResponse {

  String? code;
  String? description;
  String? status;
  dynamic otpValidationDataResponse;

  PaymentResponse({
    this.code,
    this.description,
    this.status,
    this.otpValidationDataResponse
  });

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    status = json['status'];
    otpValidationDataResponse = OTPValidationDataResponse.fromJson(json['data']);
  }

  /// Converts this instance to json
  Map<String, dynamic> toJson() => {
    'code' : code,
    'description' : description,
    'status' : status,
    'data' : otpValidationDataResponse
  };
}

class OTPValidationDataResponse {

  String? callBackUrl;
  String? txnRef;

  OTPValidationDataResponse({
    this.callBackUrl,
    this.txnRef
  });

  OTPValidationDataResponse.fromJson(Map<String, dynamic> json) {
    callBackUrl = json['callBackUrl'];
    txnRef = json['txnRef'];
  }

  /// Converts this instance to json
  Map<String, dynamic> toJson() => {
    'callBackUrl' : callBackUrl,
    'txnRef' : txnRef
  };
}