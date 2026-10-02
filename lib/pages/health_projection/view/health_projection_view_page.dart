import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/global/result_table/result_table.dart';
import 'package:boilerplate/global/result_table/rt_factory.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/health_projection_controller.dart';
import '../widget/health_projection_an_chart.dart';

class HealthProjectionViewPage extends GetView<HealthProjectionController> {
  const HealthProjectionViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.result.value;
      if (data == null) return const SizedBox.shrink();

      final request = controller.fetchedRequest;
      final tableSet = ResultTableFactory.fromFutureProjection(
        request: request,
        data: data,
      );
      final chartWidth = Common.bigSize.value ? 700.0 : 520.0;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: chartWidth,
            child: HealthProjectionAnChart(
              data: data,
              mode: request['mode']?.toString() ?? '',
              chartTitle: controller.chartTitle,
            ),
          ),
          const SizedBox(width: 24),
          ResultTable(tableSet: tableSet, headerH: 50),
        ],
      );
    });
  }
}
