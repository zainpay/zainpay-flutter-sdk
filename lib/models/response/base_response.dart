/// Base response model for API responses
class BaseResponse {
  final String? status;
  final String? code;
  final String? description;

  /// Creates a new BaseResponse
  BaseResponse({
    this.status,
    this.code,
    this.description,
  });

  /// Creates a BaseResponse from JSON
  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      status: json['status'],
      code: json['code'],
      description: json['description'],
    );
  }

  /// Converts this instance to JSON
  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'description': description,
  };

  /// Returns true if the response was successful
  bool get isSuccessful => code == "00";
}
