class CreateVirtualAccountResponse {

  String? code;
  String? description;
  String? status;
  CreateVirtualAccountDataResponse? data;

  CreateVirtualAccountResponse({
    this.status,
    this.code,
    this.description,
    this.data
  });

  CreateVirtualAccountResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    description = json["description"];
    code = json["code"];
    data = CreateVirtualAccountDataResponse.fromJson(json["data"]);
  }

  /// Converts this instance to json
  Map<String, dynamic> toJson() => {
    "status": status,
    "description": description,
    "code": code,
    "data": data
  };
}

class CreateVirtualAccountDataResponse{

  String? accountName;
  String? accountNumber;
  String? bankName;
  String? email;

  CreateVirtualAccountDataResponse({
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.email
  });

  CreateVirtualAccountDataResponse.fromJson(Map<String, dynamic> data) {
    accountName = data["accountName"];
    accountNumber = data["accountNumber"];
    bankName = data["bankName"];
    email = data["email"];
  }

}