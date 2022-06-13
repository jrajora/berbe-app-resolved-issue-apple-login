import 'dart:async';
import 'dart:ui';

import 'package:berbe/apiservice/api_service.dart';
import 'package:berbe/data/model/advertisement_main_model.dart';
import 'package:berbe/main.dart';
import 'package:berbe/pages/searchDetails/more_info_details_bottom_sheet.dart';
import 'package:berbe/pages/searchDetails/search_data_main_model.dart';
import 'package:berbe/routes/app_pages.dart';
import 'package:berbe/utils/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchDetailsController extends GetxController {
  final travelFromId = "".obs;
  final travelToId = "".obs;
  final travelFromCityName = "".obs;
  final travelToCityName = "".obs;
  final vaccinatedValue = "".obs;
  final isApiCall = true.obs;
  final isSuccessResp = true.obs;
  final searchData = SearchData().obs;
  final isAdAvailable = false.obs;
  final advertiseList = <AdvertisementData>[].obs;
  final isVaccinated = true.obs; // jignesh

  final currentPage = 0.obs;
  final pageController = PageController(
    initialPage: 0,
  ).obs;
  Timer? timerPage;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments != null) {
      travelFromId.value = Get.arguments["travel_from"] ?? "";
      travelToId.value = Get.arguments["travel_to"] ?? "";
      travelFromCityName.value = Get.arguments["travel_from_city"] ?? "";
      travelToCityName.value = Get.arguments["travel_to_city"] ?? "";
      vaccinatedValue.value = Get.arguments["vaccinated"] ?? "";

      getSearchRules();
    }
  }

  getSearchRules() {
    checkConnectivity().then((connectivity) async {
      if (connectivity) {
        var params = <String, dynamic>{
          'travel_from': travelFromId.value,
          'travel_to': travelToId.value,
          'vaccinated': vaccinatedValue.value,
        };

        params.addAll(await DeviceInfo.instance.getDeviceInfo());

        ApiService.callPostApi(ApiService.search, params, Get.context, () {
          isApiCall.value = false;
          isSuccessResp.value = false;
        }).then((response) {
          isApiCall.value = false;
          if (response == null) {
            isSuccessResp.value = false;
            showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
          } else {
            SearchDataMainModel responseData =
                SearchDataMainModel.fromMap(response);
            if (responseData.status) {
              searchData.value = responseData.data ?? SearchData();
            } else {
              isSuccessResp.value = false;
              // showSnackBar(Get.context!, responseData.message);
            }
          }
          getAdvertisement();
        });
      }
    });
  }

  getAdvertisement() {
    checkConnectivity().then((connectivity) {
      if (connectivity) {
        var params = <String, String>{
          'country_travelling_to': travelToId.value,
          'country_travelling_from': travelFromId.value,
        };

        ApiService.callPostApi(
                ApiService.advertisement, params, Get.context, null)
            .then((value) {
          if (value == null) {
            showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
          } else {
            AdvertisementMainModel responseModel =
                AdvertisementMainModel.fromMap(value);
            if (responseModel.status) {
              List<AdvertisementData> dataList = [];
              if (responseModel.data.isNotEmpty) {
                for (AdvertisementData data in responseModel.data) {
                  if ((data.title ?? "").toLowerCase() != "business api") {
                    if ((data.title ?? "").toLowerCase() == "covid") {
                      dataList.insert(0, data);
                    } else {
                      dataList.add(data);
                    }
                  }
                }
              }
              advertiseList.value = dataList;
              changePageAutomatically();
            }
          }
        });
      }
    });
  }

  changePageAutomatically() {
    if (advertiseList.isNotEmpty) {
      timerPage = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (currentPage.value == (advertiseList.length - 1)) {
          currentPage.value = 0;
        } else {
          currentPage.value = currentPage.value + 1;
        }

        pageController.value.animateToPage(
          currentPage.value,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      });
    }
  }

  void changeFlag(bool value) {
    isVaccinated.value = value;
    searchRules();
  }

  void searchRules() {
    if (Get.arguments != null) {
      travelFromId.value = Get.arguments["travel_from"] ?? "";
      travelToId.value = Get.arguments["travel_to"] ?? "";
      travelFromCityName.value = Get.arguments["travel_from_city"] ?? "";
      travelToCityName.value = Get.arguments["travel_to_city"] ?? "";
      vaccinatedValue.value = isVaccinated.value ? '1' : '0';
      getSearchRules();
    }
  }

  showMoreInfoBottomSheet() {
    Get.bottomSheet(
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: MoreInfoDetailsBottomSheet(
            onDoneClick: () {},
          ),
        ),
        isDismissible: true,
        enableDrag: true);
  }

  redirectToMoreInfo() {
    Get.toNamed(Routes.MORE_INFO, arguments: {
      'travel_from_city': travelFromCityName.value,
      'travel_to_city': travelToCityName.value,
      'more_rules': searchData.value.rulesCriteriaDeparture
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    print("object : onClose");
    super.onClose();

    timerPage?.cancel();
    pageController.close();
  }
}
