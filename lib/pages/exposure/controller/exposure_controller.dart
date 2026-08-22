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
    } on ApiException catch (e) {
      mapTitle = _buildTitle(mc);
      error.value = e.message;
    } finally {
      mc.animationController.stop();
      Common.isLoading.value = false;
    }
  }

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
    super.onInit();
    result = ExposureApiResponse.empty.obs;
  }

  @override
  void onReady() {
    super.onReady();
    fetch();
  }
}
