import 'package:berbe/pages/changePass/change_password_bindings.dart';
import 'package:berbe/pages/changePass/change_password_view.dart';
import 'package:berbe/pages/dashboard/dashboard_bindings.dart';
import 'package:berbe/pages/dashboard/dashboard_view.dart';
import 'package:berbe/pages/forgotPass/forgot_password_bindings.dart';
import 'package:berbe/pages/forgotPass/forgot_password_view.dart';
import 'package:berbe/pages/language/language_list_bindings.dart';
import 'package:berbe/pages/language/language_list_view.dart';
import 'package:berbe/pages/login/login_bindings.dart';
import 'package:berbe/pages/login/login_view.dart';
import 'package:berbe/pages/moreInfo/more_info_bindings.dart';
import 'package:berbe/pages/moreInfo/more_info_view.dart';
import 'package:berbe/pages/notification/notification_list_bindings.dart';
import 'package:berbe/pages/notification/notification_list_view.dart';
import 'package:berbe/pages/profile/my_profile_bindings.dart';
import 'package:berbe/pages/profile/my_profile_view.dart';
import 'package:berbe/pages/searchDetails/search_details_bindings.dart';
import 'package:berbe/pages/searchDetails/search_details_view.dart';
import 'package:berbe/pages/signup/signup_bindings.dart';
import 'package:berbe/pages/signup/signup_view.dart';
import 'package:berbe/pages/socialLogin/apple_login_view.dart';
import 'package:berbe/pages/splash/splash_bindings.dart';
import 'package:berbe/pages/splash/splash_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
        name: _Paths.SPLASH,
        page: () => const SplashView(),
        binding: SplashBindings()),
    GetPage(
        name: _Paths.LOGIN,
        page: () => const LoginView(),
        binding: LoginBindings()),
    GetPage(
        name: _Paths.SIGN_UP,
        page: () => const SignUpView(),
        binding: SignUpBindings()),
    GetPage(
        name: _Paths.FORGOT_PASS,
        page: () => const ForgotPasswordView(),
        binding: ForgotPasswordBindings()),
    GetPage(
        name: _Paths.CHANGE_PASS,
        page: () => const ChangePasswordView(),
        binding: ChangePasswordBindings()),
    GetPage(
        name: _Paths.DASHBOARD,
        page: () => const DashboardView(),
        binding: DashboardBindings()),
    GetPage(
        name: _Paths.MY_PROFILE,
        page: () => const MyProfileView(),
        binding: MyProfileBindings()),
    GetPage(
        name: _Paths.LANGUAGE,
        page: () => const LanguageListView(),
        binding: LanguageListBindings()),
    GetPage(
        name: _Paths.NOTIFICATION,
        page: () => const NotificationListView(),
        binding: NotificationListBindings()),
    GetPage(
        name: _Paths.SEARCH_DETAILS,
        page: () => const SearchDetailsView(),
        binding: SearchDetailsBindings()),
    GetPage(
        name: _Paths.MORE_INFO,
        page: () => const MoreInfoView(),
        binding: MoreInfoBindings()),
    GetPage(
        name: _Paths.APPLE_LOGIN,
        page: () => const AppleLoginView(),
        binding: LoginBindings()),
  ];
}
