import 'dart:convert';

import 'package:berbe/apiservice/api_service.dart';
import 'package:berbe/data/model/common_response.dart';
import 'package:berbe/data/model/user_data.dart';
import 'package:berbe/utils/storage_utils.dart';
import 'package:berbe/utils/string_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../main.dart';

class ChangePasswordController extends GetxController {
  final oldPassController = TextEditingController().obs;
  final newPassController = TextEditingController().obs;
  final confirmPassController = TextEditingController().obs;

  final userData = UserData().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    StorageUtil.getData(StorageUtil.keyLoginData).then((storageData) {
      if (storageData != null) {
        userData.value = UserData.fromMap(jsonDecode(storageData));
      }
    });
  }

  callChangePassApi() {
    if (checkString(oldPassController.value.text.toString().trim()) && userData.value.hasPassword! ) {
      showSnackBar(Get.context!, 'msg_enter_old_password'.tr);
    } else if (checkString(newPassController.value.text.toString().trim())) {
      showSnackBar(Get.context!, 'msg_enter_new_password'.tr);
    } else if (newPassController.value.text.toString().trim().length < 8) {
      showSnackBar(Get.context!, 'msg_new_password_limit'.tr);
    } else if (checkString(
        confirmPassController.value.text.toString().trim())) {
      showSnackBar(Get.context!, 'msg_enter_confirm_password'.tr);
    } else if (confirmPassController.value.text.toString().trim().length < 8) {
      showSnackBar(Get.context!, 'msg_confirm_password_limit'.tr);
    } else if (newPassController.value.text.toString().trim() !=
        confirmPassController.value.text.toString().trim()) {
      showSnackBar(Get.context!, 'msg_password_not_match'.tr);
    } else {
      /*StorageUtil.getData(StorageUtil.keyLoginData).then((value) {
        if (value != null) {
          UserData userData = UserData.fromMap(jsonDecode(value));*/
      var params = <String, String>{
        'current_password': oldPassController.value.text.toString().trim(),
        'new_password': newPassController.value.text.toString().trim(),
        'confirm_password': confirmPassController.value.text.toString().trim(),
        // 'user_id': userData.id ?? ""
      };
      openAndCloseLoadingDialog(true);
      ApiService.callPostApi(
              ApiService.changePassword, params, Get.context, null)
          .then((value) {
        if (value == null) {
          showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
        } else {
          openAndCloseLoadingDialog(false);
          CommonResponse commonResponse = CommonResponse.fromMap(value);
          if (commonResponse.status) {
            oldPassController.value = TextEditingController();
            newPassController.value = TextEditingController();
            confirmPassController.value = TextEditingController();

            userData.value.hasPassword = true;
            StorageUtil.setData(StorageUtil.keyLoginData,
                jsonEncode(userData.value.toMap()));

            Get.back();
          }
          showSnackBar(Get.context!, commonResponse.message);
        }
      });
    }
    // });
    // Get.back();
  }
}
