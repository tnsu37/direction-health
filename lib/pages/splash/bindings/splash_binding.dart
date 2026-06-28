import 'package:get/get.dart';

import '../controller/splash_controller.dart';

class SplashBinding extends Bindings {
  
  
  @override
  void dependencies() {
    // Get.put(MyPageController());
    // Get.lazyPut(() => MainController(), fenix: true);
    Get.lazyPut(() => SplashController());
  }
}
