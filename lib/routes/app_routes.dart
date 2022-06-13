part of 'app_pages.dart';

abstract class Routes {
  static const SPLASH = _Paths.SPLASH;
  static const SIGN_UP = _Paths.SIGN_UP;
  static const LOGIN = _Paths.LOGIN;
  static const FORGOT_PASS = _Paths.FORGOT_PASS;
  static const CHANGE_PASS = _Paths.CHANGE_PASS;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const MY_PROFILE = _Paths.MY_PROFILE;
  static const LANGUAGE = _Paths.LANGUAGE;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const SEARCH_DETAILS = _Paths.SEARCH_DETAILS;
  static const MORE_INFO = _Paths.MORE_INFO;
  static const APPLE_LOGIN = _Paths.APPLE_LOGIN;
  static const DELETE_ACCOUNT = _Paths.DELETE_ACCOUNT;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const SIGN_UP = '/singup';
  static const LOGIN = '/login';
  static const FORGOT_PASS = '/forgotPass';
  static const CHANGE_PASS = '/changePass';
  static const DASHBOARD = '/dashboard';
  static const MY_PROFILE = '/myProfile';
  static const LANGUAGE = '/language';
  static const NOTIFICATION = '/notification';
  static const SEARCH_DETAILS = '/searchDetails';
  static const MORE_INFO = '/moreInfo';
  static const APPLE_LOGIN = '/appleLogin';
  static const DELETE_ACCOUNT = '/delete-account';
}
