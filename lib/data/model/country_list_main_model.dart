import 'dart:convert';

CountryListMainModel countryListMainModelFromMap(String str) =>
    CountryListMainModel.fromMap(json.decode(str));

String countryListMainModelToMap(CountryListMainModel data) =>
    json.encode(data.toMap());

class CountryListMainModel {
  CountryListMainModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final List<CountryListData> data;

  factory CountryListMainModel.fromMap(Map<String, dynamic> json) =>
      CountryListMainModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<CountryListData>.from(
                json["data"].map((x) => CountryListData.fromMap(x))),
      );

  Map<String, dynamic> toMap() =>
      {"status": status, "message": message, "data": data};
}

class CountryListData {
  CountryListData({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory CountryListData.fromMap(Map<String, dynamic> json) => CountryListData(
        id: json["id"].toString(),
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
