import 'package:flutter/material.dart';
import '../../../common/common.dart';

class GreyText extends StatelessWidget {
  const GreyText({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return category == '미래 예측'
        ? Text('기후변화 시나리오  |  건강영향 미래 추정',
            style: Common.bigSize.value
                ? CommonStyle.textStyle7D24700
                : CommonStyle.textStyle7D13700)
        : category == '노출'
            ? Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: '연중 온도 | 여름철 온도  |  PM',
                        style: Common.bigSize.value
                            ? CommonStyle.textStyle7D24700
                            : CommonStyle.textStyle7D13700),
                    WidgetSpan(
                      child: Text(
                        '2.5',
                        textScaler: const TextScaler.linear(0.7),
                        style: Common.bigSize.value
                            ? CommonStyle.textStyle7D24700
                            : CommonStyle.textStyle7D13700,
                      ),
                    ),
                    TextSpan(
                        text: '  |  O',
                        style: Common.bigSize.value
                            ? CommonStyle.textStyle7D24700
                            : CommonStyle.textStyle7D13700),
                    WidgetSpan(
                      child: Text('3',
                          textScaler: const TextScaler.linear(0.7),
                          style: Common.bigSize.value
                              ? CommonStyle.textStyle7D24700
                              : CommonStyle.textStyle7D13700),
                    ),
                  ],
                ),
              )
            : Text('사망 | 쯔쯔가무시병 | 말라리아 | 수인성 감염병',
                style: Common.bigSize.value
                    ? CommonStyle.textStyle7D24700
                    : CommonStyle.textStyle7D13700);
  }
}
