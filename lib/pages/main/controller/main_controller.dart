import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/exposure/controller/exposure_controller.dart';
import 'package:boilerplate/pages/health_effects/controller/health_effects_controller.dart';
import 'package:boilerplate/pages/health_projection/controller/health_projection_controller.dart';
import 'package:boilerplate/pages/scenario/controller/scenario_controller.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:flutter/animation.dart';
import '../../../common/common.dart';

// ──────────────────────────────────────────────
//  Navigation model
// ──────────────────────────────────────────────
class NavSubItem {
  final String id;
  final String label;
  final List<NavSubItem> children;
  const NavSubItem({
    required this.id,
    required this.label,
    this.children = const [],
  });
}

// ──────────────────────────────────────────────
//  Enums
// ──────────────────────────────────────────────
enum MainMenu { exposure, healthImpact, climateScenario, futureHealth }

// content layout
enum ContentType {
  exposureMap, // 과거노출: 지도 + 시계열 + 테이블
  healthImpact, // 건강영향: 지도 2개
  climateTempLine, // 기후변화 온도: 꺾은선 그래프 + 테이블
  climatePm25Bar, // 기후변화 PM2.5: 막대 그래프 + 테이블
  futureHealthBar, // 건강영향 미래 추정: 막대 그래프 + 테이블
}

// dropdowns
enum FilterConfig {
  exposureTemp, // [연중온도] 연도, 월, 시도, 시군구
  exposureSummerTemp, // [여름철 온도] 연도, 월, 시도, 시군구
  exposureSummerO3, // [여름철 오존] 연도, 월, 시도, 시군구
  exposurePM, // [초미세먼지] 연도, 월, 시도, 시군구
  healthImpactDeath, // [사망] 시도, 시군구, 평가그룹
  healthImpactScrubTyphus, // [쯔쯔가무시] 시도, 시군구, 평가그룹
  healthImpactMalaria, // [말라리아] 시도, 시군구, 평가그룹
  healthImpactWaterborne, // [수인성] 시도, 시군구, 평가그룹
  climateTempScenario, // [온도] 시도, 시군구, 기간, 시나리오, 기후모형
  climateAPScenario, // [대기오염] 시도, 시군구, 기간, 농도변화
  futureHealthTemp, // [사망 - 여름철온도] 시도, 시군구, 기간, 평가그룹, 시나리오, 기후모형, 적응정책
  futureHealthPm25, // [사망 - PM2.5] 시도, 시군구, 기간, 평가그룹, 적응정책, 농도변화
  futureHealthO3, // [사망 - O3] 시도, 시군구, 기간, 평가그룹, 적응정책, 농도변화
  futureHealthScrubTyphus, // [쯔쯔가무시] 시도, 시군구, 기간, 평가그룹, 시나리오, 기후모형
  futureHealthMalaria, // [말라리아] 시도, 시군구, 기간, 평가그룹, 시나리오, 기후모형
  futureHealthWaterborne, // [수인성] 시도, 시군구, 기간, 평가그룹, 시나리오, 기후모형
}

// ──────────────────────────────────────────────
//  Controller
// ──────────────────────────────────────────────

