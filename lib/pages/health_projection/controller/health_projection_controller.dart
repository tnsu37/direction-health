import 'package:boilerplate/common/api.dart';
import 'package:boilerplate/common/api_mappers.dart';
import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';

class HealthProjectionController extends GetxController {
  static HealthProjectionController get to =>
      Get.find<HealthProjectionController>();

  final _api = ApiService();
  late Rx<FutureProjectionResponse> result;
  RxString error = ''.obs;
  Map<String, dynamic> fetchedRequest = {};

  // 응답이 요청 순서와 다르게 도착해도 최신 요청 결과만 반영되도록 하는 시퀀스 가드
  int _fetchSeq = 0;

  Future<void> fetch() async {
    final seq = ++_fetchSeq;
    final mc = MainController.to;
    final subId = mc.selectedSubId.value;
    final isPM25 = subId == 'death_pm25';
    final isO3 = subId == 'death_o3';
    final isAP = isPM25 || isO3; // 대기오염(PM2.5/O3): change_ap_ 필수, gcm_ 미사용
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
        ssp_: !isPM25 ? ApiMap.ssp(mc.filterScenario.value) : null,
        gcm_: !isAP ? ApiMap.gcm(mc.filterClimateModels) : null,
        policy_: ApiMap.policy(mc.filterAdaptation.value),
        changeAp_: isAP ? mc.filterConcChange.value : null,
      );
      if (seq != _fetchSeq) return;

      fetchedRequest = {
        'mode': ApiMap.mode(subId),
        'ssp_': !isPM25 ? ApiMap.ssp(mc.filterScenario.value) : null,
        'gcm_': !isAP ? ApiMap.gcm(mc.filterClimateModels) : null,
        'change_ap_': isAP ? mc.filterConcChange.value : null,
        'policy_': ApiMap.policy(mc.filterAdaptation.value),
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
    result = FutureProjectionResponse.empty.obs;
  }

  @override
  void onReady() {
    super.onReady();
    fetch();
  }
}
