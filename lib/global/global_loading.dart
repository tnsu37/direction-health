import 'package:flutter/material.dart';
import '../common/common.dart';

class GlobalLoading extends StatelessWidget {
  const GlobalLoading({super.key, required this.animationController});

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    Animation<double> animation =
        Tween<double>(begin: 0, end: -2 * 3.141).animate(animationController);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 80, bottom: 30),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Transform.rotate(
              angle: animation.value,
              child: Image.asset('assets/logo/direction.png', width: 150),
            ),
          ),
        ),
        Text(
          '데이터를 불러오고 있습니다. 잠시만 기다려 주세요.',
          style: CommonStyle.textStyle24500,
        )
      ],
    );
  }
}
