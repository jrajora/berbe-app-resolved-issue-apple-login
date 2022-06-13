import 'package:berbe/pages/notification/notification_list_controller.dart';
import 'package:get/get.dart';

class NotificationListBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<NotificationListController>(NotificationListController());
  }

}