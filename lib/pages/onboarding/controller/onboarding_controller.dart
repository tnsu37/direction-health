import 'package:get/get.dart';

class OnboardingController extends GetxController {
  Map<String, List<String>> value = {
    '노출': ['연중 온도', '여름철 온도', 'PM2.5', 'O3'],
    '건강 영향': ['사망', '쯔쯔가무시병', '말라리아', '수인성 감염병'],
    '미래 예측': ['기후변화 시나리오', '건강영향 미래 추정']
  };

  List<String> category = ['노출', '건강 영향', '미래 예측'];

  void selet(index) {
    Get.toNamed('/main', arguments: index);
  }
}
