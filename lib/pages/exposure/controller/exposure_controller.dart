import 'package:boilerplate/common/api.dart';
import 'package:boilerplate/common/api_mappers.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';
import '../../../common/common.dart';

class ExposureController extends GetxController {
  static ExposureController get to => Get.find<ExposureController>();

  final _api = ApiService();
  late Rx<ExposureApiResponse> result;
  RxString fetchedSido = '전체'.obs;
  RxString error = ''.obs;
  Map<String, dynamic> fetchedRequest = {
    'mode': '여름철 온도',
    'year': 2018,
    'month': '전체',
    'sido': '전체',
    'sgg': '전체',
  };

  Future<void> fetch() async {
    final mc = MainController.to;
    Common.isLoading.value = true;
    mc.animationController.repeat();
    error.value = '';
    try {
      print('?');
      final res = await _api.pastExposure(
        mode: ApiMap.mode(mc.selectedSubId.value),
        year_: ApiMap.year(mc.filterYear.value),
        month_: ApiMap.month(mc.filterMonth.value),
        sido_: mc.filterSido.value,
        sgg_: mc.filterSigungu.value,
      );
      print('res: ${res.data}');
      fetchedRequest = {
        'mode': ApiMap.mode(mc.selectedSubId.value),
        'year_': ApiMap.year(mc.filterYear.value),
        'month_': ApiMap.month(mc.filterMonth.value),
        'sido_': mc.filterSido.value,
        'sgg_': mc.filterSigungu.value,
      };
      result.value = res.data ?? ExposureApiResponse.empty;
      fetchedSido.value = mc.filterSido.value;
      mapTitle.value = _buildTitle(mc);
      if (res.isEmpty) error.value = res.message ?? '데이터가 없습니다.';
    } on ApiException catch (e) {
      error.value = e.message;
    } finally {
      mc.animationController.stop();
      Common.isLoading.value = false;
    }
  }