class MainController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static MainController get to => Get.find<MainController>();

  // ── Navigation state ──
  Rx<MainMenu> selectedMenu = MainMenu.exposure.obs;
  RxString selectedSubId = 'annualTemp'.obs;
  RxList<String> expandedParentId = ['annualTemp'].obs; // 확장된 부모 ID
  RxInt subIndex = 0.obs;
  late AnimationController animationController;

  // ── Filter values ──
  RxString filterYear = '전체'.obs;
  RxString filterMonth = '전체'.obs;
  RxString filterSido = '전체'.obs;
  RxString filterSigungu = '전체'.obs;
  RxString filterPeriod = '전체'.obs;
  RxString filterEvalGroup = '전체'.obs;
  RxString filterScenario = 'SSP5-8.5'.obs;
  RxList<String> filterClimateModels = <String>['앙상블', 'WRF'].obs;
  RxString filterAdaptation = '없음'.obs;
  RxInt filterConcChange = 0.obs;

  ///선택한 시도의 하위 시군구 목록
  RxList<String> sggList = ['전체'].obs;

  final List<String> defaultClimateModels = ['앙상블', 'WRF'];

  // ── Loading / data ──
  RxBool isLoading = false.obs;
  Uint8List? mapImageData;
  Uint8List? chartImageData;
  Uint8List? mapImageData2; // 건강영향 두 번째 지도

  // ──────────────────────────────────────────
  //  Navigation tree definition
  // ──────────────────────────────────────────

  // ──────────────────────────────────────────
  //  Computed properties
  // ──────────────────────────────────────────

  List<NavSubItem> get currentNavItems =>
      Common.navTree[selectedMenu.value] ?? const [];

  String get menuLabel => const {
        MainMenu.exposure: '과거노출',
        MainMenu.healthImpact: '건강영향',
        MainMenu.climateScenario: '기후변화 시나리오',
        MainMenu.futureHealth: '건강영향 미래 추정',
      }[selectedMenu.value]!;

  /// Find the display label for the currently selected leaf sub-item
  String get selectedSubLabel {
    for (final item in currentNavItems) {
      if (item.id == selectedSubId.value) return item.label;
      for (final child in item.children) {
        if (child.id == selectedSubId.value) return child.label;
      }
    }
    return '';
  }

  /// Parent label of the selected sub-item (empty if no parent)
  String get selectedParentLabel {
    for (final item in currentNavItems) {
      for (final child in item.children) {
        if (child.id == selectedSubId.value) return item.label;
      }
    }
    return '';
  }

  ContentType get contentType {
    switch (selectedMenu.value) {
      case MainMenu.exposure:
        return ContentType.exposureMap;
      case MainMenu.healthImpact:
        return ContentType.healthImpact;
      case MainMenu.climateScenario:
        return selectedSubId.value == 'pm25'
            ? ContentType.climatePm25Bar
            : ContentType.climateTempLine;
      case MainMenu.futureHealth:
        return ContentType.futureHealthBar;
    }
  }

  FilterConfig get filterConfig {
    switch (selectedMenu.value) {
      case MainMenu.exposure:
        return selectedSubId.value == 'annualTemp'
            ? FilterConfig.exposureTemp
            : selectedSubId.value == 'pm25'
                ? FilterConfig.exposurePM
                : selectedSubId.value == 'summerTemp'
                    ? FilterConfig.exposureSummerTemp
                    : FilterConfig.exposureSummerO3;
      case MainMenu.healthImpact:
        return selectedSubId.value.contains('death')
            ? FilterConfig.healthImpactDeath
            : selectedSubId.value == 'scrub_annual'
                ? FilterConfig.healthImpactScrubTyphus
                : selectedSubId.value == 'malaria_annual'
                    ? FilterConfig.healthImpactMalaria
                    : FilterConfig.healthImpactWaterborne;
      case MainMenu.climateScenario:
        return ['pm25', 'o3'].contains(selectedSubId.value)
            ? FilterConfig.climateAPScenario
            : FilterConfig.climateTempScenario;
      case MainMenu.futureHealth:
        return selectedSubId.value == 'death_pm25'
            ? FilterConfig.futureHealthPm25
            : selectedSubId.value == 'death_o3'
                ? FilterConfig.futureHealthO3
                : selectedSubId.value == 'death_summer'
                    ? FilterConfig.futureHealthTemp
                    : selectedSubId.value == 'scrub_annual'
                        ? FilterConfig.futureHealthScrubTyphus
                        : selectedSubId.value == 'malaria_annual'
                            ? FilterConfig.futureHealthMalaria
                            : FilterConfig.futureHealthWaterborne;
    }
  }

  List<String> get sgg {
    sggList.clear();
    if (selectedSubId.value.contains('malaria')) {
      sggList.addAll(Common.sgg2[filterSido.value]!);
    } else {
      sggList.addAll(Common.sgg1[filterSido.value]!);
    }
    return sggList.value;
  }

  String get filterRcm => filterClimateModels.join(', ');

  // ──────────────────────────────────────────
  //  Navigation actions
  // ──────────────────────────────────────────

  void selectMenu(MainMenu menu) {
    selectedMenu.value = menu;
    final items = Common.navTree[menu]!;
    final first = items.first;
    if (first.children.isNotEmpty) {
      expandedParentId.value = [first.id];
      selectedSubId.value = first.children.first.id;
    } else {
      expandedParentId.value = [''];
      selectedSubId.value = first.id;
    }
    _resetFilters();
  }

  void selectTopMenuAndSub(MainMenu menu, String subId) {
    selectedMenu.value = menu;

    for (final item in Common.navTree[menu]!) {
      // subId가 부모 항목인 경우 → 첫 자식을 선택
      if (item.id == subId) {
        if (item.children.isNotEmpty) {
          expandedParentId.value = [item.id];
          selectedSubId.value = item.children.first.id;
        } else {
          expandedParentId.value = [''];
          selectedSubId.value = item.id;
        }
        _resetFilters();
        return;
      }
      // subId가 자식 항목인 경우
      for (final child in item.children) {
        if (child.id == subId) {
          expandedParentId.value = [item.id];
          selectedSubId.value = subId;
          _resetFilters();
          return;
        }
      }
    }

    // flat 항목
    expandedParentId.value = [''];
    selectedSubId.value = subId;
    _resetFilters();
  }

  void toggleParent(String parentId) {
    if (expandedParentId.contains(parentId)) {
      expandedParentId.remove(parentId);
    } else {
      expandedParentId.add(parentId);
    }
  }

  void selectLeaf(String leafId) {
    selectedSubId.value = leafId;
    _resetFilters();
  }

  void selectFlatItem(String itemId) {
    selectedSubId.value = itemId;
    expandedParentId.value = [''];
    _resetFilters();
  }

  void _resetFilters() {
    filterYear.value = '전체';
    filterMonth.value = '전체';
    filterSido.value = '전체';
    filterSigungu.value = '전체';
    filterPeriod.value = '전체';
    filterEvalGroup.value = '전체';
    filterScenario.value = 'SSP5-8.5';
    filterClimateModels.assignAll(defaultClimateModels);
    filterAdaptation.value = '없음';
    filterConcChange.value = 0;
    // 페이지/옵션 진입 시 디폴트 값으로 자동 조회
    search();
  }

  void setClimateModels(List<String> models) {
    if (models.isEmpty) {
      filterClimateModels.assignAll(defaultClimateModels);
    } else {
      filterClimateModels.assignAll(models);
    }
  }

  void search() {
    switch (selectedMenu.value) {
      case MainMenu.exposure:
        ExposureController.to.fetch();
      case MainMenu.healthImpact:
        HealthEffectsController.to.fetch();
      case MainMenu.climateScenario:
        ScenarioController.to.fetch();
      case MainMenu.futureHealth:
        HealthProjectionController.to.fetch();
    }
  }

  // ──────────────────────────────────────────
  //  Static helper: flat sub-items by menu (for mega menu)
  // ──────────────────────────────────────────

  static List<String> topLevelLabelsFor(MainMenu menu) {
    return Common.navTree[menu]!.map((e) => e.label).toList();
  }

  @override
  void onInit() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    animationController.forward();

    if (Get.arguments != null) {
      int index = Get.arguments;
      switch (index) {
        case 0:
          selectMenu(MainMenu.exposure);
        case 1:
          selectMenu(MainMenu.healthImpact);
        case 2:
          selectMenu(MainMenu.climateScenario);
      }
    } else {
      // 최초 진입(기본 랜딩 탭)도 디폴트 값으로 자동 조회
      search();
    }

    super.onInit();
  }
}

