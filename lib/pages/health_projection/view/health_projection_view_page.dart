import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/health_projection_controller.dart';
import 'package:boilerplate/global/global_loading.dart';

class HealthProjectionViewPage extends GetView<HealthProjectionController> {
  const HealthProjectionViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => Common.isLoading.value
                ? GlobalLoading(
                    animationController: MainController.to.animationController)
                : MainController.to.subIndex.value == 1
                    ? Text('대기오염 RR변동율 추가 유무')
                    : SizedBox()
            // Padding(
            //     padding:
            //         const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
            //     child: Row(
            //       children: [
            //         Image.network(controller.data['map_image_url'], width: 700),
            //         GlobalTable(
            //             tableData: controller.data['table'], isProjection: true)
            //       ],
            //     ),
            //   )
            )
      ],
    );
  }
}
