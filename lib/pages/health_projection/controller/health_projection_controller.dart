import 'package:boilerplate/common/api.dart';
import 'package:boilerplate/common/common.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:get/get.dart';
import '../../main/controller/main_controller.dart';

class HealthProjectionController extends GetxController {
  static HealthProjectionController get to =>
      Get.find<HealthProjectionController>();
  //시도
  RxString city = ''.obs;
  //시군구
  RxString district = ''.obs;
  //기간
  RxString duration = ''.obs;
  //ssp
  RxString ssp = 'SSP5-8.5'.obs;
  //gcm
  late MultiSelectController<int> multiController;
  //rr변동율
  RxString rr = 'RR 0%'.obs;
  String mode = '여름철 온도';

  ///response data
  RxMap<String, dynamic> data = <String, dynamic>{}.obs;

  ///초기화
  void reset() {
    city.value = '';
    district.value = '';
    duration.value = '';
    ssp.value = '';
    rr.value = 'RR 0%';
    // multiController
    //     .setSelectedOptions(const [ValueItem(label: '앙상블', value: 0)]);
    // switch (MainController.to.subIndex.value) {
    //   case 0:
    //     mode = '여름철 온도';
    //   case 1:
    //     mode = 'PM2.5';
    // }
    //durations.assignAll(mode == 'PM2.5' ? Common.pmDuration : Common.duration);
    // items.assignAll([
    //   Common.city.obs,
    //   <String>[].obs,
    //   durations,
    //   mode == 'PM2.5' ? <String>[].obs : Common.ssp.obs,
    //   <String>[].obs,
    // ]);
    ssp.value = mode == 'PM2.5' ? '농도 0%' : 'SSP5-8.5';
    rr.value = 'RR 0%';
    output();
  }

  ///출력 - 년,월,시도,시군구에 대한 화면 만들어져야함
  void output() async {
    // 로딩 화면 시작
    //MainController.to.startLoading();
    List<ValueItem<int>> selectedOptions = multiController.selectedOptions;
    // var response = await ApiService().projection(
    //     period: duration.value.isEmpty ? '전체' : duration.value,
    //     city: city.isEmpty ? '전체' : city.value,
    //     sgg: district.isEmpty ? '전체' : district.value,
    //     mode: mode,
    //     ssp: ssp.value,
    //     ensemble: selectedOptions.contains(Common.gcm[0]),
    //     wrf: selectedOptions.contains(Common.gcm[1]),
    //     cclm: selectedOptions.contains(Common.gcm[2]),
    //     grims: selectedOptions.contains(Common.gcm[3]),
    //     hadVEM3RA: selectedOptions.contains(Common.gcm[4]),
    //     regCM: selectedOptions.contains(Common.gcm[5]));
    // if (response != null) {
    //   data.assignAll(response);
    // }
    // print('data $data');
    // 로딩 화면 취소
    //MainController.to.stopLoading();
  }

  void onChanged(int index, String? value) {
    values[index].value = value!;
    // switch (index) {
    //   case 0:
    //     district.value = '';
    //     items[1].assignAll(Common.district[value]!);
    //     return;
    //   default:
    //     return;
    // }
  }

  List<RxString> values = [];
  List<RxList<String>> items = [];
  late RxList<String> durations;

  @override
  void onInit() {
    multiController = MultiSelectController()
      //..setOptions(Common.gcm)
      ..setSelectedOptions(const [ValueItem(label: '앙상블', value: 0)]);
    //durations = Common.duration.obs;
    values.addAll([city, district, duration, ssp, rr]);
    // items.addAll([
    //   Common.city.obs,
    //   <String>[].obs,
    //   durations,
    //   Common.ssp.obs,
    //   <String>[].obs
    // ]);
    reset();
    super.onInit();
  }
}
