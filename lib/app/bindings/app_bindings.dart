import 'package:aia/app/core/controller/storage_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageController());
  }
}
