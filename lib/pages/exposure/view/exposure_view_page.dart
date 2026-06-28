import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/global/global_map.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/exposure_controller.dart';
import '../widget/time_series.dart';

class ExposureViewPage extends GetView<ExposureController> {
  const ExposureViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: Common.bigSize.value ? 638 : 450,
              child: Obx(() => GlobalMap(
                    mapData: controller.exampleResponse.mapData,
                    label: MainController.to.selectedSubLabel,
                    title: controller.mapTitle,
                    unit: Common.unit(MainController.to.selectedSubId.value),
                  )),
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                SizedBox(
                  width: Common.bigSize.value ? 770 : 600,
                  child: TimeSeries(
                      timeseriesData:
                          controller.exampleResponse.timeseriesData),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