// class MainController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   static MainController get to => Get.find<MainController>();

//   late AnimationController animationController;
//   SideMenuController sideMenu = SideMenuController();
//   int categoryIndex = 0;
//   RxInt subIndex = 0.obs;

//   /// category 버튼 클릭 시 실행
//   void selectCategory(int index) {
//     categoryIndex.value = index;
//     subIndex.value = 0;
//     reset(index, 0);
//     sideMenu.changePage(index);
//   }

//   void selectSub(int sub) {
//     subIndex.value = sub;
//     reset(categoryIndex.value, sub);
//   }

//   void reset(int index, int sub) {
//     switch (index) {
//       case 0:
//         ExposureController.to.valueIndex.value = sub;
//         ExposureController.to.reset();
//       case 1:
//         HealthEffectsController.to.reset();
//       case 2:
//         ScenarioController.to.reset();
//       case 3:
//         HealthProjectionController.to.reset();
//     }
//   }

//   List<String> category = ['노출', '건강영향', '기후변화 시나리오', '건강영향 미래 추정'];
//   List<String> icons = [
//     'exposure',
//     'health_effects',
//     'scenario',
//     'health_projection'
//   ];
//   Map<String, List<String>> content = {
//     '노출': ['연중 온도', '여름철 온도', 'PM2.5', 'O3'],
//     '건강 영향': ['사망', '쯔쯔가무시병', '말라리아', '수인성 감염병'],
//     '기후변화 시나리오': ['연중 온도', '여름철 온도', 'PM2.5'],
//     '건강영향 프로젝션': ['사망', '쯔쯔가무시병', '말라리아', '수인성 감염병'],
//   };

//   void startLoading() {
//     Common.isLoading.value = true;
//     animationController.repeat();
//   }

//   void stopLoading() {
//     Common.isLoading.value = false;
//     animationController.stop();
//   }

//   @override
//   void onInit() {
//     if (Get.arguments != null) {
//       categoryIndex.value = Get.arguments;
//     }

//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     );

//     animationController.forward();

//     super.onInit();
//   }
// }
