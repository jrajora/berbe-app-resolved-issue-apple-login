import 'dart:convert';

CommonResponse commonResponseFromMap(String str) => CommonResponse.fromMap(json.decode(str));

String commonResponseToMap(CommonResponse data) => json.encode(data.toMap());

class CommonResponse {
  CommonResponse({
    required this.status,
    required this.message,
  });

  final bool status;
  final String message;

  factory CommonResponse.fromMap(Map<String, dynamic> json) => CommonResponse(
    status: json["status"] ?? false,
    message: json["message"] ?? "",
  );

  Map<String, dynamic> toMap() => {
    "status": status == status,
    "message": message == message,
  };
}
