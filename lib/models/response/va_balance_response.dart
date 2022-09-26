class VirtualAccountBalanceResponse {

  String? code;
  String? description;
  String? status;
  VirtualAccountBalanceDataResponse? data;

  VirtualAccountBalanceResponse({
    this.status,
    this.code,
    this.description,
    this.data
  });

  VirtualAccountBalanceResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    description = json["description"];
    code = json["code"];
    data = VirtualAccountBalanceDataResponse.fromJson(json["data"]);
  }

  /// Converts this instance to json
  Map<String, dynamic> toJson() => {
    "status": status,
    "description": description,
    "code": code,
    "data": data
  };
}

class VirtualAccountBalanceDataResponse{

  String? accountName;
  String? accountNumber;
  dynamic balanceAmount;
  String? transactionDate;

  VirtualAccountBalanceDataResponse({
   this.accountName,
    this.accountNumber,
    this.balanceAmount,
    this.transactionDate
  });

  VirtualAccountBalanceDataResponse.fromJson(Map<String, dynamic> data) {
    accountName = data["accountName"];
    accountNumber = data["accountNumber"];
    balanceAmount = data["balanceAmount"];
    transactionDate = data["transactionDate"];
  }

  Map<String, dynamic> toJson() => {
    "accountName": accountName,
    "accountNumber": accountNumber,
    "balanceAmount": balanceAmount,
    "transactionDate": transactionDate
  };

}