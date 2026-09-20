import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/global/global_filter_bar.dart';
import 'package:boilerplate/global/global_loading.dart';
import 'package:boilerplate/global/global_ready.dart';
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
import '../widget/reference_notes.dart';

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
                                      if (controller.filterConfig ==
                                              FilterConfig
                                                  .healthImpactWaterborne ||
                                          controller.filterConfig ==
                                              FilterConfig
                                                  .futureHealthWaterborne)
                                        const GlobalReady()
                                      else ...[
                                        GlobalFilterBar(controller: controller),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 40),
                                          child: pageWidgetList[controller
                                              .selectedMenu.value.index],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 50, left: 10, right: 10),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 25, horizontal: 40),
                                          width: Common.bigSize.value
                                              ? 1870
                                              : 1100,
                                          color: const Color(0xffF4F4F4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('참고사항',
                                                  style: CommonStyle
                                                      .textStyle16500),
                                              const SizedBox(height: 18),
                                              ReferenceNotes(
                                                  menu: controller
                                                      .selectedMenu.value),
                                            ],
                                          ),
                                        ),
                                      ],
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
}
