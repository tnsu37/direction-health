import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:boilerplate/common/api.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class ScenarioController extends GetxController {
  static ScenarioController get to => Get.find<ScenarioController>();
  //시도
  RxString city = ''.obs;
  //시군구
  RxString district = ''.obs;
  //시작년도
  RxString first = ''.obs;
  //끝년도
  RxString last = ''.obs;
  //ssp
  RxString ssp = 'SSP5-8.5'.obs;
  //gcm
  late MultiSelectController<int> multiController;
  String mode = '여름철 온도';

  ///response data
  RxMap<String, dynamic> data = <String, dynamic>{}.obs;

  ///초기화
  void reset() {
    city.value = '';
    district.value = '';
    first.value = '';
    last.value = '';
    ssp.value = '';
    multiController
        .setSelectedOptions(const [ValueItem(label: '앙상블', value: 0)]);
    switch (MainController.to.subIndex.value) {
      case 0:
        mode = '여름철 온도';
      case 1:
        mode = 'PM2.5';
    }
    // start.assignAll(mode == 'PM2.5' ? Common.pmStartYear : Common.startYear);
    // end.assignAll(mode == 'PM2.5' ? Common.pmEndYear : Common.endYear);
    // items.assignAll([
    //   Common.city.obs,
    //   <String>[].obs,
    //   start,
    //   end,
    //   mode == 'PM2.5' ? <String>[].obs : Common.ssp.obs
    // ]);
    ssp.value = mode == 'PM2.5' ? '농도 0%' : 'SSP5-8.5';
    output();
  }

  ///출력 - 년,월,시도,시군구에 대한 화면 만들어져야함
  void output() async {
    // 로딩 화면 시작
    //MainController.to.startLoading();
    List<ValueItem<int>> selectedOptions = multiController.selectedOptions;
    // var response = await ApiService().scenario(
    //     startYear:
    //         first.isEmpty ? 2021 : int.parse(first.value.replaceAll('년', '')),
    //     endYear: last.isEmpty
    //         ? mode == 'PM2.5'
    //             ? 2060
    //             : 2100
    //         : int.parse(last.value.replaceAll('년', '')),
    //     city: city.isEmpty ? '전체' : city.value,
    //     sgg: district.isEmpty ? '전체' : district.value,
    //     mode: mode,
    //     scenario: ssp.value,
    //     ensemble: selectedOptions.contains(Common.gcm[0]),
    //     wrf: selectedOptions.contains(Common.gcm[1]),
    //     cclm: selectedOptions.contains(Common.gcm[2]),
    //     grims: selectedOptions.contains(Common.gcm[3]),
    //     hadVEM3RA: selectedOptions.contains(Common.gcm[4]),
    //     regCM: selectedOptions.contains(Common.gcm[5]));
    // if (response != null) {
    //   data.assignAll(response);
    // }
    print('data $data');
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
    //   case 2:
    //     end.assignAll(mode == 'PM2.5' ? Common.pmEndYear : Common.endYear);
    //     end.removeRange(0, Common.startYear.indexOf(value));
    //     return;
    //   case 3:
    //     start.assignAll(Common.startYear);
    //     start.removeRange(Common.endYear.indexOf(value) + 1, 8);
    //     return;
    //   default:
    //     return;
    // }
  }

  List<RxString> values = [];
  List<RxList<String>> items = [];
  late RxList<String> start;
  late RxList<String> end;

  @override
  void onInit() {
    // multiController = MultiSelectController()
    //   ..setOptions(Common.gcm)
    //   ..setSelectedOptions(const [ValueItem(label: '앙상블', value: 0)]);
    // start = Common.startYear.obs;
    // end = Common.endYear.obs;
    // values.addAll([city, district, first, last, ssp]);
    // items.addAll([Common.city.obs, <String>[].obs, start, end, Common.ssp.obs]);
    // reset();
    super.onInit();
  }
}
