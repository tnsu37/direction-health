import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/global/global_map.dart';
import 'package:boilerplate/global/result_table/result_table.dart';
import 'package:boilerplate/global/result_table/rt_factory.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/exposure_controller.dart';
import '../widget/time_series.dart';

class ExposureViewPage extends GetView<ExposureController> {
  const ExposureViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: Common.bigSize.value ? 638 : 450,
          child: Obx(() => GlobalMap(
                mapData: controller.result.value.mapData,
                sido: controller.fetchedSido.value,
                label: MainController.to.selectedSubLabel,
                title: controller.mapTitle.value,
                unit: Common.unit(MainController.to.selectedSubId.value),
              )),
        ),
        const SizedBox(width: 20),
        Column(
          children: [
            SizedBox(
              width: Common.bigSize.value ? 770 : 600,
              height: 330,
              child: Obx(() => TimeSeries(
                  timeseriesData: controller.result.value.timeseriesData)),
            ),
            Obx(() {
              final tableSet = ResultTableFactory.fromPastExposure(
                request: controller.fetchedRequest,
                data: controller.result.value,
              );
              return ResultTable(tableSet: tableSet);
            }),
          ],
        )
      ],
    );
  }
}
