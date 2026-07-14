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

  Future<void> fetch() async {
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
      //ExposureApiResponse.fromJson(exampleJson);
    } on ApiException catch (e) {
      mapTitle = _buildTitle(mc);
      error.value = e.message;
    } finally {
      mc.animationController.stop();
      Common.isLoading.value = false;
    }
  }

  /// 초기 표시용 더미 데이터 (말라리아, 서울특별시)
  final exampleJson = {
    "status": "success",
    "request": {
      "mode": "말라리아",
      "eval_group": "전체",
      "sido": "서울특별시",
      "sgg": "강서구"
    },
    "data": {
      "exposure_data": [
        {"sgg_229": "11010", "sgg_kr": "서울종로구", "exp_val": 13.07},
        {"sgg_229": "11020", "sgg_kr": "서울중구", "exp_val": 13.26},
        {"sgg_229": "11030", "sgg_kr": "서울용산구", "exp_val": 13.53},
        {"sgg_229": "11040", "sgg_kr": "서울성동구", "exp_val": 13.66},
        {"sgg_229": "11050", "sgg_kr": "서울광진구", "exp_val": 13.74},
        {"sgg_229": "11060", "sgg_kr": "서울동대문구", "exp_val": 13.39},
        {"sgg_229": "11070", "sgg_kr": "서울중랑구", "exp_val": 13.36},
        {"sgg_229": "11080", "sgg_kr": "서울성북구", "exp_val": 13.14},
        {"sgg_229": "11090", "sgg_kr": "서울강북구", "exp_val": 13.00},
        {"sgg_229": "11100", "sgg_kr": "서울도봉구", "exp_val": 12.61},
        {"sgg_229": "11110", "sgg_kr": "서울노원구", "exp_val": 12.57},
        {"sgg_229": "11120", "sgg_kr": "서울은평구", "exp_val": 12.26},
        {"sgg_229": "11130", "sgg_kr": "서울서대문구", "exp_val": 12.82},
        {"sgg_229": "11140", "sgg_kr": "서울마포구", "exp_val": 13.40},
        {"sgg_229": "11150", "sgg_kr": "서울양천구", "exp_val": 13.44},
        {"sgg_229": "11160", "sgg_kr": "서울강서구", "exp_val": 13.33},
        {"sgg_229": "11170", "sgg_kr": "서울구로구", "exp_val": 13.31},
        {"sgg_229": "11180", "sgg_kr": "서울금천구", "exp_val": 12.97},
        {"sgg_229": "11190", "sgg_kr": "서울영등포구", "exp_val": 13.48},
        {"sgg_229": "11200", "sgg_kr": "서울동작구", "exp_val": 13.25},
        {"sgg_229": "11210", "sgg_kr": "서울관악구", "exp_val": 13.30},
        {"sgg_229": "11220", "sgg_kr": "서울서초구", "exp_val": 13.23},
        {"sgg_229": "11230", "sgg_kr": "서울강남구", "exp_val": 13.60},
        {"sgg_229": "11240", "sgg_kr": "서울송파구", "exp_val": 13.35},
        {"sgg_229": "11250", "sgg_kr": "서울강동구", "exp_val": 13.21}
      ],
      "risk_data": [
        {"sgg_229": "11160", "sgg_kr": "서울강서구", "an_val": 2.39},
        {"sgg_229": "11150", "sgg_kr": "서울양천구", "an_val": 0.59},
        {"sgg_229": "11210", "sgg_kr": "서울관악구", "an_val": 0},
        {"sgg_229": "11190", "sgg_kr": "서울영등포구", "an_val": 0.94}
      ]
    },
    "files": {"exposure_map": {}, "risk_map": {}}
  };

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
    result = PastHealthRiskResponse.fromJson(exampleJson).obs;
    super.onInit();
  }
}