  ///response data (초기 표시용 더미 데이터)
  final exampleJson = {
    "status": "success",
    "request": {
      "year": 2018,
      "month": "전체",
      "sido": "전체",
      "sgg": "전체",
      "mode": "여름철 온도"
    },
    "data": {
      "map_data": [
        {"sgg_229": "11010", "col": 25.27},
        {"sgg_229": "11020", "col": 25.36},
        {"sgg_229": "11030", "col": 25.57},
        {"sgg_229": "11040", "col": 25.53},
        {"sgg_229": "11050", "col": 25.45},
        {"sgg_229": "11060", "col": 25.24},
        {"sgg_229": "11070", "col": 25.2},
        {"sgg_229": "11080", "col": 25.14},
        {"sgg_229": "11090", "col": 25},
        {"sgg_229": "11100", "col": 25.1},
        {"sgg_229": "11110", "col": 24.89},
        {"sgg_229": "11120", "col": 24},
        {"sgg_229": "11130", "col": 24.69},
        {"sgg_229": "11140", "col": 25.3},
        {"sgg_229": "11150", "col": 25.5},
        {"sgg_229": "11160", "col": 25.39},
        {"sgg_229": "11170", "col": 25.53},
        {"sgg_229": "11180", "col": 24.34},
        {"sgg_229": "11190", "col": 25.42},
        {"sgg_229": "11200", "col": 25.1},
        {"sgg_229": "11210", "col": 25.11},
        {"sgg_229": "11220", "col": 25.02},
        {"sgg_229": "11230", "col": 25.48},
        {"sgg_229": "11240", "col": 25.12},
        {"sgg_229": "11250", "col": 25.1},
        {"sgg_229": "21010", "col": 24.43},
        {"sgg_229": "21020", "col": 24.38},
        {"sgg_229": "21030", "col": 24.68},
        {"sgg_229": "21040", "col": 24.13},
        {"sgg_229": "21050", "col": 24.78},
        {"sgg_229": "21060", "col": 24.6},
        {"sgg_229": "21070", "col": 24.34},
        {"sgg_229": "21080", "col": 24.82},
        {"sgg_229": "21090", "col": 24.11},
        {"sgg_229": "21100", "col": 24.03},
        {"sgg_229": "21110", "col": 24.6},
        {"sgg_229": "21120", "col": 24.67},
        {"sgg_229": "21130", "col": 24.61},
        {"sgg_229": "21140", "col": 24.44},
        {"sgg_229": "21150", "col": 24.89},
        {"sgg_229": "21310", "col": 24.04},
        {"sgg_229": "22010", "col": 25.76},
        {"sgg_229": "22020", "col": 25.35},
        {"sgg_229": "22030", "col": 25.19},
        {"sgg_229": "22040", "col": 25.57},
        {"sgg_229": "22050", "col": 25.53},
        {"sgg_229": "22060", "col": 25.22},
        {"sgg_229": "22070", "col": 25.15},
        {"sgg_229": "22310", "col": 25.21},
        {"sgg_229": "23010", "col": 24.09},
        {"sgg_229": "23020", "col": 24.38},
        {"sgg_229": "23030", "col": 24.35},
        {"sgg_229": "23040", "col": 24.73},
        {"sgg_229": "23050", "col": 24.38},
        {"sgg_229": "23060", "col": 24.41},
        {"sgg_229": "23070", "col": 24.13},
        {"sgg_229": "23080", "col": 24.02},
        {"sgg_229": "23310", "col": 23.22},
        {"sgg_229": "23320", "col": 22.77},
        {"sgg_229": "24010", "col": 24.28},
        {"sgg_229": "24020", "col": 25.54},
        {"sgg_229": "24030", "col": 25.5},
        {"sgg_229": "24040", "col": 25.4},
        {"sgg_229": "24050", "col": 25.11},
        {"sgg_229": "25010", "col": 24.88},
        {"sgg_229": "25020", "col": 25.43},
        {"sgg_229": "25030", "col": 25.32},
        {"sgg_229": "25040", "col": 25},
        {"sgg_229": "25050", "col": 24.44},
        {"sgg_229": "26010", "col": 24.29},
        {"sgg_229": "26020", "col": 24.22},
        {"sgg_229": "26030", "col": 22.96},
        {"sgg_229": "26040", "col": 23.86},
        {"sgg_229": "26310", "col": 23.44},
        {"sgg_229": "29010", "col": 24.09},
        {"sgg_229": "31010", "col": 24.81},
        {"sgg_229": "31020", "col": 24.43},
        {"sgg_229": "31030", "col": 23.75},
        {"sgg_229": "31040", "col": 23.83},
        {"sgg_229": "31050", "col": 24.84},
        {"sgg_229": "31060", "col": 25.47},
        {"sgg_229": "31070", "col": 24.54},
        {"sgg_229": "31080", "col": 23.78},
        {"sgg_229": "31090", "col": 24.02},
        {"sgg_229": "31100", "col": 24.11},
        {"sgg_229": "31110", "col": 24.34},
        {"sgg_229": "31120", "col": 24.73},
        {"sgg_229": "31130", "col": 23.85},
        {"sgg_229": "31140", "col": 24.37},
        {"sgg_229": "31150", "col": 24.56},
        {"sgg_229": "31160", "col": 24.74},
        {"sgg_229": "31170", "col": 24.33},
        {"sgg_229": "31180", "col": 24.88},
        {"sgg_229": "31190", "col": 24.05},
        {"sgg_229": "31200", "col": 23.35},
        {"sgg_229": "31210", "col": 24.07},
        {"sgg_229": "31220", "col": 24.2},
        {"sgg_229": "31230", "col": 23.82},
        {"sgg_229": "31240", "col": 24.33},
        {"sgg_229": "31250", "col": 23.67},
        {"sgg_229": "31260", "col": 23.6},
        {"sgg_229": "31270", "col": 22.85},
        {"sgg_229": "31280", "col": 23.78},
        {"sgg_229": "31350", "col": 22.79},
        {"sgg_229": "31370", "col": 22.9},
        {"sgg_229": "31380", "col": 23.66},
        {"sgg_229": "32010", "col": 23.67},
        {"sgg_229": "32020", "col": 23.87},
        {"sgg_229": "32030", "col": 23.07},
        {"sgg_229": "32040", "col": 22.35},
        {"sgg_229": "32050", "col": 20.03},
        {"sgg_229": "32060", "col": 23.24},
        {"sgg_229": "32070", "col": 22.3},
        {"sgg_229": "32310", "col": 22.51},
        {"sgg_229": "32320", "col": 22.09},
        {"sgg_229": "32330", "col": 22.19},
        {"sgg_229": "32340", "col": 20.66},
        {"sgg_229": "32350", "col": 20.58},
        {"sgg_229": "32360", "col": 21.14},
        {"sgg_229": "32370", "col": 21.74},
        {"sgg_229": "32380", "col": 20.98},
        {"sgg_229": "32390", "col": 21.77},
        {"sgg_229": "32400", "col": 22.13},
        {"sgg_229": "32410", "col": 23.02},
        {"sgg_229": "33020", "col": 23.83},
        {"sgg_229": "33030", "col": 22.8},
        {"sgg_229": "33040", "col": 24.09},
        {"sgg_229": "33320", "col": 23.37},
        {"sgg_229": "33330", "col": 23.81},
        {"sgg_229": "33340", "col": 23.28},
        {"sgg_229": "33350", "col": 24.01},
        {"sgg_229": "33360", "col": 23.23},
        {"sgg_229": "33370", "col": 23.79},
        {"sgg_229": "33380", "col": 23.27},
        {"sgg_229": "33390", "col": 24.32},
        {"sgg_229": "34010", "col": 24.4},
        {"sgg_229": "34020", "col": 23.87},
        {"sgg_229": "34030", "col": 23.96},
        {"sgg_229": "34040", "col": 24.6},
        {"sgg_229": "34050", "col": 23.78},
        {"sgg_229": "34060", "col": 24.55},
        {"sgg_229": "34070", "col": 23.31},
        {"sgg_229": "34080", "col": 23.87},
        {"sgg_229": "34310", "col": 23.79},
        {"sgg_229": "34330", "col": 24.42},
        {"sgg_229": "34340", "col": 24.65},
        {"sgg_229": "34350", "col": 23.25},
        {"sgg_229": "34360", "col": 23.8},
        {"sgg_229": "34370", "col": 24.27},
        {"sgg_229": "34380", "col": 23.73},
        {"sgg_229": "35010", "col": 25.4},
        {"sgg_229": "35020", "col": 24.36},
        {"sgg_229": "35030", "col": 24.54},
        {"sgg_229": "35040", "col": 24.52},
        {"sgg_229": "35050", "col": 23.95},
        {"sgg_229": "35060", "col": 24.55},
        {"sgg_229": "35310", "col": 24.38},
        {"sgg_229": "35320", "col": 22.74},
        {"sgg_229": "35330", "col": 22.2},
        {"sgg_229": "35340", "col": 22.45},
        {"sgg_229": "35350", "col": 23.76},
        {"sgg_229": "35360", "col": 24.12},
        {"sgg_229": "35370", "col": 24.17},
        {"sgg_229": "35380", "col": 24.42},
        {"sgg_229": "36010", "col": 25.17},
        {"sgg_229": "36020", "col": 24.74},
        {"sgg_229": "36030", "col": 24.87},
        {"sgg_229": "36040", "col": 24.99},
        {"sgg_229": "36060", "col": 24.8},
        {"sgg_229": "36310", "col": 24.4},
        {"sgg_229": "36320", "col": 23.92},
        {"sgg_229": "36330", "col": 23.43},
        {"sgg_229": "36350", "col": 24.42},
        {"sgg_229": "36360", "col": 23.77},
        {"sgg_229": "36370", "col": 23.93},
        {"sgg_229": "36380", "col": 24.04},
        {"sgg_229": "36390", "col": 24.5},
        {"sgg_229": "36400", "col": 24.37},
        {"sgg_229": "36410", "col": 24.52},
        {"sgg_229": "36420", "col": 24.64},
        {"sgg_229": "36430", "col": 25.05},
        {"sgg_229": "36440", "col": 24.51},
        {"sgg_229": "36450", "col": 24.29},
        {"sgg_229": "36460", "col": 24.17},
        {"sgg_229": "36470", "col": 23.98},
        {"sgg_229": "36480", "col": 24.44},
        {"sgg_229": "37010", "col": 24.39},
        {"sgg_229": "37020", "col": 23.68},
        {"sgg_229": "37030", "col": 23.44},
        {"sgg_229": "37040", "col": 23.92},
        {"sgg_229": "37050", "col": 24.61},
        {"sgg_229": "37060", "col": 22.73},
        {"sgg_229": "37070", "col": 24.3},
        {"sgg_229": "37080", "col": 23.92},
        {"sgg_229": "37090", "col": 23.57},
        {"sgg_229": "37100", "col": 24.5},
        {"sgg_229": "37310", "col": 23.82},
        {"sgg_229": "37320", "col": 23.9},
        {"sgg_229": "37330", "col": 22.22},
        {"sgg_229": "37340", "col": 22.01},
        {"sgg_229": "37350", "col": 23.19},
        {"sgg_229": "37360", "col": 23.89},
        {"sgg_229": "37370", "col": 24.4},
        {"sgg_229": "37380", "col": 23.97},
        {"sgg_229": "37390", "col": 24.52},
        {"sgg_229": "37400", "col": 23.55},
        {"sgg_229": "37410", "col": 21.78},
        {"sgg_229": "37420", "col": 22.59},
        {"sgg_229": "37430", "col": 23},
        {"sgg_229": "38030", "col": 23.82},
        {"sgg_229": "38050", "col": 24.24},
        {"sgg_229": "38060", "col": 24.15},
        {"sgg_229": "38070", "col": 24.78},
        {"sgg_229": "38080", "col": 24.59},
        {"sgg_229": "38090", "col": 24.28},
        {"sgg_229": "38100", "col": 24.16},
        {"sgg_229": "38110", "col": 24.44},
        {"sgg_229": "38310", "col": 24.12},
        {"sgg_229": "38320", "col": 24.43},
        {"sgg_229": "38330", "col": 24.72},
        {"sgg_229": "38340", "col": 23.17},
        {"sgg_229": "38350", "col": 24.63},
        {"sgg_229": "38360", "col": 23.79},
        {"sgg_229": "38370", "col": 23.66},
        {"sgg_229": "38380", "col": 22.97},
        {"sgg_229": "38390", "col": 22.46},
        {"sgg_229": "38400", "col": 23.57},
        {"sgg_229": "39010", "col": 25.08},
        {"sgg_229": "39020", "col": 24.84}
      ],
      "timeseries_data": [
        {"period": "2018-06", "col": 23.28, "year": 2018, "month": 6},
        {"period": "2018-07", "col": 28.11, "year": 2018, "month": 7},
        {"period": "2018-08", "col": 28.85, "year": 2018, "month": 8},
        {"period": "2018-09", "col": 21.69, "year": 2018, "month": 9}
      ],
      "table_data": {
        "monthly": [
          {"기간": "2018년 6월", "평균값": 23.28},
          {"기간": "2018년 7월", "평균값": 28.11},
          {"기간": "2018년 8월", "평균값": 28.85},
          {"기간": "2018년 9월", "평균값": 21.69}
        ],
        "yearly": [
          {"기간": "2018년 6-9월 평균", "평균값": 25.48}
        ]
      }
    },
    "files": {"map_image": {}, "timeseries_image": {}}
  };

