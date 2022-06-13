import 'package:berbe/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'app_size.dart';

class AppText {
  static var textRegular =
      const TextStyle(fontSize: font_16, color: colorBlack);

  static var textLight = textRegular.copyWith(fontWeight: FontWeight.w100);

  static var textMedium = textRegular.copyWith(fontWeight: FontWeight.w500);

  static var textSemiBold = textRegular.copyWith(fontWeight: FontWeight.w600);

  static var textBold = textRegular.copyWith(fontWeight: FontWeight.bold);

  /*static var textHintStyle = TextStyle(
    fontSize: font_16,
    color: Colors.black54,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static var textLabelStyle = TextStyle(
    fontSize: font_16,
    color: Colors.black54,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );*/
}
