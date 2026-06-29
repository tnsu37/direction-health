import 'package:boilerplate/common/api.dart';
import 'package:boilerplate/common/api_mappers.dart';
import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';

class ScenarioController extends GetxController {
  static ScenarioController get to => Get.find<ScenarioController>();

  final _api = ApiService();
  final Rx<FutureExposureResponse?> result = Rx(null);
  RxString error = ''.obs;
  Map<String, dynamic> fetchedRequest = {};

  Future<void> fetch() async {
    final mc = MainController.to;
    final subId = mc.selectedSubId.value;
    final isTemp = subId == 'annualTemp' || subId == 'summerTemp';
    Common.isLoading.value = true;
    mc.animationController.repeat();
    error.value = '';
    try {
      final res = await _api.futureExposure(
        mode: ApiMap.mode(subId),
        sido_: mc.filterSido.value,
        sgg_: mc.filterSigungu.value,
        targetPeriod: ApiMap.period(mc.filterPeriod.value),
        ssp_: isTemp ? ApiMap.ssp(mc.filterScenario.value) : null,
        gcm_: isTemp ? ApiMap.gcm(mc.filterClimateModels) : null,
        changeAp_: !isTemp ? mc.filterConcChange.value : null,
      );
      fetchedRequest = {
        'mode': ApiMap.mode(subId),
        'target_period': ApiMap.period(mc.filterPeriod.value),
        'ssp': isTemp ? ApiMap.ssp(mc.filterScenario.value) : null,
        'gcm': isTemp ? ApiMap.gcm(mc.filterClimateModels) : null,
        'change_ap': !isTemp ? mc.filterConcChange.value : null,
      };
      result.value = res.data;
      if (res.isEmpty) error.value = res.message ?? '데이터가 없습니다.';
    } on ApiException catch (e) {
      error.value = e.message;
    } finally {
      mc.animationController.stop();
      Common.isLoading.value = false;
    }
  }
}
