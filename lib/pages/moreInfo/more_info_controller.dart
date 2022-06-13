import 'package:get/get.dart';

class MoreInfoController extends GetxController{
  final travelFromCityName = "".obs;
  final travelToCityName = "".obs;
  final stMoreRules = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments != null) {
    travelFromCityName.value = Get.arguments["travel_from_city"] ?? "";
      travelToCityName.value = Get.arguments["travel_to_city"] ?? "";
    stMoreRules.value = Get.arguments["more_rules"] ?? "";
    }
  }
}