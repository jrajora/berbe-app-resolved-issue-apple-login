import 'dart:convert';

import 'package:berbe/data/model/user_data.dart';

LoginMainModel loginMainModelFromMap(String str) => LoginMainModel.fromMap(json.decode(str));

String loginMainModelToMap(LoginMainModel data) => json.encode(data.toMap());

class LoginMainModel {
  LoginMainModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final UserData? data;

  factory LoginMainModel.fromMap(Map<String, dynamic> json) => LoginMainModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : UserData.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data == null ? null : data!.toMap(),
  };
}
