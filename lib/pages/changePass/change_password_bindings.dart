import 'package:berbe/pages/changePass/change_password_controller.dart';
import 'package:get/get.dart';

class ChangePasswordBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ChangePasswordController>(ChangePasswordController());
  }

}