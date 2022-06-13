import 'dart:ui';

import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:berbe/data/model/common_response.dart';
import 'package:berbe/pages/signup/bottomsheet/verify_email_bottom_sheet.dart';
import 'package:berbe/routes/app_pages.dart';
import 'package:berbe/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../apiservice/api_service.dart';
import '../../main.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController().obs;
  final isEmail = false.obs;

  checkEmailValidation() {
    isEmail.value = isValidEmail(emailController.value.text.toString().trim());
  }

  callForgotPassApi() {
    checkConnectivity().then((value) {
      if (checkString(emailController.value.text.toString().trim())) {
        showSnackBar(Get.context!, 'msg_enter_email'.tr);
      } else if (!isEmail.value) {
        showSnackBar(Get.context!, 'msg_enter_valid_email'.tr);
      } else {
        var params = <String, String>{
          'email': emailController.value.text.toString().trim(),
        };
        openAndCloseLoadingDialog(true);
        ApiService.callPostApi(
                ApiService.forgotPassword, params, Get.context, null)
            .then((value) {
          if (value == null) {
            showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
          } else {
            openAndCloseLoadingDialog(false);
            CommonResponse commonResponse = CommonResponse.fromMap(value);
            if (commonResponse.status) {
              emailController.value = TextEditingController();
              successForgotPass();
            } else {
              showSnackBar(Get.context!, commonResponse.message);
            }
            // showSnackBar(Get.context!, commonResponse.message);
          }
        });
      }
    });
  }

  successForgotPass() {
    Get.bottomSheet(
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: VerifyEmailBottomSheet(
            title: 'lbl_reset_password'.tr,
            messageWidget:  Get.locale?.languageCode == 'en'
                ? RichText(
                softWrap: true,
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text:
                      'We have sent an reset password link to your email. If you do not receive an email, ',
                      style: AppText.textRegular),
                  TextSpan(
                      text: 'please check your spam folder',
                      style: AppText.textBold.copyWith(color: Colors.red)),
                  TextSpan(
                      text:
                      '. If you still do not receive an email, please contact support at info@berbe.net .',
                      style: AppText.textRegular),
                ])).marginOnly(top: size_20)
                : Text(
              'msg_reset_password'.tr,
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
