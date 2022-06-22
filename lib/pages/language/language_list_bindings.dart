import 'package:berbe/pages/language/language_list_controller.dart';
import 'package:get/get.dart';

class LanguageListBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<LanguageListController>(LanguageListController());
  }
}
