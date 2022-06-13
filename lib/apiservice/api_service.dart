import 'dart:convert';

import 'package:berbe/main.dart';
import 'package:berbe/routes/app_pages.dart';
import 'package:berbe/utils/storage_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

abstract class ApiService {
  // static const BASE_URL = "http://18.170.147.243/api/";
  static const DEV_URL = "https://dev.berbe.net/api/";
  static const BETA_URL = "https://beta.berbe.net/api/";

  // /* LIVE*/
  static String LIVE_PRODUCTION_URL = "https://api.berbe.net/api/";
  static String LIVE_PRODUCTION_APPLE_LOGIN_REDIRECTION =
      "https://api.berbe.net/app/apple/callback";
  static String LIVE_APPLE_LOGIN_URL = "https://api.berbe.net/app/apple/login";

  /* TEST*/
  static String TEST_PRODUCTION_URL = "https://tm.berbe.net/api/";
  static String TEST_PRODUCTION_APPLE_LOGIN_REDIRECTION =
      "https://tm.berbe.net/app/apple/callback";

  static String TEST_APPLE_LOGIN_URL = "https://tm.berbe.net/app/apple/login";

  /* TEST*/
  static String PRODUCTION_URL =
      kReleaseMode ? LIVE_PRODUCTION_URL : TEST_PRODUCTION_URL;
  static String PRODUCTION_APPLE_LOGIN_REDIRECTION = kReleaseMode
      ? LIVE_PRODUCTION_APPLE_LOGIN_REDIRECTION
      : TEST_PRODUCTION_APPLE_LOGIN_REDIRECTION;

  static String APPLE_LOGIN_URL =
      kReleaseMode ? LIVE_APPLE_LOGIN_URL : TEST_APPLE_LOGIN_URL;

  /*static String BASE_URL =  kDebugMode
          ? DEV_URL
          : kProfileMode
              ? BETA_URL
              : kReleaseMode
                  ? PRODUCTION_URL
                  : DEV_URL;*/
  static String BASE_URL = PRODUCTION_URL;

  static const CUSTOMER = "Customer/";

  static const init = "init";
  static const login = "login";
  static const socialLogin = "social-login";
  static const register = "register";
  static const forgotPassword = "forgot-password";
  static const changePassword = "change-password";
  static const logout = "logout";
  static const countryList = "country-list";
  static const deleteAccount = "delete-account";
  static const updateProfile = "update-profile";
  static const search = "search";
  static const banner = "banner";
  static const advertisement = "advertisement";
  static const myprofile = "${CUSTOMER}myprofile";
  static const getProfile = "profile";
  static const resendVerificationLink = "resend/verification-link";

  static const SUCCESS = 200;
  static const UNAUTHORISED = 403;
  static var httpClient = http.Client();

  static Future<Map<String, dynamic>?> callGetApi(
      String endPoint, BuildContext? context, Function? onError) async {
    var token = await StorageUtil.getData(StorageUtil.keyToken);
    var languageCode = await StorageUtil.getData(StorageUtil.keyLanguageCode);

    Map<String, String> header = <String, String>{};
    header.addAll({
      'X-localization': languageCode ?? "en",
      'Accept': 'application/json',
    });
    if (token != null) {
      header.addAll({
        'Authorization': 'Bearer $token',
      });
    }
    print("ApiService GET Api: ${BASE_URL + endPoint}");
    print("ApiService Api Header: $header");

    var response =
        await httpClient.get(Uri.parse(BASE_URL + endPoint), headers: header);

    print("ApiService GET Response Code : ${response.statusCode}");
    print("ApiService GET Response : ${json.decode(response.body)}");
    if (response.statusCode == SUCCESS) {
      return jsonDecode(response.body);
    } else if (response.statusCode == UNAUTHORISED) {
      //TODO : Expired Login
      if (onError != null) {
        onError();
      }
      print("ApiService Post Response Code : ${response.statusCode}");
      openAndCloseLoadingDialog(false);
      /*forceLogoutDialog(
          'lbl_session_expired'.tr, 'lbl_session_expired_msg'.tr, Get.context!);*/
      forceLogoutApiCall();
      return null;
    } else {
      if (onError != null) {
        onError();
      }
      openAndCloseLoadingDialog(false);
      showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
      return null;
    }
  }

  static Future<Map<String, dynamic>?> callPostApi(
      String endPoint,
      Map<String, dynamic> params,
      BuildContext? context,
      Function? onError) async {
    var token = await StorageUtil.getData(StorageUtil.keyToken);

    var languageCode = await StorageUtil.getData(StorageUtil.keyLanguageCode);

    Map<String, String> header = <String, String>{};
    header.addAll({
      'X-localization': languageCode ?? "en",
      'Accept': 'application/json',
    });
    if (token != null) {
      header.addAll({
        'Authorization': 'Bearer $token',
      });
    }
    print("ApiService Post Api: ${BASE_URL + endPoint}");
    print("ApiService Api Header: $header");
    print("ApiService Api Params: ${jsonEncode(params)}");

    var response = await httpClient.post(Uri.parse(BASE_URL + endPoint),
        headers: header, body: params);

    print("ApiService Post Response Code : ${response.statusCode}");
    print("ApiService Post Response : ${json.decode(response.body)}");
    if (response.statusCode == SUCCESS) {
      return jsonDecode(response.body);
    } else if (response.statusCode == UNAUTHORISED) {
      //TODO : Expired Login
      if (onError != null) {
        onError();
      }
      print("ApiService Post Response Code : ${response.statusCode}");
      openAndCloseLoadingDialog(false);
      /*forceLogoutDialog(
          'lbl_session_expired'.tr, 'lbl_session_expired_msg'.tr, Get.context!);*/
      forceLogoutApiCall();

      return null;
    } else {
      if (onError != null) {
        onError();
      }
      openAndCloseLoadingDialog(false);
      showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
      return null;
    }
  }

  static void forceLogoutDialog(
      String stTitle, String message, BuildContext context) {
    print("ApiService Post Response Code :");
    Widget content = Text(message);
    Widget title = Text(stTitle);
    final actions = <Widget>[
      TextButton(
        onPressed: () {
          forceLogoutApiCall();
        },
        child: Text('lbl_ok'.tr.toUpperCase()),
      ),
    ];

    Future.delayed(const Duration(seconds: 1), () {
      showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (dialogContext) {
          return GetPlatform.isIOS
              ? CupertinoAlertDialog(
                  title: title,
                  content: content,
                  actions: actions,
                )
              : AlertDialog(
                  title: title,
                  content: content,
                  actions: actions,
                );
        },
      );
    });
  }

  static void forceLogoutApiCall() {
    // Get.back();
    StorageUtil.clearLoginData();
    Get.offAllNamed(Routes.LOGIN);
  }
}
