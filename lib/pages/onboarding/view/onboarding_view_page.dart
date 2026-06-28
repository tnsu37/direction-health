import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../global/global_layout_widget.dart';
import '../controller/onboarding_controller.dart';
import '../widget/onboarding_box.dart';

class OnboardingViewPage extends GetView<OnboardingController> {
  const OnboardingViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
      context: context,
      backgroundColor: const Color(0xff263556),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.white),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Text(
                  'DIRECTION-Health',
                  softWrap: false,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OnboardingBox(index: 0, onTap: controller.selet),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: OnboardingBox(index: 1, onTap: controller.selet),
                  ),
                  OnboardingBox(index: 2, onTap: controller.selet),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
