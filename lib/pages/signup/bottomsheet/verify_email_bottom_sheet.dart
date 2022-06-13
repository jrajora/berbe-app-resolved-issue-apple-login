import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_images.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:berbe/utils/string_utils.dart';
import 'package:berbe/widgets/widget_background_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class VerifyEmailBottomSheet extends GetView {
  String title;
  VoidCallback onDoneClick;
  Widget messageWidget;

  VerifyEmailBottomSheet({Key? key,
    required this.title,
    required this.messageWidget,
    required this.onDoneClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsetsDirectional.only(
              start: paddingLeft,
              end: paddingRight,
              top: size_12,
              bottom: size_24),
          decoration: const BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(size_30),
                  topEnd: Radius.circular(size_30))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(icBottomSheetHide),
              Text(
                title,
                style: AppText.textBold.copyWith(
                  fontSize: font_24,
                  color: colorBoldGreen,
                ),
              ).marginOnly(top: size_30),
              /*Text(
                message,
                textAlign: TextAlign.center,
                style: AppText.textMedium,
              )*/
              messageWidget.marginOnly(top: size_20),
              SizedBox(
                child: WidgetBackgroundContainer(
                  child: Text(
                    'lbl_ok'.tr,
                    textAlign: TextAlign.center,
                    style: AppText.textBold
                        .copyWith(fontSize: font_18, color: colorWhite),
                  ),
                  cornerRadius: size_10,
                  paddingContainer: const EdgeInsetsDirectional.all(size_20),
                  onClickAction: () {
                    Get.back();
                    onDoneClick();
                  },
                ),
                width: double.infinity,
              ).marginOnly(top: size_40),
            ],
          ),
        )
      ],
    );
  }
}
