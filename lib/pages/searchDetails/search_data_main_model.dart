import 'dart:convert';

SearchDataMainModel searchDataMainModelFromMap(String str) => SearchDataMainModel.fromMap(json.decode(str));

String searchDataMainModelToMap(SearchDataMainModel data) => json.encode(data.toMap());

class SearchDataMainModel {
  SearchDataMainModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final SearchData? data;

  factory SearchDataMainModel.fromMap(Map<String, dynamic> json) => SearchDataMainModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : SearchData.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data == null ? null : data!.toMap(),
  };
}

class SearchData {
  SearchData({
    this.requiredTestBeforeArrival,
    this.requiredTestOnArrival,
    this.testTimeBeforeArrival,
    this.quarantineRequired,
    this.additionalDocRequired,
    this.linkToSubmitDocument,
    this.minimumAgeForTestBeforeArrival,
    this.minimumAgeForTestAfterArrival,
    this.rulesCriteriaDeparture,
  });

  String? requiredTestBeforeArrival;
  String? requiredTestOnArrival;
  String? testTimeBeforeArrival;
  String? quarantineRequired;
  String? additionalDocRequired;
  String? linkToSubmitDocument;
  String? minimumAgeForTestBeforeArrival;
  String? minimumAgeForTestAfterArrival;
  String? rulesCriteriaDeparture;

  factory SearchData.fromMap(Map<String, dynamic> json) => SearchData(
    requiredTestBeforeArrival: json["required_test_before_arrival"],
    requiredTestOnArrival: json["required_test_on_arrival"],
    testTimeBeforeArrival: json["test_time_before_arrival"],
    quarantineRequired: json["quarantine_required"],
    additionalDocRequired: json["additional_doc_required"],
    linkToSubmitDocument: json["link_to_submit_document"],
    minimumAgeForTestBeforeArrival: json["minimum_age_for_test_before_arrival"],
    minimumAgeForTestAfterArrival: json["minimum_age_for_test_after_arrival"],
    rulesCriteriaDeparture: json["rules_criteria_departure"],
  );

  Map<String, dynamic> toMap() => {
    "required_test_before_arrival": requiredTestBeforeArrival,
    "required_test_on_arrival": requiredTestOnArrival,
    "test_time_before_arrival": testTimeBeforeArrival,
    "quarantine_required": quarantineRequired,
    "additional_doc_required": additionalDocRequired,
    "link_to_submit_document": linkToSubmitDocument,
    "minimum_age_for_test_before_arrival": minimumAgeForTestBeforeArrival,
    "minimum_age_for_test_after_arrival": minimumAgeForTestAfterArrival,
    "rules_criteria_departure": rulesCriteriaDeparture,
  };
}
