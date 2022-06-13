import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_images.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:berbe/pages/moreInfo/more_info_controller.dart';
import 'package:berbe/widgets/scrollbehavior.dart';
import 'package:berbe/widgets/widget_app_bar.dart';
import 'package:berbe/widgets/widget_background_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../main.dart';

class MoreInfoView extends GetView<MoreInfoController> {
  const MoreInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colorBlack, colorGredient])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            WidgetAppBar(
                prefixWidget: GestureDetector(
                  child: SvgPicture.asset(icBack),
                  onTap: () {
                    Get.back();
                  },
                ),
                postfixWidget: WidgetBackgroundContainer(
                  paddingContainer: const EdgeInsetsDirectional.only(
                      top: size_8,
                      bottom: size_8,
                      start: size_12,
                      end: size_12),
                  cornerRadius: size_50,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        icShare,
                        width: size_12,
                        height: size_12,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: size_6,
                      ),
                      Text(
                        'lbl_share'.tr,
                        softWrap: true,
                        style: AppText.textBold.copyWith(
                          color: colorWhite,
                          fontSize: font_10,
                        ),
                      ),
                    ],
                  ),
                  onClickAction: () {
                    shareAppContent();
                  },
                ),
                headerTitle: 'lbl_alert'.tr),
            Obx(() => Expanded(
                child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView(
                      padding: const EdgeInsetsDirectional.only(
                          end: paddingRight,
                          start: paddingLeft,
                          top: size_18,
                          bottom: size_25),
                      children: [
                        Text.rich(
                          TextSpan(
                            style: AppText.textBold
                                .copyWith(fontSize: font_20, color: colorWhite),
                            children: <TextSpan>[
                              TextSpan(
                                text: "${'lbl_travel_rules_from'.tr}\n ",
                              ),
                              TextSpan(
                                  text: controller.travelFromCityName.value,
                                  style: AppText.textBold.copyWith(
                                    fontSize: font_20,
                                    color: colorCountryHighlighted,
                                    decoration: TextDecoration.underline,
                                  )),
                              TextSpan(
                                text: " ${'lbl_to'.tr} ",
                              ),
                              TextSpan(
                                  text: controller.travelToCityName.value,
                                  style: AppText.textBold.copyWith(
                                    fontSize: font_20,
                                    color: colorCountryHighlighted,
                                    decoration: TextDecoration.underline,
                                  )),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          padding: const EdgeInsetsDirectional.only(
                              top: size_20,
                              start: size_15,
                              end: size_15,
                              bottom: size_20),
                          decoration: BoxDecoration(
                              color: colorLightSkyBlue,
                              borderRadius: BorderRadius.circular(size_9)),
                          child: Text(
                            controller.stMoreRules.value,
                            textAlign: TextAlign.start,
                            softWrap: true,
                            style: AppText.textMedium
                                .copyWith(fontSize: font_14, color: colorBlack),
                          ),
                        ).marginOnly(top: size_15)
                      ],
                    )))),
            Container(
              width: double.infinity,
              padding: EdgeInsetsDirectional.only(
                  start: paddingLeft,
                  end: paddingRight,
                  bottom: size_25,
                  top: size_20),
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
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
