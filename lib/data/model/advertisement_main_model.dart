import 'dart:convert';

AdvertisementMainModel advertisementMainModelFromMap(String str) =>
    AdvertisementMainModel.fromMap(json.decode(str));

String advertisementMainModelToMap(AdvertisementMainModel data) =>
    json.encode(data.toMap());

class AdvertisementMainModel {
  AdvertisementMainModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final List<AdvertisementData> data;

  factory AdvertisementMainModel.fromMap(Map<String, dynamic> json) =>
      AdvertisementMainModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<AdvertisementData>.from(
                json["data"].map((x) => AdvertisementData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class AdvertisementData {
  AdvertisementData({
    this.id,
    this.countryId,
    this.title,
    this.link,
    this.image,
    this.description,
    this.deletedAt,
  });

  String? id;
  String? countryId;
  String? title;
  String? link;
  String? image;
  String? description;
  String? deletedAt;

  factory AdvertisementData.fromMap(Map<String, dynamic> json) =>
      AdvertisementData(
        id: json["id"].toString(),
        countryId: json["country_id"],
        title: json["title"],
        link: json["link"],
        image: json["image"],
        description: json["description"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "country_id": countryId,
        "title": title,
        "link": link,
        "image": image,
        "description": description,
        "deleted_at": deletedAt,
      };
}
