import 'dart:convert';

InitModel initModelFromMap(String str) => InitModel.fromMap(json.decode(str));

String initModelToMap(InitModel data) => json.encode(data.toMap());

class InitModel {
  InitModel(
      {required this.status, required this.update, required this.message});

  final bool status;
  final String update;
  final String message;

  factory InitModel.fromMap(Map<String, dynamic> json) => InitModel(
      status: json["status"] ?? false,
      update: json["update"] == null ? "" : json["update"].toString(),
      message: json["message"] ?? "");

  Map<String, dynamic> toMap() =>
      {"status": status, "update": update, "message": message};
}
