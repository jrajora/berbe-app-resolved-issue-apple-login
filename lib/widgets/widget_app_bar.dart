import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetAppBar extends GetView {
  Widget? prefixWidget;
  Widget? postfixWidget;
  String headerTitle;

  WidgetAppBar(
      {Key? key,
      required this.headerTitle,
      this.prefixWidget,
      this.postfixWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsetsDirectional.only(
          start: paddingLeft, end: paddingRight, top: size_15, bottom: size_20),
      decoration: BoxDecoration(
        color: colorToolbarBG,
        borderRadius: const BorderRadiusDirectional.only(
          bottomStart: Radius.circular(size_32),
          bottomEnd: Radius.circular(size_32),
        ),
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.16),
            spreadRadius: 5,
            blurRadius: 13,
            offset: const Offset(0, 8), // changes position of shadow
          ),
        ],
      ),
      width: double.infinity,
      child: Stack(
        children: [
          prefixWidget ?? Container(),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                headerTitle,
                softWrap: true,
                style: AppText.textBold.copyWith(
                    color: colorWhite, fontSize: font_18, height: 1.5),
              ),
            ),
          ),
          postfixWidget != null
              ? Positioned.fill(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: postfixWidget,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
