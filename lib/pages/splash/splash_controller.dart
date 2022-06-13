import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:berbe/apiservice/api_service.dart';
import 'package:berbe/data/model/init_model.dart';
import 'package:berbe/data/model/user_data.dart';
import 'package:berbe/main.dart';
import 'package:berbe/routes/app_pages.dart';
import 'package:berbe/utils/storage_utils.dart';
import 'package:berbe/utils/string_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    StorageUtil.getData(StorageUtil.keyLanguageCode).then((value) {
      String? languageCode;
      if (value == null) {
        /*if (Get.deviceLocale == null) {
          languageCode = 'en';
          Get.updateLocale(Locale(languageCode));
        } else {
          String code = Get.deviceLocale?.languageCode ?? "en";
          bool isLanguageFound = false;
          for (LanguageModel data in listLangNameLocale) {
            if (data.langLocal.languageCode == code) {
             languageCode = data.langLocal.languageCode;
              Get.updateLocale(data.langLocal);
              saveLanguageData(data.langLocal.languageCode,
                  data.langLocal.countryCode ?? "", data.languageName);
              isLanguageFound = true;
              break;
            }
          }

          if (!isLanguageFound) {
            languageCode = listLangNameLocale[0].langLocal.languageCode;
            Get.updateLocale(listLangNameLocale[0].langLocal);
            saveLanguageData(
                listLangNameLocale[0].langLocal.languageCode,
                listLangNameLocale[0].langLocal.countryCode ?? "",
                listLangNameLocale[0].languageName);
          }
        }*/
        languageCode = 'en';
        Get.updateLocale(Locale(languageCode));
      } else {
        languageCode = value;
        Get.updateLocale(Locale(languageCode ?? "en"));
      }
      logGoogleAnalyticsEvent(
          'language', {'language_code': languageCode ?? "en"});
    });
    callInitApi();
  }

  Future<void> callInitApi() async {
    checkConnectivity().then((value) {
      if (value) {
        PackageInfo.fromPlatform().then((value) {
          String platform = "";
          if (GetPlatform.isAndroid) {
            platform = ANDROID_CUSTOMER;
          } else if (GetPlatform.isIOS) {
            platform = IOS_CUSTOMER;
          } else {
            platform = ANDROID_CUSTOMER;
          }
          String version =
              GetPlatform.isAndroid ? value.buildNumber : value.version;
          // String endPoint = "${ApiService.init}/$platform/$version";
          String endPoint = "${ApiService.init}/$platform/1.0.7";

          ApiService.callGetApi(endPoint, Get.context, null).then((value) {
            InitModel initModel = InitModel.fromMap(value!);
            if (initModel.status) {
              StorageUtil.setData(
                  StorageUtil.keyInitData, jsonEncode(initModel.toMap()));
              redirectToNextScreen();
            } else {
              showAppUpdateMaintenanceDialog(
                  defaultStringValue(initModel.update, "0"),
                  defaultStringValue(initModel.message, ""));
            }
          });
        });
      }
    });
  }

  void redirectToNextScreen() {
    /*StorageUtil.getData(StorageUtil.keyLoginData).then((value) {
      print(value);
      Timer(const Duration(seconds: 3), () {
        if (value == null || value.toString().isEmpty) {
          Get.offNamed(Routes.LOGIN);
        } else {
          Get.offAllNamed(Routes.DASHBOARD);
        }
      });
    });*/

    StorageUtil.getData(StorageUtil.keyLoginData).then((value) {
      Timer(const Duration(seconds: 1), () {
        if (value == null || value.toString().isEmpty) {
          Get.offNamed(Routes.LOGIN);
        } else {
          UserData userData = UserData.fromMap(jsonDecode(value));
          if (checkString(userData.name)) {
            Get.offAllNamed(Routes.MY_PROFILE, arguments: {'for': 'singup'});
          } else {
            Get.offAllNamed(Routes.DASHBOARD);
          }
          // Get.offAllNamed(Routes.DASHBOARD);-
        }
      });
    });
  }

  showAppUpdateMaintenanceDialog(String updateFlag, String message) {
    String positiveText = "";
    String negativeText = "";

    String androidAppID = "com.app.berbe";
    String iosAppID = "488928328";

    Widget content = Text(message);
    Widget title = const Text('Berbe');

    if (updateFlag == "0") {
      positiveText = 'lbl_update_app'.tr;
      negativeText = 'lbl_not_now'.tr;
    } else if (updateFlag == "1") {
      positiveText = 'lbl_update_app'.tr;
      negativeText = "";
    } else {
      positiveText = 'lbl_ok'.tr;
      negativeText = "";
    }
    final actions = updateFlag == "0"
        ? <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
                redirectToNextScreen();
              },
              child: Text(negativeText.toUpperCase()),
            ),
            TextButton(
              onPressed: () {
                //TODO : Redirect for update
                if (Platform.isAndroid) {
                  //TODO: Close app
                  SystemNavigator.pop();
                }
                LaunchReview.launch(
                    androidAppId: androidAppID, iOSAppId: iosAppID);
              },
              child: Text(positiveText.toUpperCase()),
            ),
          ]
        : <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
                if (Platform.isAndroid) {
                  //TODO: Close app
                  SystemNavigator.pop();
                }
                if (updateFlag == "1") {
                  //TODO : Redirect for update
                  LaunchReview.launch(
                      androidAppId: androidAppID, iOSAppId: iosAppID);
                }
              },
              child: Text(positiveText.toUpperCase()),
            ),
          ];
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
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
}
