import 'package:boilerplate/common/api.dart';
import 'package:boilerplate/common/api_mappers.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';
import '../../../common/common.dart';

class HealthEffectsController extends GetxController {
  static HealthEffectsController get to => Get.find<HealthEffectsController>();

  final _api = ApiService();
  late Rx<PastHealthRiskResponse> result;
  RxString error = ''.obs;

  String fetchedSido = '서울특별시';
  String mapTitle = '말라리아 (서울특별시)';
  Map<String, dynamic> fetchedRequest = {
    'mode': '말라리아',
    'eval_group': '전체',
    'sido_': '서울특별시',
    'sgg_': '강서구',
  };

  List<MapDataEntry> get exposureMapData => result.value.exposureData
      .map((e) => MapDataEntry(sggCode: e.sggCode, value: e.expVal))
      .toList();

  List<MapDataEntry> get riskMapData => result.value.riskData
      .map((e) => MapDataEntry(sggCode: e.sggCode, value: e.anVal))
      .toList();

  String get riskUnit {
    final mode = fetchedRequest['mode']?.toString() ?? '';
    return (mode == '여름철 온도' || mode == 'PM2.5' || mode == 'O3')
        ? '기여사망자수'
        : '기여발생건수';
  }

  // 응답이 요청 순서와 다르게 도착해도 최신 요청 결과만 반영되도록 하는 시퀀스 가드
  int _fetchSeq = 0;

  Future<void> fetch() async {
    final seq = ++_fetchSeq;
    final mc = MainController.to;
    Common.isLoading.value = true;
    mc.animationController.repeat();
    error.value = '';
    try {
      final res = await _api.pastHealthRisk(
        mode: ApiMap.mode(mc.selectedSubId.value),
        evalGroup: ApiMap.evalGroup(mc.filterEvalGroup.value),
        sido_: mc.filterSido.value,
        sgg_: mc.filterSigungu.value,
      );
      if (seq != _fetchSeq) return;

      fetchedSido = mc.filterSido.value;
      fetchedRequest = {
        'mode': ApiMap.mode(mc.selectedSubId.value),
        'eval_group': ApiMap.evalGroup(mc.filterEvalGroup.value),
        'sido_': mc.filterSido.value,
        'sgg_': mc.filterSigungu.value,
      };
      mapTitle = _buildTitle(mc);
      result.value = res.data ?? PastHealthRiskResponse.empty;
      if (res.isEmpty) error.value = res.message ?? '데이터가 없습니다.';
    } on ApiException catch (e) {
      if (seq != _fetchSeq) return;
      mapTitle = _buildTitle(mc);
      error.value = e.message;
    } finally {
      if (seq == _fetchSeq) {
        mc.animationController.stop();
        Common.isLoading.value = false;
      }
    }
  }

  String _buildTitle(MainController mc) {
    final mode = ApiMap.mode(mc.selectedSubId.value);
    final sido = mc.filterSido.value;
    final sgg = mc.filterSigungu.value;
    final regionPart = [
      if (sido != '전체') sido,
      if (sgg != '전체') sgg,
    ].join(' ');
    return '$mode (${regionPart.isNotEmpty ? regionPart : '전국'})';
  }

  @override
  void onInit() {
    super.onInit();
    result = PastHealthRiskResponse.empty.obs;
  }

  @override
  void onReady() {
    super.onReady();
    fetch();
  }
}
