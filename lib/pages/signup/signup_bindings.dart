import 'package:berbe/pages/signup/signup_controller.dart';
import 'package:get/get.dart';

class SignUpBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<SignUpController>(SignUpController());
  }

}