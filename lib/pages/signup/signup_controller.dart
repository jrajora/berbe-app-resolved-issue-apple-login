import 'dart:ui';

import 'package:berbe/apiservice/api_service.dart';
import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:berbe/data/model/common_response.dart';
import 'package:berbe/pages/signup/bottomsheet/verify_email_bottom_sheet.dart';
import 'package:berbe/routes/app_pages.dart';
import 'package:berbe/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';

class SignUpController extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final confirmPassController = TextEditingController().obs;

  final isCheckTerm = false.obs;

  changeFlagTerm() {
    isCheckTerm.value = !isCheckTerm.value;
  }

  callSignUpApi() {
    if (checkString(emailController.value.text.toString().trim())) {
      showSnackBar(Get.context!, 'msg_enter_email'.tr);
    } else if (!isValidEmail(emailController.value.text.toString().trim())) {
      showSnackBar(Get.context!, 'msg_enter_valid_email'.tr);
    } else if (checkString(passwordController.value.text.toString().trim())) {
      showSnackBar(Get.context!, 'msg_enter_password'.tr);
    } else if (passwordController.value.text.toString().trim().length < 8) {
      showSnackBar(Get.context!, 'msg_password_limit'.tr);
    } else if (passwordController.value.text.toString().trim().length > 15) {
      showSnackBar(Get.context!, 'msg_password_max_limit'.tr);
    } else if (checkString(
        confirmPassController.value.text.toString().trim())) {
      showSnackBar(Get.context!, 'msg_enter_confirm_password'.tr);
    } else if (passwordController.value.text.toString().trim() !=
        confirmPassController.value.text.toString().trim()) {
      showSnackBar(Get.context!, 'msg_password_not_match'.tr);
    } else if (!isCheckTerm.value) {
      showSnackBar(Get.context!, 'msg_accept_terms_condition'.tr);
    } else {
      checkConnectivity().then((value) {
        var params = <String, String>{
          'email': emailController.value.text.toString().trim(),
          'password': passwordController.value.text.toString().trim(),
          'confirm_password':
              confirmPassController.value.text.toString().trim(),
        };

        openAndCloseLoadingDialog(true);
        ApiService.callPostApi(ApiService.register, params, Get.context, null)
            .then((value) {
          if (value == null) {
            showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
          } else {
            openAndCloseLoadingDialog(false);
            CommonResponse commonResponse = CommonResponse.fromMap(value);
            if (commonResponse.status) {
              successSignup();
              logGoogleAnalyticsEvent('register', {});
            } else {
              showSnackBar(Get.context!, commonResponse.message);
            }
          }
        });
      });
    }
  }

  successSignup() {
    Get.bottomSheet(
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: VerifyEmailBottomSheet(
            title: 'lbl_congratulations'.tr,
            messageWidget: Get.locale?.languageCode == 'en'
                ? RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'You can now sign in and start using Berbe.',
                          style: AppText.textRegular),
                    ])).marginOnly(top: size_20)
                : Text(
                    'msg_verify_email'.tr,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: AppText.textRegular,
                  ),
            onDoneClick: () {
              //Todo: Redirect to Profile Complete screen
              Get.offAllNamed(Routes.LOGIN);
            },
          ),
        ),
        isDismissible: false,
        enableDrag: false);
  }
}
