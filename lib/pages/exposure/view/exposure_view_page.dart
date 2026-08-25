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

  bool get _isBig => Common.bigSize.value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(() => GlobalMap(
              width: _isBig ? 638 : 380,
              mapData: controller.result.value.mapData,
              sido: controller.fetchedSido,
              label: MainController.to.selectedSubLabel,
              title: controller.mapTitle,
              unit: Common.unit(MainController.to.selectedSubId.value),
              highlightSggName: controller.fetchedRequest['sgg_']?.toString(),
            )),
        SizedBox(width: _isBig ? 80 : 40),
        Column(
          children: [
            SizedBox(
              width: _isBig ? 800 : 650,
              height: 320,
              child: Obx(() => TimeSeries(
                  timeseriesData: controller.result.value.timeseriesData,
                  mode: controller.fetchedRequest['mode']?.toString() ?? '')),
            ),
            const SizedBox(height: 50),
            Obx(() {
              final result = controller.result.value;

              final tableSet = ResultTableFactory.fromPastExposure(
                request: result.request,
                data: result,
              );

              return ResultTable(tableSet: tableSet);
            }),
          ],
        )
      ],
    );
  }
}