  // 초기값: 더미 데이터(여름철 온도, 2019년 8월, 서울특별시)에 맞춤
  RxString mapTitle = '여름철 온도 (서울특별시, 2019년 8월)'.obs;

  String _buildTitle(MainController mc) {
    final mode = ApiMap.mode(mc.selectedSubId.value);
    final year = mc.filterYear.value;
    final month = mc.filterMonth.value;
    final sido = mc.filterSido.value;
    final sgg = mc.filterSigungu.value;

    final timePart = [
      if (year != '전체') year,
      if (month != '전체') month,
    ].join(' ');

    final regionPart = [
      if (sido != '전체') sido,
      if (sgg != '전체') sgg,
    ].join(' ');

    return '$mode (${regionPart.isNotEmpty ? regionPart : '전국'}, ${timePart.isNotEmpty ? timePart : '전체 기간'})';
  }

  void onChanged(int index, String? value) {
    // values[index].value = value!;
    // if (index == 2) {
    //   district.value = '';
    //   //items[3].assignAll(Common.district[value]!);
    // }
  }

  //List<RxString> values = [];
  //RxList<RxList<String>> items = <RxList<String>>[].obs;

  @override
  void onInit() {
    result = ExposureApiResponse.fromJson(exampleJson).obs;
    // values.addAll([year, month, city, district]);
    // valueIndex = MainController.to.subIndex;
    // items.addAll([
    //   Common.year.obs,
    //   valueIndex.value == 0
    //       ? Common.summer.obs
    //       : valueIndex.value == 1
    //           ? Common.winter.obs
    //           : Common.month.obs,
    //   Common.city.obs,
    //   <String>[].obs
    // ]);
    // reset();
    super.onInit();
  }
}
