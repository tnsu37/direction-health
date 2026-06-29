import 'package:boilerplate/common/api.dart';
import 'package:boilerplate/common/api_mappers.dart';
import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';

class HealthProjectionController extends GetxController {
  static HealthProjectionController get to =>
      Get.find<HealthProjectionController>();

  final _api = ApiService();
  final Rx<FutureProjectionResponse?> result = Rx(null);
  RxString error = ''.obs;
  Map<String, dynamic> fetchedRequest = {};

  Future<void> fetch() async {
    final mc = MainController.to;
    final subId = mc.selectedSubId.value;
    final isTemp = subId == 'death_summer';
    final isAP = subId == 'death_pm25';
    Common.isLoading.value = true;
    mc.animationController.repeat();
    error.value = '';
    try {
      final res = await _api.futureProjection(
        mode: ApiMap.mode(subId),
        evalGroup: ApiMap.evalGroup(mc.filterEvalGroup.value),
        sido_: mc.filterSido.value,
        sgg_: mc.filterSigungu.value,
        targetPeriod: ApiMap.period(mc.filterPeriod.value),
        ssp_: (isTemp || !isAP) ? ApiMap.ssp(mc.filterScenario.value) : null,
        gcm_: (isTemp || !isAP) ? ApiMap.gcm(mc.filterClimateModels) : null,
        policy_: ApiMap.policy(mc.filterAdaptation.value),
        changeAp_: isAP ? mc.filterConcChange.value : null,
      );
      fetchedRequest = {
        'mode': ApiMap.mode(subId),
        'ssp_': (isTemp || !isAP) ? ApiMap.ssp(mc.filterScenario.value) : null,
        'gcm_': (isTemp || !isAP) ? ApiMap.gcm(mc.filterClimateModels) : null,
        'change_ap_': isAP ? mc.filterConcChange.value : null,
        'policy_': ApiMap.policy(mc.filterAdaptation.value),
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
