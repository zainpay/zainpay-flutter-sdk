/// Base response class for all Zainpay API responses
class BaseResponse {
  /// Response code
  final String? code;
  
  /// Response description
  final String? description;
  
  /// Response status
  final String? status;

  /// Creates a new base response
  BaseResponse({
    this.code,
    this.description,
    this.status,
  });

  /// Creates a base response from JSON
  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      code: json['code'],
      description: json['description'],
      status: json['status'],
    );
  }

  /// Converts this instance to a JSON map
  Map<String, dynamic> toJson() => {
    'code': code,
    'description': description,
    'status': status,
  };
}

/// Response for payment initialization
class InitPaymentResponse extends BaseResponse {
  /// Session ID for the payment
  final String? sessionId;
  
  /// Payment URL
  final String? data;

  /// Creates a new payment initialization response
  InitPaymentResponse({
    String? code,
    String? description,
    String? status,
    this.sessionId,
    this.data,
  }) : super(
    code: code,
    description: description,
    status: status,
  );

  /// Creates a payment initialization response from JSON
  factory InitPaymentResponse.fromJson(Map<String, dynamic> json) {
    String? sessionId;
    if (json["data"] != null && json["data"].toString().contains("e=")) {
      sessionId = json["data"].toString().split("e=")[1];
    }
    
    return InitPaymentResponse(
      code: json['code'],
      description: json['description'],
      status: json['status'],
      sessionId: sessionId,
      data: json['data'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'sessionId': sessionId,
    'data': data,
  };
}

/// Response for payment completion
class PaymentResponse extends BaseResponse {
  /// Payment data
  final PaymentData? data;

  /// Creates a new payment response
  PaymentResponse({
    String? code,
    String? description,
    String? status,
    this.data,
  }) : super(
    code: code,
    description: description,
    status: status,
  );

  /// Creates a payment response from JSON
  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      code: json['code'],
      description: json['description'],
      status: json['status'],
      data: json['data'] != null ? PaymentData.fromJson(json['data']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'data': data?.toJson(),
  };
}

/// Payment data included in payment response
class PaymentData {
  /// Callback URL
  final String? callBackUrl;
  
  /// Transaction reference
  final String? txnRef;

  /// Creates new payment data
  PaymentData({
    this.callBackUrl,
    this.txnRef,
  });

  /// Creates payment data from JSON
  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      callBackUrl: json['callBackUrl'],
      txnRef: json['txnRef'],
    );
  }

  /// Converts this instance to a JSON map
  Map<String, dynamic> toJson() => {
    'callBackUrl': callBackUrl,
    'txnRef': txnRef,
  };
}

/// Response for virtual account creation
class VirtualAccountResponse extends BaseResponse {
  /// Virtual account data
  final VirtualAccountData? data;

  /// Creates a new virtual account response
  VirtualAccountResponse({
    String? code,
    String? description,
    String? status,
    this.data,
  }) : super(
    code: code,
    description: description,
    status: status,
  );

  /// Creates a virtual account response from JSON
  factory VirtualAccountResponse.fromJson(Map<String, dynamic> json) {
    return VirtualAccountResponse(
      code: json['code'],
      description: json['description'],
      status: json['status'],
      data: json['data'] != null ? VirtualAccountData.fromJson(json['data']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'data': data?.toJson(),
  };
}

/// Virtual account data included in virtual account response
class VirtualAccountData {
  /// Account name
  final String? accountName;
  
  /// Account number
  final String? accountNumber;
  
  /// Bank name
  final String? bankName;
  
  /// Email address
  final String? email;

  /// Creates new virtual account data
  VirtualAccountData({
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.email,
  });

  /// Creates virtual account data from JSON
  factory VirtualAccountData.fromJson(Map<String, dynamic> json) {
    return VirtualAccountData(
      accountName: json['accountName'],
      accountNumber: json['accountNumber'],
      bankName: json['bankName'],
      email: json['email'],
    );
  }

  /// Converts this instance to a JSON map
  Map<String, dynamic> toJson() => {
    'accountName': accountName,
    'accountNumber': accountNumber,
    'bankName': bankName,
    'email': email,
  };
}

/// Response for virtual account balance check
class VirtualAccountBalanceResponse extends BaseResponse {
  /// Virtual account balance data
  final VirtualAccountBalanceData? data;

  /// Creates a new virtual account balance response
  VirtualAccountBalanceResponse({
    String? code,
    String? description,
    String? status,
    this.data,
  }) : super(
    code: code,
    description: description,
    status: status,
  );

  /// Creates a virtual account balance response from JSON
  factory VirtualAccountBalanceResponse.fromJson(Map<String, dynamic> json) {
    return VirtualAccountBalanceResponse(
      code: json['code'],
      description: json['description'],
      status: json['status'],
      data: json['data'] != null ? VirtualAccountBalanceData.fromJson(json['data']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'data': data?.toJson(),
  };
}

/// Virtual account balance data included in virtual account balance response
class VirtualAccountBalanceData {
  /// Account name
  final String? accountName;
  
  /// Account number
  final String? accountNumber;
  
  /// Balance amount
  final double? balanceAmount;
  
  /// Transaction date
  final String? transactionDate;

  /// Creates new virtual account balance data
  VirtualAccountBalanceData({
    this.accountName,
    this.accountNumber,
    this.balanceAmount,
    this.transactionDate,
  });

  /// Creates virtual account balance data from JSON
  factory VirtualAccountBalanceData.fromJson(Map<String, dynamic> json) {
    return VirtualAccountBalanceData(
      accountName: json['accountName'],
      accountNumber: json['accountNumber'],
      balanceAmount: json['balanceAmount'] is num ? (json['balanceAmount'] as num).toDouble() : null,
      transactionDate: json['transactionDate'],
    );
  }

  /// Converts this instance to a JSON map
  Map<String, dynamic> toJson() => {
    'accountName': accountName,
    'accountNumber': accountNumber,
    'balanceAmount': balanceAmount,
    'transactionDate': transactionDate,
  };
}
