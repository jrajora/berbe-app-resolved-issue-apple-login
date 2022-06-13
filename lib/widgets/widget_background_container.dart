import 'package:berbe/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class WidgetBackgroundContainer extends GetView {
  Widget child;
  double cornerRadius;
  VoidCallback? onClickAction;
  EdgeInsetsDirectional? paddingContainer;
  EdgeInsetsDirectional? marginContainer;
  bool isNeedToRemoveFocus;

  WidgetBackgroundContainer(
      {Key? key,
      required this.child,
      required this.cornerRadius,
      this.paddingContainer,
      this.marginContainer,
      this.onClickAction,
      this.isNeedToRemoveFocus = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Container(
        padding: paddingContainer ?? EdgeInsets.all(0.0),
        margin: marginContainer ?? const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [colorDarkSkyBlue, colorSkyBlue]),
            borderRadius: BorderRadius.all(Radius.circular(cornerRadius))),
        child: child,
      ),
      onTap: () {
        if (onClickAction != null) {
          if(isNeedToRemoveFocus) {
            removeFocus();
          }
          onClickAction!();
        }
      },
    );
  }
}
