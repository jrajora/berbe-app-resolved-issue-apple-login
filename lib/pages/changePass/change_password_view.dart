import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_images.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:berbe/pages/changePass/change_password_controller.dart';
import 'package:berbe/widgets/scrollbehavior.dart';
import 'package:berbe/widgets/widget_background_container.dart';
import 'package:berbe/widgets/widget_common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                appBg,
              ),
              fit: BoxFit.fill)),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Container(
                  child: GestureDetector(
                    child: SvgPicture.asset(icBack),
                    onTap: () {
                      Get.back();
                    },
                  ),
                  margin: const EdgeInsetsDirectional.only(
                      start: paddingLeft, top: size_10),
                ),
              ),
              Expanded(
                  child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  padding: const EdgeInsetsDirectional.only(
                      start: paddingLeft,
                      end: paddingRight,
                      top: size_15,
                      bottom: size_20),
                  children: [
                    Container(
                      child: Center(
                        child: Image.asset(
                          logo,
                          width: 245.0,
                          height: 180.0,
                        ),
                      ),
                    ),
                    Text(
                      'lbl_change_password'.tr,
                      style: AppText.textBold
                          .copyWith(fontSize: size_30, color: colorWhite),
                      textAlign: TextAlign.center,
                    ).marginOnly(top: size_35),
                    Obx(() => controller.userData.value.hasPassword == true
                        ? WidgetCommonTextField(
                                textEditingController:
                                    controller.oldPassController.value,
                                inputDecoration: InputDecoration(
                                    hintText: 'hint_old_password'.tr,
                                    hintStyle: AppText.textRegular.copyWith(
                                        color: colorWhite.withOpacity(0.56))),
                                textStyle: AppText.textRegular.copyWith(
                                    fontSize: font_16,
                                    color: colorWhite.withOpacity(0.5)),
                                inputType: TextInputType.text,
                                isPasswordFiled: true,
                                isObscureText: true,
                                inputAction: TextInputAction.next)
                            .marginOnly(top: size_35)
                        : Container()),
                    Obx(() => WidgetCommonTextField(
                            textEditingController:
                                controller.newPassController.value,
                            inputDecoration: InputDecoration(
                                hintText: 'hint_new_password'.tr,
                                hintStyle: AppText.textRegular.copyWith(
                                    color: colorWhite.withOpacity(0.56))),
                            textStyle: AppText.textRegular.copyWith(
                                fontSize: font_16,
                                color: colorWhite.withOpacity(0.5)),
                            inputType: TextInputType.text,
                            isPasswordFiled: true,
                            isObscureText: true,
                            inputAction: TextInputAction.next)
                        .marginOnly(top: size_22)),
                    Obx(() => WidgetCommonTextField(
                            textEditingController:
                                controller.confirmPassController.value,
                            inputDecoration: InputDecoration(
                                hintText: 'hint_confirm_password'.tr,
                                hintStyle: AppText.textRegular.copyWith(
                                    color: colorWhite.withOpacity(0.56))),
                            textStyle: AppText.textRegular.copyWith(
                                fontSize: font_16,
                                color: colorWhite.withOpacity(0.5)),
                            inputType: TextInputType.text,
                            isPasswordFiled: true,
                            isObscureText: true,
                            inputAction: TextInputAction.done)
                        .marginOnly(top: size_22)),
                    WidgetBackgroundContainer(
                      child: Text(
                        'lbl_submit'.tr,
                        textAlign: TextAlign.center,
                        style: AppText.textBold
                            .copyWith(fontSize: font_18, color: colorWhite),
                      ),
                      cornerRadius: size_10,
                      paddingContainer:
                          const EdgeInsetsDirectional.all(size_20),
                      onClickAction: () {
                        controller.callChangePassApi();
                      },
                    ).marginOnly(top: size_33)
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
