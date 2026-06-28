import 'package:get/get.dart';
import '../controller/exposure_controller.dart';

class ExposureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExposureController());
  }
}
