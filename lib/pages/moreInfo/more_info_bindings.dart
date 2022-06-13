import 'package:berbe/pages/moreInfo/more_info_controller.dart';
import 'package:get/get.dart';

class MoreInfoBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<MoreInfoController>(MoreInfoController());
  }

}