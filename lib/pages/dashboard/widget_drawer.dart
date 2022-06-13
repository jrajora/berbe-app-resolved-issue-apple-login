import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_images.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:berbe/pages/dashboard/dashboard_controller.dart';
import 'package:berbe/utils/string_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../main.dart';

class WidgetDrawer extends GetView {
  DashboardController controller;

  WidgetDrawer({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: size_250,
      decoration: const BoxDecoration(color: colorWhite),
      padding: const EdgeInsets.only(top: size_30),
      child: Column(
        children: [
          Container(
            height: size_90,
            width: size_90,
            decoration: BoxDecoration(
                border: Border.all(color: colorBlack, width: size_3),
                borderRadius: BorderRadius.circular(size_45)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(size_45),
                child: CachedNetworkImage(
                  imageUrl:
                      defaultStringValue(controller.userData.value.profile, ""),
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Container(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                    width: size_25,
                    height: size_25,
                    alignment: Alignment.center,
                  ),
                  errorWidget: (context, url, error) => Center(
                      child: SvgPicture.asset(
                    icDrawerProfile,
                    color: colorBlack,
                    height: size_35,
                    width: size_35,
                    fit: BoxFit.cover,
                  )),
                )),
          ),
          Obx(() => Text(
                defaultStringValue(controller.userData.value.name, ""),
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.textBold
                    .copyWith(fontSize: font_18, color: colorBlack),
              ).marginOnly(top: size_12, left: size_10, right: size_10)),
          Text(
            defaultStringValue(controller.userData.value.email, ""),
            textAlign: TextAlign.center,
            style: AppText.textMedium
                .copyWith(fontSize: font_14, color: colorBlack),
          ),
          Obx(() => drawerMenu(icDrawerProfile, 'lbl_my_profile'.tr, () {
                //TODO : onMyProfileClick
                controller.openProfile();
              }, controller.isProfileOpen.value)
                  .marginOnly(top: size_30)),
          /*Obx(() => drawerMenu(icDrawerNotification, 'lbl_notification'.tr, () {
                //TODO : onNotificationClick
                controller.openNotification();
              }, controller.isNotificationOpen.value)
                  .marginOnly(top: size_6)),*/
          /*Obx(() =>
              drawerMenu(icDrawerLanguage, 'lbl_language_selection'.tr, () {
                //TODO : onLanguageClick
                controller.openLanguage();
              }, controller.isLanguageOpen.value)
                  .marginOnly(top: size_6)),*/
          Obx(() => controller.userData.value.email != null
              ? drawerMenu(icDrawerLock, 'lbl_change_password'.tr, () {
                  //TODO : onChangePasswordClick
                  controller.openChangePass();
                }, controller.isChangePassOpen.value)
                  .marginOnly(top: size_6)
              : Container()),
          drawerMenu(icShare, 'lbl_share_app'.tr, () {
            //TODO : onLogoutClick
            shareAppContent();
          }, false)
              .marginOnly(top: size_6),
          drawerMenu(icDrawerLogout, 'lbl_logout'.tr, () {
            //TODO : onLogoutClick
            controller.showLogoutDialog();
          }, false)
              .marginOnly(top: size_6),
          Expanded(child: Container()),
          Obx(() => Text(
                "V ${controller.appVersion.value}",
                textAlign: TextAlign.center,
                style: AppText.textRegular
                    .copyWith(color: colorDivider, fontSize: font_14),
              ).marginOnly(bottom: size_20))
        ],
      ),
    );
  }

  Widget drawerMenu(
      String icon, String title, VoidCallback onClick, bool isSelected) {
    return GestureDetector(
      onTap: () {
        controller.closeDrawer();
        onClick();
      },
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: isSelected
                    ? colorBlack.withOpacity(0.07)
                    : Colors.transparent),
            height: size_45,
            width: double.infinity,
            margin: const EdgeInsetsDirectional.only(start: size_35),
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsetsDirectional.only(
                  start: paddingLeft, end: size_20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    child: SvgPicture.asset(icon),
                    margin: const EdgeInsetsDirectional.only(end: size_15),
                  ),
                  Expanded(
                      child: Text(
                    title,
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: AppText.textRegular
                        .copyWith(color: colorBlack, fontSize: font_16),
                  ))
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
