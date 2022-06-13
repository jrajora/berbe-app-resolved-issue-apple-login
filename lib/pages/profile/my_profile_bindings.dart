import 'package:berbe/pages/profile/my_profile_controller.dart';
import 'package:get/get.dart';

class MyProfileBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<MyProfileController>(MyProfileController());
  }

}