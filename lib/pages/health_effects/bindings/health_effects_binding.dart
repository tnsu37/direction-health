import 'package:get/get.dart';
import '../controller/health_effects_controller.dart';

class HealthEffectsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthEffectsController());
  }
}
