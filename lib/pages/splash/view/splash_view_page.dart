import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../global/global_layout_widget.dart';
import '../controller/splash_controller.dart';

class SplashViewPage extends GetView<SplashController> {
  const SplashViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        context: context,
        body: Center(
            child: Image.asset(
          controller.path('logo/direction.png'),
          width: 200.w,
          height: 200.w,
          fit: BoxFit.cover,
        )));
  }
}
