import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_constant.dart';
import 'package:berbe/constants/app_images.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:berbe/data/model/country_list_main_model.dart';
import 'package:berbe/pages/dashboard/dashboard_controller.dart';
import 'package:berbe/pages/dashboard/widget_drawer.dart';
import 'package:berbe/utils/string_utils.dart';
import 'package:berbe/widgets/flutter_switch.dart';
import 'package:berbe/widgets/scrollbehavior.dart';
import 'package:berbe/widgets/widget_app_bar.dart';
import 'package:berbe/widgets/widget_background_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'dashboard_background.dart';

class DashboardView extends GetView<DashboardController> {
  final Color textColor = colorWhite;

  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Stack(
        children: [
          const Positioned.fill(child: DashboardBackground()),
          Scaffold(
            key: controller.scaffoldKey.value,
            backgroundColor: Colors.transparent,
            drawer: WidgetDrawer(
              controller: controller,
            ),
            body: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  WidgetAppBar(
                      prefixWidget: GestureDetector(
                        child: SvgPicture.asset(icNavigation),
                        onTap: () {
                          controller.openDrawer();
                        },
                      ),
                      headerTitle: 'lbl_home'.tr),
                  Expanded(
                      child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView(
                      padding: const EdgeInsetsDirectional.all(size_25),
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                              child: Text(
                                'lbl_are_you_vaccinated'.tr.toUpperCase(),
                                softWrap: true,
                                textAlign: TextAlign.start,
                                style: AppText.textBold.copyWith(
                                    fontSize: font_20, color: textColor),
                              ),
                              padding: const EdgeInsetsDirectional.only(
                                  end: size_10),
                            )),
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
                                      const EdgeInsetsDirectional.all(size_3),
                                ),
                                inactiveIcon: Container(
                                    padding:
                                        const EdgeInsetsDirectional.all(size_3),
                                    child: Text(
                                      'lbl_no'.tr,
                                      textAlign: TextAlign.center,
                                      style: AppText.textBold.copyWith(
                                          fontSize: font_12,
                                          color: const Color(0xFFF24B4B)),
                                    )),
                                valueFontSize: font_12,
                                onToggle: (val) {
                                  controller.changeFlag(val);
                                }))
                          ],
                        ).marginOnly(top: size_20),
                        Get.locale?.languageCode == 'en'
                            ? RichText(
                                softWrap: true,
                                textAlign: TextAlign.start,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          'Fully vaccinated means you have received the full dose of an approved vaccine.\n\n',
                                      style: AppText.textRegular.copyWith(
                                          fontSize: font_12, color: textColor)),
                                  TextSpan(
                                      text: 'Example:',
                                      style: AppText.textBold.copyWith(
                                          fontSize: font_12, color: textColor)),
                                  TextSpan(
                                      text:
                                          '\nPfizer BioNTech = 2 doses, Moderna = 2 doses, Janssen = 1 dose.\n\nYou are considered ',
                                      style: AppText.textRegular.copyWith(
                                          fontSize: font_12, color: textColor)),
                                  TextSpan(
                                      text: 'Fully Vaccinated',
                                      style: AppText.textBold.copyWith(
                                          fontSize: font_12, color: textColor)),
                                  TextSpan(
                                      text:
                                          ' 2 weeks after your final dose. If you have been partially vaccinated or are traveling within 2 weeks of your final dose, you are considered ',
                                      style: AppText.textRegular.copyWith(
                                          fontSize: font_12, color: textColor)),
                                  TextSpan(
                                      text: 'Unvaccinated.',
                                      style: AppText.textBold.copyWith(
                                          fontSize: font_12, color: textColor)),
                                ])).marginOnly(top: size_20)
                            : Text(
                                'lbl_home_content'.tr,
                                softWrap: true,
                                textAlign: TextAlign.start,
                                style: AppText.textRegular.copyWith(
                                    fontSize: font_12, color: textColor),
                              ).marginOnly(top: size_20),
                        Obx(() => getAutoCompleteFromCountryField()
                            .marginOnly(top: size_50)),
                        Obx(() => getAutoCompleteToCountryField()
                            .marginOnly(top: size_24)),
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
                            controller.searchRules();
                          },
                        ).marginOnly(top: size_40),
                      ],
                    ),
                  )),
                  Obx(() => controller.advertiseList.value.isEmpty
                      ? Container()
                      : Container(
                          height: size_180,
                          margin: const EdgeInsetsDirectional.only(
                              start: paddingLeft,
                              end: paddingRight,
                              bottom: size_25),
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
                                        controller.advertiseList[index].image,
                                        ""),
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Container(
                                      child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                      ),
                                      width: size_25,
                                      height: size_25,
                                      alignment: Alignment.center,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      decoration: const BoxDecoration(
                                          color: colorTextGrey),
                                      child: Center(
                                        child: Text(
                                          "Page$index",
                                          style: const TextStyle(
                                              color: colorBlack),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  logGoogleAnalyticsEvent('ads_click', {});
                                  if ((controller.advertiseList[index].title ??
                                              "")
                                          .toLowerCase() ==
                                      "covid") {
                                    LaunchReview.launch(
                                        androidAppId: cPassAndroidID,
                                        iOSAppId: cPassIOSID);
                                  } else {
                                    if (await canLaunch(
                                        controller.advertiseList[index].link ??
                                            "")) {
                                      await launch(controller
                                              .advertiseList[index].link ??
                                          "");
                                    } else {
                                      // can't launch url, there is some error
                                      throw "Could not launch ${controller.advertiseList[index].link ?? ""}";
                                    }
                                  }
                                },
                                behavior: HitTestBehavior.opaque,
                              );
                            },
                          ))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAutoCompleteFromCountryField() {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: size_22, horizontal: size_24),
      decoration: BoxDecoration(
          color: colorFieldBG.withOpacity(0.7),
          borderRadius: BorderRadius.circular(size_10),
          border: Border.all(
              color: colorFieldBorder.withOpacity(0.18), width: size_1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(icLocation),
          const SizedBox(
            width: size_14,
          ),
          Expanded(
            child: TypeAheadFormField(
              hideOnEmpty: true,
              hideOnError: true,
              autoFlipDirection: true,
              suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                constraints: BoxConstraints(maxHeight: 200.0),
              ),
              textFieldConfiguration: TextFieldConfiguration(
                controller: controller.fromController.value,
                style: AppText.textRegular
                    .copyWith(fontSize: font_16, color: colorBlack),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  controller.selectedCountryFrom.value = "";
                  controller.isShowClearFrom.value = !checkString(
                      controller.fromController.value.text.toString().trim());
                },
                maxLines: 1,
                minLines: 1,
                decoration: InputDecoration(
                    hintText: 'hint_traveling_from'.tr,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.all(size_0),
                    hintStyle: AppText.textRegular.copyWith(
                        color: colorBlack.withOpacity(0.56),
                        fontSize: font_16)),
              ),
              onSuggestionSelected: (CountryListData suggestion) {
                controller.fromController.value =
                    TextEditingController(text: suggestion.name);
                controller.selectedCountryFrom.value = suggestion.id;
                // controller.setModelData(0, suggestion);
              },
              itemBuilder: (context, CountryListData itemData) {
                return Text(
                  itemData.name.toString(),
                  style: AppText.textMedium.copyWith(fontSize: font_18),
                ).marginOnly(
                    left: size_10, right: size_10, top: size_5, bottom: size_5);
              },
              suggestionsCallback: (pattern) {
                return getModelSuggestion(pattern);
              },
            ),
          ),
          const SizedBox(
            width: size_14,
          ),
          controller.isShowClearFrom.value
              ? GestureDetector(
                  child: const Icon(
                    Icons.cancel,
                    size: size_20,
                    color: colorTextGrey,
                  ),
                  onTap: () {
                    controller.clearFromCountryData();
                  },
                )
              : Container()
        ],
      ),
    );
  }

  Widget getAutoCompleteToCountryField() {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: size_22, horizontal: size_24),
      decoration: BoxDecoration(
          color: colorFieldBG.withOpacity(0.7),
          borderRadius: BorderRadius.circular(size_10),
          border: Border.all(
              color: colorFieldBorder.withOpacity(0.18), width: size_1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(icLocation),
          const SizedBox(
            width: size_14,
          ),
          Expanded(
            child: TypeAheadFormField(
              hideOnEmpty: true,
              hideOnError: true,
              autoFlipDirection: true,
              suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                constraints: BoxConstraints(maxHeight: 200.0),
              ),
              textFieldConfiguration: TextFieldConfiguration(
                controller: controller.toController.value,
                style: AppText.textRegular
                    .copyWith(fontSize: font_16, color: colorBlack),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                maxLines: 1,
                minLines: 1,
                onChanged: (value) {
                  controller.selectedCountryTo.value = "";
                  controller.isShowClearTo.value = !checkString(
                      controller.toController.value.text.toString().trim());
                },
                decoration: InputDecoration(
                    hintText: 'hint_traveling_to'.tr,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.all(size_0),
                    hintStyle: AppText.textRegular.copyWith(
                        color: colorBlack.withOpacity(0.56),
                        fontSize: font_16)),
              ),
              onSuggestionSelected: (CountryListData suggestion) {
                controller.toController.value =
                    TextEditingController(text: suggestion.name);
                controller.selectedCountryTo.value = suggestion.id;
                // controller.setModelData(0, suggestion);
              },
              itemBuilder: (context, CountryListData itemData) {
                return Text(
                  itemData.name.toString(),
                  style: AppText.textMedium.copyWith(fontSize: font_18),
                ).marginOnly(
                    left: size_10, right: size_10, top: size_5, bottom: size_5);
              },
              suggestionsCallback: (pattern) {
                return getModelSuggestion(pattern);
              },
            ),
          ),
          const SizedBox(
            width: size_14,
          ),
          controller.isShowClearTo.value
              ? GestureDetector(
                  child: const Icon(
                    Icons.cancel,
                    size: size_20,
                    color: colorTextGrey,
                  ),
                  onTap: () {
                    controller.clearToCountryData();
                  },
                )
              : Container()
          // SvgPicture.asset(icLocation),
        ],
      ),
    );
  }

  List<CountryListData> getModelSuggestion(String query) {
    List<CountryListData> list = [];
    if (query.isNotEmpty) {
      list.addAll(controller.countryList.reversed);
      list.retainWhere(
          (s) => s.name.toLowerCase().contains(query.toLowerCase()));
      List<CountryListData> startMatchList = [];
      for (int i = (list.length - 1); i >= 0; i--) {
        if (list[i].name.toLowerCase().startsWith(query.toLowerCase())) {
          startMatchList.insert(0, list[i]);
          list.removeAt(i);
        }
      }
      list.insertAll(0, startMatchList);
    }
    return list;
  }
}
