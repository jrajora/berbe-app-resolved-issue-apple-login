import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_images.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:berbe/pages/signup/signup_controller.dart';
import 'package:berbe/pages/socialLogin/social_login_widget.dart';
import 'package:berbe/routes/app_pages.dart';
import 'package:berbe/widgets/scrollbehavior.dart';
import 'package:berbe/widgets/widget_background_container.dart';
import 'package:berbe/widgets/widget_common_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({Key? key}) : super(key: key);

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
              Expanded(
                  child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  padding: const EdgeInsetsDirectional.only(
                    start: paddingLeft,
                    end: paddingRight,
                    top: size_20,
                  ),
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
                    WidgetCommonTextField(
                      textEditingController: controller.emailController.value,
                      autoFillHint: const [AutofillHints.email],
                      inputDecoration: InputDecoration(
                          hintText: 'hint_enter_email'.tr,
                          hintStyle: AppText.textRegular
                              .copyWith(color: colorWhite.withOpacity(0.56))),
                      textStyle: AppText.textRegular.copyWith(
                          fontSize: font_16,
                          color: colorWhite.withOpacity(0.5)),
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                    ).marginOnly(top: size_40),
                    WidgetCommonTextField(
                            textEditingController:
                                controller.passwordController.value,
                            inputDecoration: InputDecoration(
                                hintText: 'hint_password'.tr,
                                hintStyle: AppText.textRegular.copyWith(
                                    color: colorWhite.withOpacity(0.56))),
                            textStyle: AppText.textRegular.copyWith(
                                fontSize: font_16,
                                color: colorWhite.withOpacity(0.5)),
                            inputType: TextInputType.text,
                            isPasswordFiled: true,
                            isObscureText: true,
                            inputAction: TextInputAction.next)
                        .marginOnly(top: size_28),
                    WidgetCommonTextField(
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
                        .marginOnly(top: size_28),
                    Obx(() => GestureDetector(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SvgPicture.asset(controller.isCheckTerm.value
                                  ? icCheckBox
                                  : icUnCheckBox),
                              Flexible(
                                child: Container(
                                  margin: const EdgeInsetsDirectional.only(
                                      start: size_12),
                                  child: /*Text(
                                    'lbl_accept_term'.tr,
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                    style: AppText.textRegular.copyWith(
                                        fontSize: font_14,
                                        color: colorTextGrey),
                                  ),*/
                                      RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: 'lbl_accept'.tr,
                                        style: AppText.textRegular.copyWith(
                                            fontSize: font_14,
                                            color: colorTextGrey),
                                      ),
                                      TextSpan(
                                        text: 'lbl_terms_condition'.tr,
                                        style: AppText.textRegular.copyWith(
                                            fontSize: font_14,
                                            color: colorTextBlue,
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            if (await canLaunch(
                                                "https://berbe.net/terms-and-condition")) {
                                              await launch(
                                                  "https://berbe.net/terms-and-condition");
                                            } else {
                                              // can't launch url, there is some error
                                              throw "Could not launch https://berbe.net/terms-and-condition";
                                            }
                                          },
                                      ),
                                    ]),
                                  ),
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            controller.changeFlagTerm();
                          },
                          behavior: HitTestBehavior.opaque,
                        ).marginOnly(top: size_24)),
                    WidgetBackgroundContainer(
                      child: Text(
                        'lbl_sign_up'.tr,
                        textAlign: TextAlign.center,
                        style: AppText.textBold
                            .copyWith(fontSize: font_18, color: colorWhite),
                      ),
                      cornerRadius: size_10,
                      paddingContainer:
                          const EdgeInsetsDirectional.all(size_20),
                      onClickAction: () {
                        controller.callSignUpApi();
                      },
                    ).marginOnly(top: size_40),
                    Align(
                      child: Text(
                        'lbl_or_continue_with'.tr,
                        style: AppText.textRegular.copyWith(
                            color: colorWhite.withOpacity(0.5),
                            fontSize: font_18),
                      ),
                      alignment: AlignmentDirectional.center,
                    ).marginOnly(top: size_20),
                    const SocialLoginWidget().marginOnly(top: size_14),
                    MediaQuery.of(context).viewInsets.bottom == 0
                        ? Container()
                        : widgetLogin(const EdgeInsetsDirectional.only(
                            bottom: size_30, top: size_30)),
                    MediaQuery.of(context).viewInsets.bottom == 0
                        ? widgetLogin(const EdgeInsetsDirectional.only(
                        bottom: size_30,
                        top: size_30,
                        end: size_20,
                        start: size_20))
                        : Container(),
                  ],
                ),
              )),

            ],
          ),
        ),
      ),
    );
  }

  Widget widgetLogin(EdgeInsetsDirectional padding) {
    return Container(
      padding: padding,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: 'lbl_already_have_account'.tr,
              style: AppText.textRegular.copyWith(
                  color: colorWhite.withOpacity(0.5), fontSize: font_18)),
          TextSpan(
            text: 'lbl_sign_in'.tr,
            style: AppText.textBold
                .copyWith(color: colorTextBlue, fontSize: font_18),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.offAllNamed(Routes.LOGIN);
              },
          ),
        ]),
      ),
    );
  }
}
