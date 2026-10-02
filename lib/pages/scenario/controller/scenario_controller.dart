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

  // 조회 버튼을 눌러 요청이 완료된 시점의 값으로만 갱신 (필터를 바꾸는 즉시 바뀌지 않도록).
  String chartTitle = '';

  // 응답이 요청 순서와 다르게 도착해도 최신 요청 결과만 반영되도록 하는 시퀀스 가드
  int _fetchSeq = 0;

  Future<void> fetch() async {
    final seq = ++_fetchSeq;
    final mc = MainController.to;
    final subId = mc.selectedSubId.value;
    final isTemp = subId == 'annualTemp' || subId == 'summerTemp';
    final sido = mc.filterSido.value;
    final sgg = mc.filterSigungu.value;
    Common.isLoading.value = true;
    mc.animationController.repeat();
    error.value = '';
    try {
      final res = await _api.futureExposure(
        mode: ApiMap.mode(subId),
        sido_: sido,
        sgg_: sgg,
        targetPeriod: ApiMap.period(mc.filterPeriod.value),
        ssp_: isTemp ? ApiMap.ssp(mc.filterScenario.value) : null,
        gcm_: isTemp ? ApiMap.gcm(mc.filterClimateModels) : null,
        changeAp_: !isTemp ? mc.filterConcChange.value : null,
      );
      if (seq != _fetchSeq) return;

      fetchedRequest = {
        'mode': ApiMap.mode(subId),
        'sido_': sido,
        'sgg_': sgg,
        'target_period': ApiMap.period(mc.filterPeriod.value),
        'ssp': isTemp ? ApiMap.ssp(mc.filterScenario.value) : null,
        'gcm': isTemp ? ApiMap.gcm(mc.filterClimateModels) : null,
        'change_ap': !isTemp ? mc.filterConcChange.value : null,
      };
      chartTitle = _buildChartTitle(
        sido: sido,
        sgg: sgg,
        mode: ApiMap.mode(subId),
        isTemp: isTemp,
        ssp: isTemp ? ApiMap.ssp(mc.filterScenario.value) : '',
      );
      result.value = res.data!;
      if (res.isEmpty) error.value = res.message ?? '데이터가 없습니다.';
    } on ApiException catch (e) {
      if (seq != _fetchSeq) return;
      chartTitle = _buildChartTitle(
        sido: sido,
        sgg: sgg,
        mode: ApiMap.mode(subId),
        isTemp: isTemp,
        ssp: isTemp ? ApiMap.ssp(mc.filterScenario.value) : '',
      );
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
    required bool isTemp,
    required String ssp,
  }) {
    final regionPart = [
      if (sido != '전체' && sido.isNotEmpty) sido,
      if (sgg != '전체' && sgg.isNotEmpty) sgg,
    ].join(' ');
    final region = regionPart.isNotEmpty ? regionPart : '전국';

    if (isTemp) {
      return '$region ${_sspLabel(ssp)} 시나리오';
    } else {
      return '$region $mode 증감 수준별 미래 평균농도';
    }
  }

  String _sspLabel(String ssp) {
    const table = {
      'SSP126': 'SSP1-2.6',
      'SSP245': 'SSP2-4.5',
      'SSP370': 'SSP3-7.0',
      'SSP585': 'SSP5-8.5',
    };
    return table[ssp] ?? ssp;
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
