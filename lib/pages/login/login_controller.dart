import 'dart:convert';

import 'package:berbe/pages/login/login_main_model.dart';
import 'package:berbe/routes/app_pages.dart';
import 'package:berbe/utils/device_utils.dart';
import 'package:berbe/utils/storage_utils.dart';
import 'package:berbe/utils/string_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../apiservice/api_service.dart';
import '../../main.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final isEmail = false.obs;

  checkEmailValidation() {
    isEmail.value = isValidEmail(emailController.value.text.toString().trim());
  }

  callLoginApi() async {
    checkConnectivity().then((value) {
      if (checkString(emailController.value.text.toString().trim())) {
        showSnackBar(Get.context!, 'msg_enter_email'.tr);
      } else if (!isEmail.value) {
        showSnackBar(Get.context!, 'msg_enter_valid_email'.tr);
      } else if (checkString(passwordController.value.text.toString().trim())) {
        showSnackBar(Get.context!, 'msg_enter_password'.tr);
      } else {
        FirebaseMessaging.instance.getToken().then((deviceToken) async {
          if (deviceToken != null) {
            Map<String, dynamic> params = {
              'email': emailController.value.text.toString().trim(),
              'password': passwordController.value.text.toString().trim(),
              'device_token': deviceToken,
            };

            params.addAll(await DeviceInfo.instance.getDeviceInfo());

            openAndCloseLoadingDialog(true);
            ApiService.callPostApi(ApiService.login, params, Get.context, null)
                .then((value) {
              if (value == null) {
                showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
              } else {
                openAndCloseLoadingDialog(false);
                LoginMainModel userDataModel = LoginMainModel.fromMap(value);
                if (userDataModel.status) {
                  if (userDataModel.data == null) {
                    showSnackBar(Get.context!, userDataModel.message);
                  } else {
                    StorageUtil.setData(
                        StorageUtil.keyToken, userDataModel.data!.token);
                    StorageUtil.setData(StorageUtil.keyLoginData,
                        jsonEncode(userDataModel.data!.toMap()));

                    if (checkString(userDataModel.data?.name)) {
                      Get.offAllNamed(Routes.MY_PROFILE,
                          arguments: {'for': 'singup'});
                    } else {
                      Get.offAllNamed(Routes.DASHBOARD);
                    }
                  }
                  logGoogleAnalyticsEvent('login', {});
                } else {
                  showSnackBar(Get.context!, userDataModel.message);
                }
              }
            });
          }
        });
      }
    });
  }
}
