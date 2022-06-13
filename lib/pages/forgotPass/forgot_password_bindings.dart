import 'package:berbe/pages/forgotPass/forgot_password_controller.dart';
import 'package:get/get.dart';

class ForgotPasswordBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ForgotPasswordController>(ForgotPasswordController());
  }

}