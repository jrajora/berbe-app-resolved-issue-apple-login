import 'package:berbe/pages/searchDetails/search_details_controller.dart';
import 'package:get/get.dart';

class SearchDetailsBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<SearchDetailsController>(SearchDetailsController());
  }

}