import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_constant.dart';
import 'package:berbe/constants/app_fonts.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/localization/locale_string.dart';
import 'package:berbe/pages/splash/splash_bindings.dart';
import 'package:berbe/routes/app_pages.dart';
import 'package:berbe/utils/storage_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'manager/my_notification_manager.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
///
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  // handleNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  MyNotificationManager().init();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(
    GetMaterialApp(
      title: 'Berbe',
      initialRoute: AppPages.INITIAL,
      initialBinding: SplashBindings(),
      getPages: AppPages.routes,
      enableLog: true,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: APP_FONT,
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        CountryLocalizations.delegate,
      ],
      translations: LocaleString(),
      locale: const Locale('en', ''),
      fallbackLocale: const Locale('en', ''),
      supportedLocales: listLocale,
    ),
  );
}

void removeFocus() {
  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
}

void showSnackBar(BuildContext context, String message) {
  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    snackStyle: SnackStyle.FLOATING,
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    ),
    titleText: Container(),
    borderRadius: size_4,
    backgroundColor: Colors.black,
    colorText: Theme.of(context).colorScheme.surface,
    isDismissible: false,
    animationDuration: const Duration(milliseconds: 500),
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(size_10),
    /*mainButton: TextButton(
      child: Text('Undo'),
      onPressed: () {},
    ),*/
  );
}

Future<void> openAndCloseLoadingDialog(bool isShowHide) async {
  if (Get.overlayContext != null) {
    if (isShowHide) {
      showDialog(
        barrierColor: Colors.black.withOpacity(0.75),
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    } else {
      Navigator.pop(Get.overlayContext!);
    }
  }
}

Future<bool> checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    showSnackBar(Get.context!, 'msg_check_connection'.tr);
    return false;
  } else {
    return true;
  }
}

void saveLanguageData(
    String languageCode, String countryCode, String languageName) {
  StorageUtil.setData(StorageUtil.keyLanguageCode, languageCode);
  StorageUtil.setData(StorageUtil.keyCountryCode, countryCode);
  StorageUtil.setData(StorageUtil.keyLanguageName, languageName);
}

Future<void> logGoogleAnalyticsEvent(
    String eventName, Map<String, String> params) async {
  await FirebaseAnalytics.instance.logEvent(
    name: eventName,
    parameters: params,
  );
}

void shareAppContent() {
  Share.share('${'lbl_share_content'.tr}'
//for samsung store share link  'https://galaxystore.samsung.com/detail/com.app.berbe' || 'https://galaxy.store/berbe'
// '\n\nGalaxy : https://galaxystore.samsung.com/detail/com.app.berbe'
      '\n\nAndroid : https://play.google.com/store/apps/details?id=com.app.berbe'
      '\n\niOS : https://apps.apple.com/app/id1608346758'
      '\n\nWebsite : https://berbe.net/');
}
