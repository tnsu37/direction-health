import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/global/global_map.dart';
import 'package:boilerplate/global/result_table/result_table.dart';
import 'package:boilerplate/global/result_table/rt_factory.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/health_effects_controller.dart';

class HealthEffectsViewPage extends GetView<HealthEffectsController> {
  const HealthEffectsViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                    highlightSggName: controller.fetchedRequest['sgg_']?.toString(),
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
                    title: '건강영향 - ${controller.mapTitle}',
                    highlightSggName:
                        controller.fetchedRequest['sgg_']?.toString(),
                    // 감염병(수인성/말라리아/쯔쯔가무시)만 범례 중간을 0으로 고정, 사망은 기존과 동일
                    centerAtZero: !MainController.to.selectedSubId.value
                        .contains('death'),
                  )),
            ),
          ],
        ),
        Obx(() {
          final tableSet = ResultTableFactory.fromHealthEffectsDetail(
            request: controller.fetchedRequest,
            data: controller.result.value,
            unitLabel: Common.unit(MainController.to.selectedSubId.value),
          );
          if (tableSet.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ResultTable(tableSet: tableSet),
          );
        }),
      ],
    );
  }
}
