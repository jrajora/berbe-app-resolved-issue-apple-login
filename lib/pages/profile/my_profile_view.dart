import 'dart:math';

import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_constant.dart';
import 'package:berbe/constants/app_images.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:berbe/data/model/country_list_main_model.dart';
import 'package:berbe/pages/profile/my_profile_controller.dart';
import 'package:berbe/routes/app_pages.dart';
import 'package:berbe/utils/storage_utils.dart';
import 'package:berbe/utils/string_utils.dart';
import 'package:berbe/widgets/scrollbehavior.dart';
import 'package:berbe/widgets/widget_app_bar.dart';
import 'package:berbe/widgets/widget_background_container.dart';
import 'package:berbe/widgets/widget_common_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class MyProfileView extends GetView<MyProfileController> {
  const MyProfileView({Key? key}) : super(key: key);

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
          body: GestureDetector(
            onTap: () {
              removeFocus();
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                WidgetAppBar(
                    prefixWidget: GestureDetector(
                      child: SvgPicture.asset(
                          controller.redirectFrom.value == "singup"
                              ? icBlackDot
                              : icBack),
                      onTap: () {
                        if (controller.redirectFrom.value != "singup") {
                          Get.back();
                        }
                      },
                    ),
                    headerTitle: 'lbl_my_profile'.tr),
                Expanded(
                    child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    controller: controller.scrollController.value,
                    padding: const EdgeInsetsDirectional.only(
                        end: paddingRight,
                        start: paddingLeft,
                        top: size_15,
                        bottom: size_15),
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            showSelectImageDialog(context);
                            removeFocus();
                          },
                          child: Container(
                            height: size_90,
                            width: size_90,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: colorBlack, width: size_3),
                                borderRadius: BorderRadius.circular(size_45)),
                            child: Stack(
                              fit: StackFit.passthrough,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              children: [
                                Positioned(
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(size_45),
                                      child: Obx(
                                        () => controller.profileImgFile.value
                                                .path.isEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: defaultStringValue(
                                                    controller
                                                        .userData.value.profile,
                                                    ""),
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Container(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress,
                                                  ),
                                                  width: size_25,
                                                  height: size_25,
                                                  alignment: Alignment.center,
                                                ),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Center(
                                                        child: SvgPicture.asset(
                                                  icDrawerProfile,
                                                  color: colorBlack,
                                                  height: size_35,
                                                  width: size_35,
                                                  fit: BoxFit.cover,
                                                )),
                                              )
                                            : Image.file(
                                                controller.profileImgFile.value,
                                                fit: BoxFit.cover,
                                              ),
                                      )),
                                ),
                                Positioned(
                                  bottom: size_0,
                                  right: size_0,
                                  child: SizedBox(
                                    height: size_30,
                                    width: size_30,
                                    child: GestureDetector(
                                      child: SvgPicture.asset(icCamera),
                                      onTap: () {
                                        showSelectImageDialog(context);
                                        removeFocus();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Obx(() => WidgetCommonTextField(
                            textEditingController:
                                controller.emailController.value,
                            autoFillHint: const [AutofillHints.email],
                            postfixWidget: controller.emailVerified.value
                                ? null
                                : GestureDetector(
                                    child: const Icon(
                                      Icons.info_outline,
                                      color: Colors.red,
                                    ),
                                    onTap: () => showEmailVerifyBottomSheet(),
                                  ),
                            inputDecoration: InputDecoration(
                                hintText: 'hint_enter_email'.tr,
                                hintStyle: AppText.textRegular.copyWith(
                                    color: colorBlack.withOpacity(0.56),
                                    fontSize: font_16)),
                            textStyle: AppText.textRegular
                                .copyWith(fontSize: font_16, color: colorBlack),
                            inputType: TextInputType.emailAddress,
                            inputAction: TextInputAction.next,
                          ).marginOnly(top: size_15)),
                      Obx(() => WidgetCommonTextField(
                            textEditingController:
                                controller.nameController.value,
                            inputDecoration: InputDecoration(
                                hintText: 'hint_full_name'.tr,
                                hintStyle: AppText.textRegular.copyWith(
                                    color: colorBlack.withOpacity(0.56),
                                    fontSize: font_16)),
                            textStyle: AppText.textRegular
                                .copyWith(fontSize: font_16, color: colorBlack),
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                          ).marginOnly(top: size_15)),
                      Obx(() => GestureDetector(
                            child: WidgetCommonTextField(
                              textEditingController:
                                  controller.dobController.value,
                              inputDecoration: InputDecoration(
                                  hintText: 'hint_dob'.tr,
                                  hintStyle: AppText.textRegular.copyWith(
                                      color: colorBlack.withOpacity(0.56),
                                      fontSize: font_16)),
                              textStyle: AppText.textRegular.copyWith(
                                  fontSize: font_16, color: colorBlack),
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              isEditable: false,
                            ).marginOnly(top: size_15),
                            onTap: () {
                              controller.selectDateOfBirth();
                            },
                          )),
                      Obx(() => phoneNumberFieldWithCountryCode()
                          .marginOnly(top: size_15)),
                      Obx(() => getAutoCompleteCountryField()
                          .marginOnly(top: size_15)),
                      /*GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: size_22, horizontal: size_24),
                          decoration: BoxDecoration(
                              color: colorFieldBG.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(size_10),
                              border: Border.all(
                                  color: colorFieldBorder.withOpacity(0.18),
                                  width: size_1)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Text('lbl_language_selection'.tr,
                                      textAlign: TextAlign.start,
                                      style: AppText.textRegular.copyWith(
                                          fontSize: font_16, color: colorBlack))),
                              Container(
                                margin: const EdgeInsetsDirectional.only(
                                    start: size_10),
                                child: Obx(() => Text(
                                    controller.languageName.value,
                                    textAlign: TextAlign.start,
                                    style: AppText.textMedium.copyWith(
                                        fontSize: font_16, color: colorBlack))),
                              )
                            ],
                          ),
                        ).marginOnly(top: size_15),
                        onTap: () {
                          //TODO: Language Selection
                          Get.toNamed(Routes.LANGUAGE)?.then((value) {
                            controller.setLanguageName();
                            controller.getCountryList();
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                      ),*/
                      WidgetBackgroundContainer(
                        child: Text(
                          'lbl_save'.tr,
                          textAlign: TextAlign.center,
                          style: AppText.textBold
                              .copyWith(fontSize: font_18, color: colorWhite),
                        ),
                        cornerRadius: size_10,
                        paddingContainer:
                            const EdgeInsetsDirectional.all(size_20),
                        onClickAction: () {
                          //ToDo Save Profile
                          controller.callUpdateProfileApi();
                        },
                      ).marginOnly(top: size_22),
                      Align(
                        child: GestureDetector(
                          child: Text(
                            'lbl_delete_account'.tr,
                            style: AppText.textMedium.copyWith(
                                fontSize: font_16,
                                fontWeight: FontWeight.normal,
                                color: colorWhite),
                          ),
                          onTap: () {
                            //TODO : OpenForgot Password Screen
                            // Get.toNamed(Routes.LOGIN);
                            showDeleteAccountBottomSheet();
                          },
                          behavior: HitTestBehavior.opaque,
                        ),
                        alignment: AlignmentDirectional.topEnd,
                      ).marginOnly(top: size_20, right: size_10),
                      Obx(() => controller.isAdAvailable.value
                          ? GestureDetector(
                              child: SizedBox(
                                width: double.infinity,
                                height: size_180,
                                child: CachedNetworkImage(
                                  imageUrl: defaultStringValue(
                                      controller.objCovidAppAd.value.image, ""),
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
                                  ),
                                ),
                              ),
                              onTap: () async {
                                logGoogleAnalyticsEvent('ads_click', {});
                                /*LaunchReview.launch(
                                    androidAppId: cPassAndroidID,
                                    iOSAppId: cPassIOSID);*/
                                if ((controller.objCovidAppAd.value.title ?? "")
                                        .toLowerCase() ==
                                    "covid") {
                                  LaunchReview.launch(
                                      androidAppId: cPassAndroidID,
                                      iOSAppId: cPassIOSID);
                                } else {
                                  if (await canLaunch(
                                      controller.objCovidAppAd.value.link ??
                                          "")) {
                                    await launch(
                                        controller.objCovidAppAd.value.link ??
                                            "");
                                  } else {
                                    // can't launch url, there is some error
                                    throw "Could not launch ${controller.objCovidAppAd.value.link ?? ""}";
                                  }
                                }
                              },
                              behavior: HitTestBehavior.opaque,
                            )
                          : Container()).marginOnly(top: size_30),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSelectImageDialog(BuildContext context) {
    Widget content = Text('lbl_select_image'.tr);
    final actions = <Widget>[
      TextButton(
        onPressed: () {
          controller.selectImage(TYPE_CAMERA);
        },
        child: Text('lbl_camera'.tr),
      ),
      TextButton(
        onPressed: () {
          controller.selectImage(TYPE_GALLERY);
        },
        child: Text('lbl_gallery'.tr),
      ),
    ];
    showDialog(
      context: Get.overlayContext!,
      builder: (dialogContext) {
        return GetPlatform.isIOS
            ? CupertinoAlertDialog(
                title: null,
                content: content,
                actions: actions,
              )
            : AlertDialog(
                title: null,
                content: content,
                actions: actions,
              );
      },
    );
  }

  Widget phoneNumberFieldWithCountryCode() {
    return Container(
      decoration: BoxDecoration(
          color: colorFieldBG.withOpacity(0.5),
          borderRadius: BorderRadius.circular(size_10),
          border: Border.all(
              color: colorFieldBorder.withOpacity(0.18), width: size_1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CountryCodePicker(
            dialogTextStyle: AppText.textMedium
                .copyWith(fontSize: font_16, color: colorBlack),
            textStyle: AppText.textMedium
                .copyWith(fontSize: font_16, color: colorBlack),
            padding: const EdgeInsetsDirectional.all(0.0),
            showFlag: false,
            showFlagDialog: true,
            initialSelection: controller.countryCode.value.code,
            onChanged: (countryCode) {
              controller.countryCode.value = countryCode;
              controller.stCountryCode.value = countryCode.dialCode ?? "";
            },
            builder: (countryCode) {
              return Container(
                padding: const EdgeInsetsDirectional.only(
                    start: size_24,
                    top: size_22,
                    bottom: size_22,
                    end: size_10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(controller.stCountryCode.value,
                        textAlign: TextAlign.start,
                        style: AppText.textMedium
                            .copyWith(fontSize: font_16, color: colorBlack)),
                    const SizedBox(
                      width: size_3,
                    ),
                    Transform.rotate(
                        angle: 180 * pi / 360,
                        child: const Icon(
                          Icons.chevron_right_rounded,
                          size: size_20,
                          color: colorBlack,
                        ))
                  ],
                ),
              );
            },
          ),
          Container(
            width: size_1,
            height: size_66,
            decoration:
                BoxDecoration(color: colorFieldBorder.withOpacity(0.18)),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsetsDirectional.only(
                start: size_24, top: size_22, bottom: size_22, end: size_24),
            child: TextFormField(
              controller: controller.phoneController.value,
              textAlign: TextAlign.start,
              maxLines: 1,
              minLines: 1,
              maxLength: 15,
              decoration: InputDecoration(
                hintText: 'hint_phone_number'.tr,
                hintStyle: AppText.textRegular.copyWith(
                    color: colorBlack.withOpacity(0.56), fontSize: font_16),
                border: InputBorder.none,
                isDense: true,
                counterText: "",
                counter: null,
                contentPadding: const EdgeInsets.all(size_0),
              ),
              style: AppText.textRegular
                  .copyWith(fontSize: font_16, color: colorBlack),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          )),
        ],
      ),
    );
  }

  Widget getAutoCompleteCountryField() {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: size_22, horizontal: size_24),
      decoration: BoxDecoration(
          color: colorFieldBG.withOpacity(0.5),
          borderRadius: BorderRadius.circular(size_10),
          border: Border.all(
              color: colorFieldBorder.withOpacity(0.18), width: size_1)),
      child: TypeAheadFormField(
        hideOnEmpty: true,
        hideOnError: true,
        autoFlipDirection: true,
        textFieldConfiguration: TextFieldConfiguration(
          controller: controller.countryController.value,
          style: AppText.textRegular
              .copyWith(fontSize: font_16, color: colorBlack),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          maxLines: 1,
          minLines: 1,
          onChanged: (value) {
            controller.selectedCountryId.value = "";
          },
          decoration: InputDecoration(
              hintText: 'hint_country_selection'.tr,
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.all(size_0),
              hintStyle: AppText.textRegular.copyWith(
                  color: colorBlack.withOpacity(0.56), fontSize: font_16)),
        ),
        onSuggestionSelected: (CountryListData suggestion) {
          controller.countryController.value =
              TextEditingController(text: suggestion.name);
          controller.selectedCountryId.value = suggestion.id;
          // controller.setModelData(0, suggestion);
        },
        suggestionsBoxDecoration: const SuggestionsBoxDecoration(
          constraints: BoxConstraints(maxHeight: 200.0),
        ),
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

  showEmailVerifyBottomSheet() {
    controller.callLoginApi();
    Get.bottomSheet(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 2,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4.0)),
            ).marginOnly(top: size_8),
            Text('Verify Email',
                style: AppText.textBold.copyWith(
                  fontSize: font_20,
                  color: colorBlack,
                  decoration: TextDecoration.underline,
                )).marginOnly(top: size_16, left: size_16, right: size_16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    'We have sent verification link to your email. Please verify your account. If you do not receive a confirmation email,',
                style: AppText.textRegular.copyWith(color: Colors.black87),
                children: const <TextSpan>[
                  TextSpan(
                      text: ' Please check your spam folder. ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                  TextSpan(
                      text:
                          'If you still do not receive an email, please contact support at info@berbe.net.'),
                ],
              ),
            ).marginOnly(top: size_16, left: size_16, right: size_16),
            WidgetBackgroundContainer(
              child: SizedBox(
                width: Get.width,
                child: Text(
                  'lbl_resend'.tr,
                  textAlign: TextAlign.center,
                  style: AppText.textBold
                      .copyWith(fontSize: font_18, color: colorWhite),
                ),
              ),
              cornerRadius: size_10,
              paddingContainer: const EdgeInsetsDirectional.all(size_20),
              onClickAction: () {
                controller.callLoginApi();
              },
            ).marginOnly(
                top: size_40, left: size_16, right: size_16, bottom: size_40),
          ],
        ),
        backgroundColor: colorWhite,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        isDismissible: true,
        enableDrag: true);
  }

  showDeleteAccountBottomSheet() {
    Get.bottomSheet(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 2,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4.0)),
            ).marginOnly(top: size_10),
            Text('Delete Account',
                style: AppText.textBold.copyWith(
                  fontSize: font_20,
                  color: colorBlack,
                  decoration: TextDecoration.underline,
                )).marginOnly(top: size_20, left: size_16, right: size_16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Are you sure you want to delete your account?',
                style: AppText.textMedium.copyWith(color: Colors.black87),
                // children: const <TextSpan>[
                //   TextSpan(
                //       text: ' Please check your spam folder. ',
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold, color: Colors.red)),
                //   TextSpan(
                //       text:
                //           'If you still do not receive an email, please contact support at info@berbe.net.'),
                // ],
              ),
            ).marginOnly(top: size_16, left: size_16, right: size_16),
            WidgetBackgroundContainer(
              child: SizedBox(
                width: Get.width,
                child: Text(
                  'lbl_Delete'.tr,
                  textAlign: TextAlign.center,
                  style: AppText.textBold
                      .copyWith(fontSize: font_18, color: colorWhite),
                ),
              ),
              cornerRadius: size_10,
              paddingContainer: const EdgeInsetsDirectional.all(size_20),
              onClickAction: () {
                controller.callDeleteAccountApi();
              },
            ).marginOnly(
                top: size_40, left: size_16, right: size_16, bottom: size_30),
          ],
        ),
        backgroundColor: colorWhite,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        isDismissible: true,
        enableDrag: true);
  }
}
