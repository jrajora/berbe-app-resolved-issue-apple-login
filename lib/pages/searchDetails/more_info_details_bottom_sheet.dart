import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_images.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:berbe/widgets/scrollbehavior.dart';
import 'package:berbe/widgets/widget_background_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MoreInfoDetailsBottomSheet extends GetView {
  VoidCallback onDoneClick;

  MoreInfoDetailsBottomSheet({Key? key, required this.onDoneClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(size_30),
              topEnd: Radius.circular(size_30))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(icBottomSheetHide).marginOnly(top: size_12,bottom: size_10),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsetsDirectional.only(
                    start: paddingLeft,
                    end: paddingRight,
                    top: size_20,
                    bottom: size_24),
                children: [
                  Text(
                    'dummy_test_required_for_country'.tr,
                    textAlign: TextAlign.center,
                    style: AppText.textBold.copyWith(
                      fontSize: font_24,
                      color: colorBlack,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Text(
                    'dummy_test_required_for_country_details'.tr,
                    textAlign: TextAlign.start,
                    style: AppText.textMedium,
                  ).marginOnly(top: size_25),
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
                  ).marginOnly(top: size_30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
