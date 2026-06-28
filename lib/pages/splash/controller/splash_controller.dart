import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    deviceInfo();
    super.onInit();
  }

  String path(str) {
    return (kIsWeb) ? 'assets/$str' : str;
  }

  deviceInfo() async {
    await const Duration(seconds: 2).delay();
    Get.offAllNamed('/onboarding');
  }
}
