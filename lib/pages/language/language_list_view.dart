import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_images.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:berbe/pages/language/language_list_controller.dart';
import 'package:berbe/widgets/scrollbehavior.dart';
import 'package:berbe/widgets/widget_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LanguageListView extends GetView<LanguageListController> {
  const LanguageListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
      backgroundColor: colorWhite,
      body: Column(
        children: [
          WidgetAppBar(
              prefixWidget: GestureDetector(
                child: SvgPicture.asset(icBack),
                onTap: () {
                  Get.back();
                },
              ),
              headerTitle: 'lbl_language_selection'.tr),
          Expanded(
              child: ScrollConfiguration(
            behavior: MyBehavior(),
            child:ListView.builder(
                  padding: const EdgeInsetsDirectional.only(
                      start: paddingLeft,
                      end: paddingRight,
                      bottom: size_15,
                      top: size_15),
                  itemCount: controller.languageList.length,
                  itemBuilder: (listContext, index) {
                    return GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: size_10),
                        child: Obx(()=>Text(
                          controller.languageList[index].languageName,
                          textAlign: TextAlign.start,
                          style: AppText.textSemiBold.copyWith(
                              color: controller.selectedPos.value == index
                                  ? const Color(0xFF32AFEB)
                                  : colorTextLightGrey,
                              fontSize: font_18),
                        )),
                      ),
                      onTap: () {
                        controller.changeSelectedPos(index);
                      },
                      behavior: HitTestBehavior.opaque,
                    );
                  },
                )),
          )
        ],
      ),
    ));
  }
}
