import 'package:boilerplate/common/api.dart';
import 'package:boilerplate/common/api_mappers.dart';
import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';

class HealthEffectsController extends GetxController {
  static HealthEffectsController get to => Get.find<HealthEffectsController>();

  final _api = ApiService();
  final Rx<PastHealthRiskResponse?> result = Rx(null);
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  Future<void> fetch() async {
    final mc = MainController.to;
    isLoading.value = true;
    error.value = '';
    try {
      final res = await _api.pastHealthRisk(
        mode: ApiMap.mode(mc.selectedSubId.value),
        evalGroup: ApiMap.evalGroup(mc.filterEvalGroup.value),
        sido_: mc.filterSido.value,
        sgg_: mc.filterSigungu.value,
      );
      result.value = res.data;
      if (res.isEmpty) error.value = res.message ?? '데이터가 없습니다.';
    } on ApiException catch (e) {
      error.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  //시도
  RxString city = ''.obs;
  //시군구
  RxString district = ''.obs;
  //건강영향, 신뢰구간
  RxString rr = ''.obs;

  ///response data (legacy)
  RxMap<String, dynamic> data = <String, dynamic>{}.obs;

  ///초기화
  // void reset() {
  //   city.value = '';
  //   district.value = '';
  //   //items.assignAll([Common.city.obs, <String>[].obs]);
  //   output();
  // }

  // ///출력 - 시도,시군구에 대한 화면 만들어져야함
  // void output() async {
  //   // 로딩 화면 시작
  //   //MainController.to.startLoading();
  //   String mode = '여름철 온도';
  //   String unit = '(75% vs 99%)';
  //   switch (MainController.to.subIndex.value) {
  //     case 1:
  //       mode = '겨울철 온도';
  //       unit = '(25% vs 1%)';
  //     case 2:
  //       mode = 'PM2.5';
  //       unit = '(per 10µg/m³)';
  //     case 3:
  //       mode = 'O3';
  //       unit = '(per 10ppb)';
  //   }
  //   var response = await ApiService().healthRisk(
  //       city: city.isEmpty ? '전체' : city.value,
  //       sgg: district.isEmpty ? '전체' : district.value,
  //       mode: mode);
  //   if (response != null) {
  //     data.assignAll(response);
  //   }
  //   print('data $data');
  //   if (data['rr'] != null) {
  //     rr.value =
  //         '건강영향(RR): ${data['rr']} $unit\n신뢰구간(CI): (${data['ciLower']} - ${data['ciUpper']})';
  //   } else {
  //     rr.value = '';
  //   }
  //   // 로딩 화면 취소
  //   //MainController.to.stopLoading();
  // }

  // void onChanged(int index, String? value) {
  //   values[index].value = value!;
  //   if (index == 0) {
  //     district.value = '';
  //     //items[1].assignAll(Common.district[value]!);
  //   }
  // }

  // List<RxString> values = [];
  // RxList<RxList<String>> items = <RxList<String>>[].obs;

  // @override
  // void onInit() {
  //   values.addAll([city, district]);
  //   //items.addAll([Common.city.obs, <String>[].obs]);
  //   reset();
  //   super.onInit();
  // }
}
