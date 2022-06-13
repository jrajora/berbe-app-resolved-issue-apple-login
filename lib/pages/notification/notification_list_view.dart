import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_images.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:berbe/pages/notification/notification_list_controller.dart';
import 'package:berbe/widgets/scrollbehavior.dart';
import 'package:berbe/widgets/widget_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NotificationListView extends GetView<NotificationListController> {
  const NotificationListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
      backgroundColor: colorWhite,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          WidgetAppBar(
              prefixWidget: GestureDetector(
                child: SvgPicture.asset(icBack),
                onTap: () {
                  Get.back();
                },
              ),
              headerTitle: 'lbl_notification'.tr),
          Expanded(
            child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  itemBuilder: (listContext, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsetsDirectional.all(size_24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                  margin: const EdgeInsetsDirectional.only(end: size_20),
                                  child: SvgPicture.asset(icChange)),
                              Expanded(
                                child: Text(
                                  "Country $index rules get changed",
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  style: AppText.textMedium.copyWith(
                                      color: colorBlack, fontSize: font_18),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: size_1,
                          decoration: const BoxDecoration(
                            color: colorDivider,
                          ),
                        )
                      ],
                    );
                  },
                )),
          )
        ],
      ),
    ));
  }
}
