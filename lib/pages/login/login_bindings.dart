import 'package:berbe/pages/login/login_controller.dart';
import 'package:berbe/pages/socialLogin/social_login_controller.dart';
import 'package:get/get.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
    Get.put<SocialLoginController>(SocialLoginController());
  }
}
