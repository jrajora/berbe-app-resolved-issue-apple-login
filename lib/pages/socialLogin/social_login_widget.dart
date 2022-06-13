import 'dart:io';

import 'package:berbe/constants/app_images.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'social_login_controller.dart';

class SocialLoginWidget extends GetView<SocialLoginController> {
  const SocialLoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialButton(
            icon: icFacebookBtnLogo,
            onClick: () {
              controller.signInWithFacebook();
            }),
        const SizedBox(
          width: size_20,
        ),
        _socialButton(
            icon: icGoogleBtnLogo,
            onClick: () {
              controller.signInWithGoogle();
            }),
        const SizedBox(
          width: size_20,
        ),
        _socialButton(
            icon: icTwitterBtnLogo,
            onClick: () {
              controller.signInWithTwitter();
            }),
        const SizedBox(
          width: size_20,
        ),
        _socialButton(
            icon: icAppleBtnLogo,
            onClick: () async {
              if (Platform.isIOS) {
                controller.appleLoginWithApple();
              } else {
                final dynamic appleLogin =
                    await Get.toNamed(Routes.APPLE_LOGIN);
                if (appleLogin != null) {
                  controller.callLoginApi(
                      appleLogin["name"],
                      appleLogin["email"],
                      appleLogin["type"],
                      appleLogin["type_id"],
                      appleLogin["type_id"]);
                }
              }
            }),
      ],
    );
  }

  Widget _socialButton({required String icon, required Function() onClick}) {
    return GestureDetector(
      child: Container(
          width: size_60,
          height: size_60,
          padding: const EdgeInsets.all(size_10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size_30)),
          child: Image.asset(
            icon,
            fit: BoxFit.cover,
          )),
      onTap: onClick,
    );
  }
}
