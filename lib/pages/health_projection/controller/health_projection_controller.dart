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

  // 조회 버튼을 눌러 요청이 완료된 시점의 값으로만 갱신 (필터를 바꾸는 즉시 바뀌지 않도록).
  String chartTitle = '';

  // 응답이 요청 순서와 다르게 도착해도 최신 요청 결과만 반영되도록 하는 시퀀스 가드
  int _fetchSeq = 0;

  Future<void> fetch() async {
    final seq = ++_fetchSeq;
    final mc = MainController.to;
    final subId = mc.selectedSubId.value;
    final isPM25 = subId == 'death_pm25';
    final isO3 = subId == 'death_o3';
    final isAP = isPM25 || isO3; // 대기오염(PM2.5/O3): change_ap_ 필수, gcm_ 미사용
    final sido = mc.filterSido.value;
    final sgg = mc.filterSigungu.value;
    Common.isLoading.value = true;
    mc.animationController.repeat();
    error.value = '';
    try {
      final res = await _api.futureProjection(
        mode: ApiMap.mode(subId),
        evalGroup: ApiMap.evalGroup(mc.filterEvalGroup.value),
        sido_: sido,
        sgg_: sgg,
        targetPeriod: ApiMap.period(mc.filterPeriod.value),
        ssp_: !isPM25 ? ApiMap.ssp(mc.filterScenario.value) : null,
        gcm_: !isAP ? ApiMap.gcm(mc.filterClimateModels) : null,
        policy_: ApiMap.policy(mc.filterAdaptation.value),
        changeAp_: isAP ? mc.filterConcChange.value : null,
      );
      if (seq != _fetchSeq) return;

      fetchedRequest = {
        'mode': ApiMap.mode(subId),
        'sido_': sido,
        'sgg_': sgg,
        'ssp_': !isPM25 ? ApiMap.ssp(mc.filterScenario.value) : null,
        'gcm_': !isAP ? ApiMap.gcm(mc.filterClimateModels) : null,
        'change_ap_': isAP ? mc.filterConcChange.value : null,
        'policy_': ApiMap.policy(mc.filterAdaptation.value),
      };
      chartTitle =
          _buildChartTitle(sido: sido, sgg: sgg, mode: ApiMap.mode(subId));
      result.value = res.data!;
      if (res.isEmpty) error.value = res.message ?? '데이터가 없습니다.';
    } on ApiException catch (e) {
      if (seq != _fetchSeq) return;
      chartTitle = _buildChartTitle(sido: sido, sgg: sgg, mode: ApiMap.mode(subId));
      error.value = e.message;
    } finally {
      if (seq == _fetchSeq) {
        mc.animationController.stop();
        Common.isLoading.value = false;
      }
    }
  }

  String _buildChartTitle({
    required String sido,
    required String sgg,
    required String mode,
  }) {
    final regionPart = [
      if (sido != '전체' && sido.isNotEmpty) sido,
      if (sgg != '전체' && sgg.isNotEmpty) sgg,
    ].join(' ');
    final region = regionPart.isNotEmpty ? regionPart : '전국';
    final isDeath = mode == '여름철 온도' || mode == 'PM2.5' || mode == 'O3';
    return '$region ${Common.subscriptPollutant(mode)} ${isDeath ? '초과사망자수' : '초과발생건수'}';
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
