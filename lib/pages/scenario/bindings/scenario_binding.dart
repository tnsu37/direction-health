import 'package:get/get.dart';
import '../controller/scenario_controller.dart';

class ScenarioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScenarioController());
  }
}
