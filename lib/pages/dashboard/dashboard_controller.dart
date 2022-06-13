import 'dart:async';
import 'dart:convert';

import 'package:berbe/apiservice/api_service.dart';
import 'package:berbe/data/model/advertisement_main_model.dart';
import 'package:berbe/data/model/common_response.dart';
import 'package:berbe/data/model/country_list_main_model.dart';
import 'package:berbe/data/model/user_data.dart';
import 'package:berbe/main.dart';
import 'package:berbe/pages/login/login_main_model.dart';
import 'package:berbe/routes/app_pages.dart';
import 'package:berbe/utils/storage_utils.dart';
import 'package:berbe/utils/string_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DashboardController extends GetxController {
  final isVaccinated = true.obs;
  final fromController = TextEditingController().obs;
  final toController = TextEditingController().obs;

  final scaffoldKey = GlobalKey<ScaffoldState>().obs;

  final isProfileOpen = false.obs;
  final isNotificationOpen = false.obs;
  final isLanguageOpen = false.obs;
  final isChangePassOpen = false.obs;

  final userData = UserData().obs;

  final isAdAvailable = false.obs;
  final objCovidAppAd = AdvertisementData().obs;
  final advertiseList = <AdvertisementData>[].obs;

  final countryList = <CountryListData>[].obs;
  final selectedCountryFrom = "".obs;
  final selectedCountryTo = "".obs;

  final isShowClearFrom = false.obs;
  final isShowClearTo = false.obs;

  final currentPage = 0.obs;
  final pageController = PageController(
    initialPage: 0,
  ).obs;
  Timer? timerPage;

  final appVersion = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    // getCovidAppBanner();
    getCountryList();
    getUserData();
    getAppVersion();
  }

  getUserData() {
    StorageUtil.getData(StorageUtil.keyLoginData).then((value) {
      if (value != null) {
        userData.value = UserData.fromMap(jsonDecode(value));
        checkConnectivity().then((connectivity) {
          if (connectivity) {
            ApiService.callGetApi(ApiService.getProfile, Get.context!, () {})
                .then((response) {
              if (response == null) {
                showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
              } else {
                LoginMainModel userDataModel = LoginMainModel.fromMap(response);
                if (userDataModel.status) {
                  StorageUtil.setData(StorageUtil.keyLoginData,
                      jsonEncode(userDataModel.data!.toMap()));
                  userData.value = userDataModel.data!;
                }
              }
            });
          }
        });
      }
    });
  }

  getCovidAppBanner() {
    checkConnectivity().then((connectivity) {
      if (connectivity) {
        openAndCloseLoadingDialog(true);
        ApiService.callGetApi(ApiService.banner, Get.context, null)
            .then((value) {
          openAndCloseLoadingDialog(false);
          if (value == null) {
            showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
          } else {
            AdvertisementMainModel responseModel =
                AdvertisementMainModel.fromMap(value);
            if (responseModel.status) {
              if (responseModel.data.isNotEmpty) {
                isAdAvailable.value = true;
                for (AdvertisementData data in responseModel.data) {
                  if ((data.title ?? "").toLowerCase() == "covid") {
                    objCovidAppAd.value = data;
                  }
                }
              }
            }
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
          // getCountryList();
        });
      }
    });
    // getCountryList();
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

  getCountryList() {
    checkConnectivity().then((connectivity) {
      if (connectivity) {
        ApiService.callGetApi(ApiService.countryList, Get.context, null)
            .then((value) {
          if (value == null) {
            showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
          } else {
            CountryListMainModel countryModel =
                CountryListMainModel.fromMap(value);
            if (countryModel.status) {
              countryList.value = countryModel.data;
            }
          }

          getCovidAppBanner();
        });
      }
    });
  }

  changeFlag(bool value) {
    isVaccinated.value = value;
  }

  void openDrawer() {
    scaffoldKey.value.currentState!.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.value.currentState!.openEndDrawer();
  }

  openProfile() {
    resetSelection();
    if (!isProfileOpen.value) {
      isProfileOpen.value = true;
    }
    Get.toNamed(Routes.MY_PROFILE, arguments: {'for': 'update'})?.then((value) {
      getUserData();
    });
  }

  openNotification() {
    resetSelection();
    if (!isNotificationOpen.value) {
      isNotificationOpen.value = true;
    }
    Get.toNamed(Routes.NOTIFICATION);
  }

  openLanguage() {
    resetSelection();
    if (!isLanguageOpen.value) {
      isLanguageOpen.value = true;
    }
    Get.toNamed(Routes.LANGUAGE)!.then((returnValue) {
      StorageUtil.getData(StorageUtil.keyLanguageCode).then((value) {
        /*print(value);
        Get.updateLocale(Locale(value ?? "en", ''));
        update();*/
        getCountryList();
      });
    });
  }

  openChangePass() {
    resetSelection();
    if (!isChangePassOpen.value) {
      isChangePassOpen.value = true;
    }
    Get.toNamed(Routes.CHANGE_PASS);
  }

  searchRules() {
    if (checkString(selectedCountryFrom.value)) {
      showSnackBar(Get.context!, 'msg_enter_traveling_from'.tr);
    } else if (checkString(selectedCountryTo.value)) {
      showSnackBar(Get.context!, 'msg_enter_traveling_to'.tr);
    } else if (selectedCountryFrom.value == selectedCountryTo.value) {
      showSnackBar(Get.context!, 'msg_same_country'.tr);
    } else {
      Get.toNamed(Routes.SEARCH_DETAILS, arguments: {
        'travel_from': selectedCountryFrom.value,
        'travel_to': selectedCountryTo.value,
        'travel_from_city': fromController.value.text.toString().trim(),
        'travel_to_city': toController.value.text.toString().trim(),
        'vaccinated': isVaccinated.value ? '1' : '0',
      });
      logGoogleAnalyticsEvent('search', {});
    }
  }

  resetSelection() {
    isProfileOpen.value = false;
    isNotificationOpen.value = false;
    isLanguageOpen.value = false;
    isChangePassOpen.value = false;
  }

  void showLogoutDialog() {
    Widget content = Text(
      'lbl_logout_msg'.tr,
      textAlign: TextAlign.start,
    );
    Widget title = Text(
      'lbl_logout'.tr,
      textAlign: TextAlign.start,
    );
    final actions = <Widget>[
      TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'lbl_cancel'.tr.toUpperCase(),
          textAlign: TextAlign.start,
        ),
      ),
      TextButton(
        onPressed: () {
          onLogout();
        },
        child: Text(
          'lbl_yes'.tr.toUpperCase(),
          textAlign: TextAlign.start,
        ),
      ),
    ];
    showDialog(
      context: Get.overlayContext!,
      builder: (dialogContext) {
        return GetPlatform.isIOS
            ? CupertinoAlertDialog(
                title: title,
                content: content,
                actions: actions,
              )
            : AlertDialog(
                title: title,
                content: content,
                actions: actions,
              );
      },
    );
  }

  void onLogout() {
    checkConnectivity().then((value) {
      if (value) {
        var params = <String, String>{};
        openAndCloseLoadingDialog(true);
        ApiService.callPostApi(ApiService.logout, params, Get.context, null)
            .then((value) {
          if (value != null) {
            openAndCloseLoadingDialog(false);
            CommonResponse response = CommonResponse.fromMap(value);
            if (response.status) {
              StorageUtil.clearLoginData();
              Get.offAllNamed(Routes.LOGIN);
            } else {
              showSnackBar(Get.context!, response.message);
            }
          }
        });
      }
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

  clearFromCountryData() {
    fromController.value.clear();
    selectedCountryFrom.value = "";
    isShowClearFrom.value = false;
  }

  clearToCountryData() {
    toController.value.clear();
    selectedCountryTo.value = "";
    isShowClearTo.value = false;
  }

  void getAppVersion() {
    PackageInfo.fromPlatform().then((packageInfo) {
      appVersion.value = packageInfo.version;
    });
  }
}
