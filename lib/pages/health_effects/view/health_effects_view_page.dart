import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/global/global_map.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/health_effects_controller.dart';

class HealthEffectsViewPage extends GetView<HealthEffectsController> {
  const HealthEffectsViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 왼쪽: 노출 지도 ──────────────────────────────────
        SizedBox(
          width: Common.bigSize.value ? 638 : 450,
          child: Obx(() => GlobalMap(
                mapData: controller.exposureMapData,
                sido: controller.fetchedSido,
                label: MainController.to.selectedSubLabel,
                title: '노출 - ${controller.mapTitle}',
                unit: Common.unit(MainController.to.selectedSubId.value),
              )),
        ),
        const SizedBox(width: 20),
        // ── 오른쪽: 건강영향 지도 ──────────────────
        SizedBox(
          width: Common.bigSize.value ? 638 : 450,
          child: Obx(() => GlobalMap(
              mapData: controller.riskMapData,
              sido: controller.fetchedSido,
              label: controller.riskUnit,
              title: '건강영향 - ${controller.mapTitle}')),
        ),
      ],
    );
  }
}
