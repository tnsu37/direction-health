import 'package:boilerplate/common/api.dart';
import 'package:boilerplate/common/api_mappers.dart';
import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';

class ScenarioController extends GetxController {
  static ScenarioController get to => Get.find<ScenarioController>();

  final _api = ApiService();
  late Rx<FutureExposureResponse> result;
  RxString error = ''.obs;
  Map<String, dynamic> fetchedRequest = {};

  // 응답이 요청 순서와 다르게 도착해도 최신 요청 결과만 반영되도록 하는 시퀀스 가드
  int _fetchSeq = 0;

  Future<void> fetch() async {
    final seq = ++_fetchSeq;
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
      if (seq != _fetchSeq) return;

      fetchedRequest = {
        'mode': ApiMap.mode(subId),
        'target_period': ApiMap.period(mc.filterPeriod.value),
        'ssp': isTemp ? ApiMap.ssp(mc.filterScenario.value) : null,
        'gcm': isTemp ? ApiMap.gcm(mc.filterClimateModels) : null,
        'change_ap': !isTemp ? mc.filterConcChange.value : null,
      };
      result.value = res.data!;
      if (res.isEmpty) error.value = res.message ?? '데이터가 없습니다.';
    } on ApiException catch (e) {
      if (seq != _fetchSeq) return;
      error.value = e.message;
    } finally {
      if (seq == _fetchSeq) {
        mc.animationController.stop();
        Common.isLoading.value = false;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    result = FutureExposureResponse.empty.obs;
  }

  @override
  void onReady() {
    super.onReady();
    fetch();
  }
}
