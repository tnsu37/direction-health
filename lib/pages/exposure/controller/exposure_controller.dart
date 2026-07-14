import 'package:boilerplate/common/api.dart';
import 'package:boilerplate/common/api_mappers.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';
import '../../../common/common.dart';

class ExposureController extends GetxController {
  static ExposureController get to => Get.find<ExposureController>();

  final _api = ApiService();
  late Rx<ExposureApiResponse> result;
  RxString error = ''.obs;

  String fetchedSido = '전체';
  String mapTitle = '여름철 온도(전국, 전체 기간)';
  Map<String, dynamic> fetchedRequest = {
    'mode': '여름철 온도',
    'year_': 2018,
    'month_': '전체',
    'sido_': '전체',
    'sgg_': '전체',
  };

  Future<void> fetch() async {
    final mc = MainController.to;
    Common.isLoading.value = true;
    mc.animationController.repeat();
    error.value = '';
    try {
      final res = await _api.pastExposure(
        mode: ApiMap.mode(mc.selectedSubId.value),
        year_: ApiMap.year(mc.filterYear.value),
        month_: ApiMap.month(mc.filterMonth.value),
        sido_: mc.filterSido.value,
        sgg_: mc.filterSigungu.value,
      );

      fetchedSido = mc.filterSido.value;
      fetchedRequest = {
        'mode': ApiMap.mode(mc.selectedSubId.value),
        'year_': ApiMap.year(mc.filterYear.value),
        'month_': ApiMap.month(mc.filterMonth.value),
        'sido_': mc.filterSido.value,
        'sgg_': mc.filterSigungu.value,
      };
      mapTitle = _buildTitle(mc);
      result.value = res.data ?? ExposureApiResponse.empty;
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

  ///response data (초기 표시용 더미 데이터)
  final exampleJson = {
    "status": "success",
    "request": {
      "year": "전체",
      "month": "전체",
      "sido": "서울특별시",
      "sgg": "전체",
      "mode": "여름철 온도"
    },
    "data": {
      "map_data": [
        {"sgg_229": "11010", "col": 24.48},
        {"sgg_229": "11020", "col": 24.61},
        {"sgg_229": "11030", "col": 24.87},
        {"sgg_229": "11040", "col": 24.83},
        {"sgg_229": "11050", "col": 24.91},
        {"sgg_229": "11060", "col": 24.49},
        {"sgg_229": "11070", "col": 24.65},
        {"sgg_229": "11080", "col": 24.41},
        {"sgg_229": "11090", "col": 24.29},
        {"sgg_229": "11100", "col": 23.93},
        {"sgg_229": "11110", "col": 23.9},
        {"sgg_229": "11120", "col": 23.62},
        {"sgg_229": "11130", "col": 24.1},
        {"sgg_229": "11140", "col": 24.71},
        {"sgg_229": "11150", "col": 24.81},
        {"sgg_229": "11160", "col": 24.7},
        {"sgg_229": "11170", "col": 24.58},
        {"sgg_229": "11180", "col": 24.2},
        {"sgg_229": "11190", "col": 24.74},
        {"sgg_229": "11200", "col": 24.52},
        {"sgg_229": "11210", "col": 24.51},
        {"sgg_229": "11220", "col": 24.57},
        {"sgg_229": "11230", "col": 24.83},
        {"sgg_229": "11240", "col": 24.57},
        {"sgg_229": "11250", "col": 24.44}
      ],
      "timeseries_data": [
        {"period": "2011-06", "col": 22.34, "year": 2011, "month": 6},
        {"period": "2011-07", "col": 25.14, "year": 2011, "month": 7},
        {"period": "2011-08", "col": 26.05, "year": 2011, "month": 8},
        {"period": "2011-09", "col": 21.7, "year": 2011, "month": 9},
        {"period": "2012-06", "col": 24.23, "year": 2012, "month": 6},
        {"period": "2012-07", "col": 25.72, "year": 2012, "month": 7},
        {"period": "2012-08", "col": 27.16, "year": 2012, "month": 8},
        {"period": "2012-09", "col": 20.79, "year": 2012, "month": 9},
        {"period": "2013-06", "col": 24.28, "year": 2013, "month": 6},
        {"period": "2013-07", "col": 25.62, "year": 2013, "month": 7},
        {"period": "2013-08", "col": 27.77, "year": 2013, "month": 8},
        {"period": "2013-09", "col": 21.75, "year": 2013, "month": 9},
        {"period": "2014-06", "col": 23.12, "year": 2014, "month": 6},
        {"period": "2014-07", "col": 26.08, "year": 2014, "month": 7},
        {"period": "2014-08", "col": 24.96, "year": 2014, "month": 8},
        {"period": "2014-09", "col": 22.01, "year": 2014, "month": 9},
        {"period": "2015-06", "col": 23.47, "year": 2015, "month": 6},
        {"period": "2015-07", "col": 25.43, "year": 2015, "month": 7},
        {"period": "2015-08", "col": 26.15, "year": 2015, "month": 8},
        {"period": "2015-09", "col": 22.06, "year": 2015, "month": 9},
        {"period": "2016-06", "col": 23.51, "year": 2016, "month": 6},
        {"period": "2016-07", "col": 26.02, "year": 2016, "month": 7},
        {"period": "2016-08", "col": 27.63, "year": 2016, "month": 8},
        {"period": "2016-09", "col": 22.78, "year": 2016, "month": 9},
        {"period": "2017-06", "col": 22.95, "year": 2017, "month": 6},
        {"period": "2017-07", "col": 26.66, "year": 2017, "month": 7},
        {"period": "2017-08", "col": 25.46, "year": 2017, "month": 8},
        {"period": "2017-09", "col": 21.58, "year": 2017, "month": 9},
        {"period": "2018-06", "col": 22.91, "year": 2018, "month": 6},
        {"period": "2018-07", "col": 27.74, "year": 2018, "month": 7},
        {"period": "2018-08", "col": 28.57, "year": 2018, "month": 8},
        {"period": "2018-09", "col": 21.4, "year": 2018, "month": 9},
        {"period": "2019-06", "col": 22.68, "year": 2019, "month": 6},
        {"period": "2019-07", "col": 26.05, "year": 2019, "month": 7},
        {"period": "2019-08", "col": 27.24, "year": 2019, "month": 8},
        {"period": "2019-09", "col": 22.7, "year": 2019, "month": 9}
      ],
      "table_data": {
        "monthly": [
          {"기간": "2011년 6월", "평균값": 22.34},
          {"기간": "2011년 7월", "평균값": 25.14},
          {"기간": "2011년 8월", "평균값": 26.05},
          {"기간": "2011년 9월", "평균값": 21.7},
          {"기간": "2012년 6월", "평균값": 24.23},
          {"기간": "2012년 7월", "평균값": 25.72},
          {"기간": "2012년 8월", "평균값": 27.16},
          {"기간": "2012년 9월", "평균값": 20.79},
          {"기간": "2013년 6월", "평균값": 24.28},
          {"기간": "2013년 7월", "평균값": 25.62},
          {"기간": "2013년 8월", "평균값": 27.77},
          {"기간": "2013년 9월", "평균값": 21.75},
          {"기간": "2014년 6월", "평균값": 23.12},
          {"기간": "2014년 7월", "평균값": 26.08},
          {"기간": "2014년 8월", "평균값": 24.96},
          {"기간": "2014년 9월", "평균값": 22.01},
          {"기간": "2015년 6월", "평균값": 23.47},
          {"기간": "2015년 7월", "평균값": 25.43},
          {"기간": "2015년 8월", "평균값": 26.15},
          {"기간": "2015년 9월", "평균값": 22.06},
          {"기간": "2016년 6월", "평균값": 23.51},
          {"기간": "2016년 7월", "평균값": 26.02},
          {"기간": "2016년 8월", "평균값": 27.63},
          {"기간": "2016년 9월", "평균값": 22.78},
          {"기간": "2017년 6월", "평균값": 22.95},
          {"기간": "2017년 7월", "평균값": 26.66},
          {"기간": "2017년 8월", "평균값": 25.46},
          {"기간": "2017년 9월", "평균값": 21.58},
          {"기간": "2018년 6월", "평균값": 22.91},
          {"기간": "2018년 7월", "평균값": 27.74},
          {"기간": "2018년 8월", "평균값": 28.57},
          {"기간": "2018년 9월", "평균값": 21.4},
          {"기간": "2019년 6월", "평균값": 22.68},
          {"기간": "2019년 7월", "평균값": 26.05},
          {"기간": "2019년 8월", "평균값": 27.24},
          {"기간": "2019년 9월", "평균값": 22.7}
        ],
        "yearly": [
          {"기간": "2011년 6-9월 평균", "평균값": 23.81},
          {"기간": "2012년 6-9월 평균", "평균값": 24.48},
          {"기간": "2013년 6-9월 평균", "평균값": 24.86},
          {"기간": "2014년 6-9월 평균", "평균값": 24.04},
          {"기간": "2015년 6-9월 평균", "평균값": 24.28},
          {"기간": "2016년 6-9월 평균", "평균값": 24.98},
          {"기간": "2017년 6-9월 평균", "평균값": 24.16},
          {"기간": "2018년 6-9월 평균", "평균값": 25.16},
          {"기간": "2019년 6-9월 평균", "평균값": 24.67}
        ]
      }
    },
    "files": {"map_image": {}, "timeseries_image": {}}
  };

  // 초기값: 더미 데이터(여름철 온도, 2019년 8월, 서울특별시)에 맞춤
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

  @override
  void onInit() {
    result = ExposureApiResponse.fromJson(exampleJson).obs;
    super.onInit();
  }
}
