class InitPaymentResponse {

  String? status;
  String? description;
  String? sessionId;
  String? code;
  String? data;

  InitPaymentResponse({
    this.status,
    this.sessionId,
    this.description,
    this.data,
    this.code
  });

  InitPaymentResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    description = json["description"];
    code = json["code"];
    sessionId = json["data"].toString().split("e=")[1];
    data = json["data"];
  }

  /// Converts this instance to json
  Map<String, dynamic> toJson() => {
      "status": status,
      "description": description,
      "code": code,
      "sessionId": sessionId,
      "data": data
    };
}