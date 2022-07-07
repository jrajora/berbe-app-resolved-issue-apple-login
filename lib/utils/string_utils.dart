import 'dart:ui';

bool checkString(String? value) =>
    value == null || value
        .toString()
        .trim()
        .isEmpty;

bool checkZeroString(String? value) =>
    value == null || value == "0" || value
      .toString()
      .trim()
      .isEmpty;

String  defaultStringValue(String? value, String def) =>
    value == null || value
        .toString()
        .trim()
        .isEmpty ? def : value;

bool isValidEmail(String em) {
  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(em);
}


const String TYPE_CAMERA = "camera";
const String TYPE_GALLERY = "gallery";

const ANDROID_CUSTOMER = "android";
const IOS_CUSTOMER = "ios";