import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/scenario_controller.dart';
import 'package:boilerplate/global/global_loading.dart';

class ScenarioViewPage extends GetView<ScenarioController> {
  const ScenarioViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expanded(
        //     child: SingleChildScrollView(
        //       scrollDirection: Axis.horizontal,
        //       child: SingleChildScrollView(
        //         child: Row(
        //           children: [
        //             Obx(() => Image.network(
        //                 controller.data['map_image_url'],
        //                 width: 563)),
        //             const SizedBox(width: 15),
        //             Obx(() => GlobalTable2(
        //                 tableData: controller.data['table'])),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
