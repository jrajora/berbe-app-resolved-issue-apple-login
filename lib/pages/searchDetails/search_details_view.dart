import 'dart:ui';
import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_constant.dart';
import 'package:berbe/constants/app_images.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:berbe/data/model/advertisement_main_model.dart';
import 'package:berbe/pages/searchDetails/search_details_controller.dart';
import 'package:berbe/utils/string_utils.dart';
import 'package:berbe/widgets/flutter_switch.dart';
import 'package:berbe/widgets/scrollbehavior.dart';
import 'package:berbe/widgets/widget_app_bar.dart';
import 'package:berbe/widgets/widget_background_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class SearchDetailsView extends GetView<SearchDetailsController> {
  const SearchDetailsView({Key? key}) : super(key: key);

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
                    top: size_8, bottom: size_8, start: size_12, end: size_12),
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
              headerTitle: 'lbl_search_details'.tr,
            ),
            Obx(() => Expanded(
                    child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: controller.isApiCall.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : controller.isSuccessResp.value
                          ? ListView(
                              padding: const EdgeInsetsDirectional.only(
                                  end: paddingRight,
                                  start: paddingLeft,
                                  top: size_18,
                                  bottom: size_25),
                              children: [
                                Text.rich(
                                  TextSpan(
                                    style: AppText.textBold.copyWith(
                                        fontSize: font_20, color: colorWhite),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            "${'lbl_travel_rules_from'.tr}\n ",
                                      ),
                                      TextSpan(
                                          text: controller
                                              .travelFromCityName.value,
                                          style: AppText.textBold.copyWith(
                                            fontSize: font_20,
                                            color: colorCountryHighlighted,
                                            decoration:
                                                TextDecoration.underline,
                                          )),
                                      TextSpan(
                                        text: " ${'lbl_to'.tr} ",
                                      ),
                                      TextSpan(
                                          text:
                                              controller.travelToCityName.value,
                                          style: AppText.textBold.copyWith(
                                            fontSize: font_20,
                                            color: colorCountryHighlighted,
                                            decoration:
                                                TextDecoration.underline,
                                          )),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: size_15,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        'lbl_are_you_vaccinated'.tr,
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        style: AppText.textBold.copyWith(
                                            fontSize: font_20,
                                            color: colorWhite),
                                      ),
                                      padding: const EdgeInsetsDirectional.only(
                                          end: size_10), // jignesh
                                    ),
                                    Obx(() => FlutterSwitch(
                                        width: size_70,
                                        height: size_40,
                                        padding: size_3,
                                        toggleSize: size_36,
                                        activeToggleColor: colorWhite,
                                        inactiveToggleColor: colorWhite,
                                        activeColor: const Color(0xFF33C5E9),
                                        inactiveColor: const Color(0xFFF24B4B),
                                        value: controller.isVaccinated.value,
                                        activeIcon: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'lbl_yes'.tr,
                                            textAlign: TextAlign.center,
                                            style: AppText.textBold.copyWith(
                                                fontSize: font_12,
                                                color: const Color(0xFF33C5E9)),
                                          ),
                                          padding:
                                              const EdgeInsetsDirectional.all(
                                                  size_3),
                                        ),
                                        inactiveIcon: Container(
                                            padding:
                                                const EdgeInsetsDirectional.all(
                                                    size_3),
                                            child: Text(
                                              'lbl_no'.tr,
                                              textAlign: TextAlign.center,
                                              style: AppText.textBold.copyWith(
                                                  fontSize: font_12,
                                                  color:
                                                      const Color(0xFFF24B4B)),
                                            )),
                                        valueFontSize: font_12,
                                        onToggle: (val) {
                                          controller.changeFlag(val);
                                        })),
                                  ],
                                ), // .marginOnly(top: size_15, right: size_30) jignesh
                                widgetBeforeArrivalData()
                                    .marginOnly(top: size_15),
                                checkString(controller.searchData.value
                                        .rulesCriteriaDeparture)
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          controller.redirectToMoreInfo();
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: size_30,
                                                  end: size_30,
                                                  top: size_8,
                                                  bottom: size_8),
                                          decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                  colors: [
                                                    Color(0xFF3D31EC),
                                                    Color(0xFF8978FF)
                                                  ]),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(size_10))),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'lbl_alert'.tr,
                                                style: AppText.textBold
                                                    .copyWith(
                                                        fontSize: font_20,
                                                        color: colorWhite),
                                              ),
                                              Text(
                                                'lbl_more_information'.tr,
                                                style: AppText.textMedium
                                                    .copyWith(
                                                        fontSize: font_14,
                                                        color: colorWhite),
                                                softWrap: true,
                                              ).marginOnly(top: size_2),
                                              Text(
                                                'lbl_click_here'.tr,
                                                style: AppText.textBold
                                                    .copyWith(
                                                        fontSize: font_20,
                                                        color: colorWhite,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                              ).marginOnly(top: size_2),
                                            ],
                                          ),
                                        ).marginOnly(top: size_15),
                                      ),
                                widgetOnArrivalData().marginOnly(top: size_15),
                              ],
                            )
                          : Center(
                              child: Text(
                                'msg_no_data_found'.tr,
                                style: AppText.textBold.copyWith(
                                    fontSize: font_14, color: colorTextGrey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                ))),
            Obx(() => controller.advertiseList.value.isEmpty
                ? Container()
                : Container(
                    height: size_180,
                    margin: const EdgeInsetsDirectional.only(
                        start: paddingLeft, end: paddingRight, bottom: size_25),
                    child: PageView.builder(
                      scrollBehavior: MyBehavior(),
                      itemCount: controller.advertiseList.length,
                      controller: controller.pageController.value,
                      onPageChanged: (pageIndex) {
                        controller.timerPage?.cancel();
                        controller.currentPage.value = pageIndex;
                        controller.changePageAutomatically();
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: SizedBox(
                            width: double.infinity,
                            height: size_180,
                            child: CachedNetworkImage(
                              imageUrl: defaultStringValue(
                                  controller.advertiseList[index].image, ""),
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Container(
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                ),
                                width: size_25,
                                height: size_25,
                                alignment: Alignment.center,
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration:
                                    const BoxDecoration(color: colorTextGrey),
                                child: Center(
                                  child: Text(
                                    "Page$index",
                                    style: const TextStyle(color: colorBlack),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            logGoogleAnalyticsEvent('ads_click', {});
                            if ((controller.advertiseList[index].title ?? "")
                                    .toLowerCase() ==
                                "covid") {
                              LaunchReview.launch(
                                  androidAppId: cPassAndroidID,
                                  iOSAppId: cPassIOSID);
                            } else {
                              if (await canLaunch(
                                  controller.advertiseList[index].link ?? "")) {
                                await launch(
                                    controller.advertiseList[index].link ?? "");
                              } else {
                                // can't launch url, there is some error
                                throw "Could not launch ${controller.advertiseList[index].link ?? ""}";
                              }
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                        );
                      },
                    )
                    /*PageView(
                      controller: PageController(initialPage: 0),
                      scrollBehavior: MyBehavior(),
                      allowImplicitScrolling: true,
                      children: bannerAds(),
                    )*/
                    )),
          ],
        ),
      ),
    ));
  }

  List<Widget> bannerAds() {
    List<Widget> list = [];
    for (AdvertisementData data in controller.advertiseList.value) {
      list.add(GestureDetector(
        child: SizedBox(
          width: double.infinity,
          height: size_180,
          child: CachedNetworkImage(
            imageUrl: defaultStringValue(data.image, ""),
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
            errorWidget: (context, url, error) => Container(
              decoration: const BoxDecoration(color: colorTextGrey),
            ),
          ),
        ),
        onTap: () async {
          logGoogleAnalyticsEvent('ads_click', {});
          if ((data.title ?? "").toLowerCase() == "covid") {
            LaunchReview.launch(
                androidAppId: cPassAndroidID, iOSAppId: cPassIOSID);
          } else {
            if (await canLaunch(data.link ?? "")) {
              await launch(data.link ?? "");
            } else {
              // can't launch url, there is some error
              throw "Could not launch ${data.link ?? ""}";
            }
          }
        },
        behavior: HitTestBehavior.opaque,
      ));
    }

    return list;
  }

  Widget widgetBeforeArrivalData() {
    return Container(
      padding: const EdgeInsetsDirectional.all(size_10),
      decoration: BoxDecoration(
          color: colorLightSkyBlue,
          borderRadius: BorderRadius.circular(size_9)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "${'lbl_before_arrival_in'.tr} ${controller.travelToCityName.value}",
              textAlign: TextAlign.start,
              softWrap: true,
              style: AppText.textSemiBold
                  .copyWith(fontSize: font_20, color: colorBlack),
            ),
            margin: const EdgeInsetsDirectional.only(
                top: size_5, end: size_2, start: size_2),
          ),
          Container(
            height: size_1,
            decoration: BoxDecoration(color: colorDivider.withOpacity(0.17)),
          ).marginOnly(top: size_5),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'lbl_required_test'.tr,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textBold
                      .copyWith(fontSize: font_15, color: colorBlack),
                ),
                Text(
                  defaultStringValue(
                      controller.searchData.value.requiredTestBeforeArrival,
                      'lbl_none'.tr),
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textSemiBold.copyWith(
                      fontSize: font_14, color: colorSearchDetailsFnt),
                ),
                Text(
                  'lbl_test_time'.tr,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textBold
                      .copyWith(fontSize: font_15, color: colorBlack),
                ).marginOnly(top: size_5),
                Text(
                  checkString(controller.searchData.value.testTimeBeforeArrival)
                      ? 'lbl_not_required'.tr
                      : "${'lbl_within_last'.tr} ${controller.searchData.value.testTimeBeforeArrival ?? "N/A"} ${'lbl_hours_of_departure'.tr}",
                  softWrap: true,
                  textAlign: TextAlign.start,
                  style: AppText.textSemiBold.copyWith(
                      fontSize: font_14, color: colorSearchDetailsFnt),
                ),
                Text(
                  'lbl_age_reqiured_test'.tr,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textBold
                      .copyWith(fontSize: font_15, color: colorBlack),
                ).marginOnly(top: size_5),
                Text(
                  checkString(controller
                          .searchData.value.minimumAgeForTestBeforeArrival)
                      ? 'lbl_none'.tr
                      : "${controller.searchData.value.minimumAgeForTestBeforeArrival ?? "N/A"} ${'lbl_years'.tr}",
                  softWrap: true,
                  textAlign: TextAlign.start,
                  style: AppText.textSemiBold.copyWith(
                      fontSize: font_14, color: colorSearchDetailsFnt),
                ),
                Text(
                  'lbl_additional_doc_required'.tr,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textBold
                      .copyWith(fontSize: font_15, color: colorBlack),
                ).marginOnly(top: size_5),
                Text(
                  "${controller.searchData.value.additionalDocRequired ?? "N/A"}, ${(controller.searchData.value.additionalDocRequired ?? "").toLowerCase() == "yes" ? 'lbl_pfl_required'.tr : 'lbl_pfl_not_required'.tr}",
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textSemiBold.copyWith(
                      fontSize: font_14, color: colorSearchDetailsFnt),
                ),
                Text(
                  'lbl_link_submit_doc'.tr,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textBold
                      .copyWith(fontSize: font_15, color: colorBlack),
                ).marginOnly(top: size_5),
                GestureDetector(
                  child: Text(
                    defaultStringValue(
                        controller.searchData.value.linkToSubmitDocument,
                        'lbl_none'.tr),
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: AppText.textSemiBold.copyWith(
                        fontSize: font_14,
                        color: checkString(controller
                                .searchData.value.linkToSubmitDocument)
                            ? colorBlack
                            : Colors.blue,
                        decoration: checkString(controller
                                .searchData.value.linkToSubmitDocument)
                            ? TextDecoration.none
                            : TextDecoration.underline),
                  ),
                  onTap: () async {
                    if (!checkString(
                        controller.searchData.value.linkToSubmitDocument)) {
                      if (await canLaunch(
                          controller.searchData.value.linkToSubmitDocument ??
                              "")) {
                        await launch(
                            controller.searchData.value.linkToSubmitDocument ??
                                "");
                      } else {
                        // can't launch url, there is some error
                        throw "Could not launch ${controller.searchData.value.linkToSubmitDocument ?? ""}";
                      }
                    }
                  },
                ),
              ],
            ),
            margin: const EdgeInsetsDirectional.only(
                start: size_15, end: size_5, top: size_12),
          )
        ],
      ),
    );
  }

  Widget widgetOnArrivalData() {
    return Container(
      padding: const EdgeInsetsDirectional.all(size_10),
      decoration: BoxDecoration(
          color: colorLightSkyBlue,
          borderRadius: BorderRadius.circular(size_9)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "${'lbl_on_arrival_in'.tr} ${controller.travelToCityName.value}",
              textAlign: TextAlign.start,
              softWrap: true,
              style: AppText.textSemiBold
                  .copyWith(fontSize: font_20, color: colorBlack),
            ),
            margin: const EdgeInsetsDirectional.only(
                top: size_5, end: size_2, start: size_2),
          ),
          Container(
            height: size_1,
            decoration: BoxDecoration(color: colorDivider.withOpacity(0.17)),
          ).marginOnly(top: size_5),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'lbl_required_test'.tr,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textBold
                      .copyWith(fontSize: font_15, color: colorBlack),
                ),
                Text(
                  defaultStringValue(
                      controller.searchData.value.requiredTestOnArrival,
                      'lbl_none'.tr),
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textSemiBold.copyWith(
                      fontSize: font_14, color: colorSearchDetailsFnt),
                ),
                Text(
                  'lbl_quarantine_required'.tr,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textBold
                      .copyWith(fontSize: font_15, color: colorBlack),
                ).marginOnly(top: size_5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      defaultStringValue(
                          controller.searchData.value.quarantineRequired,
                          'lbl_no'.tr),
                      textAlign: TextAlign.start,
                      softWrap: true,
                      style: AppText.textSemiBold.copyWith(
                          fontSize: font_14, color: colorSearchDetailsFnt),
                    ),
                    Text(
                      checkZeroString(controller
                              .searchData.value.Isolation_Req_DestCountry)
                          ? ' '.tr
                          : ", ${controller.searchData.value.Isolation_Req_DestCountry ?? " "} ${'lbl_days'.tr}",
                      softWrap: true,
                      textAlign: TextAlign.start,
                      style: AppText.textSemiBold.copyWith(
                          fontSize: font_14, color: colorSearchDetailsFnt),
                    ),
                  ],
                ),
                /*Text(
                  'lbl_additional_doc_required'.tr,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textBold
                      .copyWith(fontSize: font_14, color: colorBlack),
                ).marginOnly(top: size_5),
                Text(
                  "${controller.searchData.value.additionalDocRequired ?? "N/A"}, ${(controller.searchData.value.additionalDocRequired ?? "").toLowerCase() == "yes" ? 'lbl_pfl_required'.tr : 'lbl_pfl_not_required'.tr}",
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textRegular
                      .copyWith(fontSize: font_14, color: colorBlack),
                ),
                Text(
                  'lbl_link_submit_doc'.tr,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textBold
                      .copyWith(fontSize: font_14, color: colorBlack),
                ).marginOnly(top: size_5),
                GestureDetector(
                  child: Text(
                    controller.searchData.value.linkToSubmitDocument ?? "N/A",
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: AppText.textRegular.copyWith(
                        fontSize: font_14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                  onTap: () async {
                    if (await canLaunch(
                        controller.searchData.value.linkToSubmitDocument ??
                            "")) {
                      await launch(
                          controller.searchData.value.linkToSubmitDocument ??
                              "");
                    } else {
                      // can't launch url, there is some error
                      throw "Could not launch ${controller.searchData.value.linkToSubmitDocument ?? ""}";
                    }
                  },
                ),*/
                /*GestureDetector(
                  child: Text(
                    'lbl_more_info_about_result'.tr,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: AppText.textBold.copyWith(
                        fontSize: font_14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ).marginOnly(top: size_5),
                  onTap: () {
                    controller.showMoreInfoBottomSheet();
                  },
                  behavior: HitTestBehavior.opaque,
                ),*/
                Text(
                  'lbl_age_reqiured_test'.tr,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textBold
                      .copyWith(fontSize: font_15, color: colorBlack),
                ).marginOnly(top: size_5),
                Text(
                  checkString(controller
                          .searchData.value.minimumAgeForTestAfterArrival)
                      ? 'lbl_none'.tr
                      : "${controller.searchData.value.minimumAgeForTestAfterArrival ?? "N/A"} ${'lbl_years'.tr}",
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: AppText.textSemiBold.copyWith(
                      fontSize: font_14, color: colorSearchDetailsFnt),
                ),
              ],
            ),
            margin: const EdgeInsetsDirectional.only(
                start: size_15, end: size_5, top: size_12),
          )
        ],
      ),
    );
  }
}
