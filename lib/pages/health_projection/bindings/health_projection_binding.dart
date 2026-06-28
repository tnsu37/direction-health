import 'package:get/get.dart';
import '../controller/health_projection_controller.dart';

class HealthProjectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthProjectionController());
  }
}
