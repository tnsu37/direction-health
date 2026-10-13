import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  Map<String, List<String>> value = {
    '노출': ['연중 온도', '여름철 온도', 'PM2.5', 'O3'],
    '건강 영향': ['사망', '쯔쯔가무시병', '말라리아', '수인성 감염병'],
    '미래 예측': ['기후변화 시나리오', '건강영향 미래 추정']
  };

  List<String> category = ['노출', '건강 영향', '미래 예측'];

  void select(int index) {
    if (Get.isRegistered<MainController>()) {
      // MainController가 이미 존재하면 직접 메뉴 변경
      MainController.to.selectMenuByIndex(index);

      // 현재 main이 아니라면 main으로 이동
      if (Get.currentRoute != '/main') {
        Get.toNamed('/main');
      }
    } else {
      // MainController가 아직 만들어지지 않았다면
      // 기존처럼 argument를 전달
      Get.toNamed('/main', arguments: index);
    }
  }
}
