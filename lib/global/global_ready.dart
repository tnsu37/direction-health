import 'package:flutter/material.dart';
import '../common/common.dart';

class GlobalReady extends StatelessWidget {
  const GlobalReady({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80, bottom: 60),
            child: Image.asset('assets/logo/direction.png', width: 150),
          ),
          Text('준비중입니다.', style: CommonStyle.textStyleAA30700)
        ],
      ),
    );
  }
}
