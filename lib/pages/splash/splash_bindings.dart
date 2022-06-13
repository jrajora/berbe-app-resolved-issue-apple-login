import 'package:berbe/pages/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }

}