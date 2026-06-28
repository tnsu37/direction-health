import 'package:boilerplate/common/common.dart';

import '../route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(ScreenUtilInit(
    designSize: const Size(1920, 1080),
    minTextAdapt: true,
    builder: (context, child) => GetMaterialApp(
        builder: (context, child) {
          if (MediaQuery.of(context).size.width < 1450) {
            Common.bigSize.value = false;
          } else {
            Common.bigSize.value = true;
          }
          return MediaQuery(
            //화면마다 각각 다르게 css를 주는 함수
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!, // child는 null이 아님을 해서 에러 방지 해둠.
          );
        },
        theme: ThemeData(
          fontFamily: 'Inter',
          canvasColor: Colors.transparent,
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
            elevation: 0,
            modalElevation: 0,
            modalBarrierColor: Colors.transparent,
            modalBackgroundColor: Colors.transparent,
          ),
        ),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        initialRoute: '/',
        getPages: GetXRouter.route),
  ));
}
