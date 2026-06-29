import 'package:boilerplate/global/result_table/result_table.dart';
import 'package:boilerplate/global/result_table/rt_factory.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/scenario_controller.dart';

class ScenarioViewPage extends GetView<ScenarioController> {
  const ScenarioViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final data = controller.result.value;
          if (data == null) return const SizedBox.shrink();
          final tableSet = ResultTableFactory.fromFutureScenario(
            request: controller.fetchedRequest,
            data: data,
          );
          return ResultTable(tableSet: tableSet);
        }),
      ],
    );
  }
}
