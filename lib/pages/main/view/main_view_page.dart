import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/global/global_filter_bar.dart';
import 'package:boilerplate/global/global_loading.dart';
import 'package:get/get.dart';
import '../../../global/global_layout_widget.dart';
import '../controller/main_controller.dart';
import 'package:flutter/material.dart';
import '../widget/app_nav_bar.dart';
import '../widget/breadcrumb_bar.dart';
import '../../exposure/view/exposure_view_page.dart';
import '../../health_effects/view/health_effects_view_page.dart';
import '../../scenario/view/scenario_view_page.dart';
import '../../health_projection/view/health_projection_view_page.dart';
import '../widget/side_nav_bar.dart';
import '../../health_effects/view/health_effects_view_page.dart';

class MainViewPage extends GetView<MainController> {
  const MainViewPage({super.key});

  final List<Widget> pageWidgetList = const [
    ExposureViewPage(),
    HealthEffectsViewPage(),
    ScenarioViewPage(),
    HealthProjectionViewPage()
  ];

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        context: context,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: Common.bigSize.value ? 90 : 75),
                // ── Breadcrumb ──
                Obx(() => BreadcrumbBar(
                    menuLabel: controller.menuLabel,
                    parentLabel: controller.selectedParentLabel,
                    subLabel: controller.selectedSubLabel)),

                // ── Body: sidebar + content ──
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left sidebar
                      SingleChildScrollView(
                        child: Obx(() => SideNavBar(
                              items: controller.currentNavItems,
                              expandedId: controller.expandedParentId.value,
                              selectedId: controller.selectedSubId.value,
                              menuLabel: controller.menuLabel,
                              selectFlatItem: controller.selectFlatItem,
                              toggleParent: controller.toggleParent,
                              selectLeaf: controller.selectLeaf,
                            )),
                      ),
                      // SingleChildScrollView(
                      //     child: _contentWidget(controller.contentType)),

                      // Main content area
                      Expanded(
                        child: SingleChildScrollView(
                            child: Obx(() => Common.isLoading.value
                                ? GlobalLoading(
                                    animationController:
                                        controller.animationController)
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GlobalFilterBar(controller: controller),
                                      HealthEffectsViewPage()
                                    ],
                                  ))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // ── Top navigation bar ──
            Obx(() => AppNavBar(
                current: controller.menuLabel,
                onSelect: controller.selectMenu,
                selectTopMenuAndSub: controller.selectTopMenuAndSub)),
          ],
        ));
  }

  Widget _contentWidget(ContentType type) {
    switch (type) {
      case ContentType.exposureMap:
        return Text('지도');
      //return ExposureContent(controller: controller);

      case ContentType.healthImpact:
        return Text('건강영향');
      //return HealthImpactContent(controller: controller);

      case ContentType.climateTempLine:
        return Text('온도시계열');
      case ContentType.climatePm25Bar:
        return Text('대기오염바');
      //return ClimateScenarioContent(controller: controller);

      case ContentType.futureHealthBar:
        return Text('미래영향바');
      //return FutureHealthContent(controller: controller);
    }
  }
}
