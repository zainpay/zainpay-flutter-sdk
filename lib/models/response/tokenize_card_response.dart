/// Response model for tokenizing a card
class TokenizeCardResponse {
  final String? status;
  final String? code;
  final String? description;
  final TokenizeCardData? data;

  /// Creates a new TokenizeCardResponse
  TokenizeCardResponse({
    this.status,
    this.code,
    this.description,
    this.data,
  });

  /// Creates a TokenizeCardResponse from JSON
  factory TokenizeCardResponse.fromJson(Map<String, dynamic> json) {
    return TokenizeCardResponse(
      status: json['status'],
      code: json['code'],
      description: json['description'],
      data: json['data'] != null ? TokenizeCardData.fromJson(json['data']) : null,
    );
  }

  /// Converts this instance to JSON
  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'description': description,
    'data': data?.toJson(),
  };

  /// Returns true if the tokenization was successful
  bool get isSuccessful => code == "00";
}

/// Data model for tokenized card
class TokenizeCardData {
  final String? token;
  final String? last4;
  final String? expiryMonth;
  final String? expiryYear;
  final String? brand;
  final String? cardHolderName;

  /// Creates a new TokenizeCardData
  TokenizeCardData({
    this.token,
    this.last4,
    this.expiryMonth,
    this.expiryYear,
    this.brand,
    this.cardHolderName,
  });

  /// Creates a TokenizeCardData from JSON
  factory TokenizeCardData.fromJson(Map<String, dynamic> json) {
    return TokenizeCardData(
      token: json['token'],
      last4: json['last4'],
      expiryMonth: json['expiryMonth'],
      expiryYear: json['expiryYear'],
      brand: json['brand'],
      cardHolderName: json['cardHolderName'],
    );
  }

  /// Converts this instance to JSON
  Map<String, dynamic> toJson() => {
    'token': token,
    'last4': last4,
    'expiryMonth': expiryMonth,
    'expiryYear': expiryYear,
    'brand': brand,
    'cardHolderName': cardHolderName,
  };
}
