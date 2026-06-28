import 'package:flutter/material.dart';

/// 글로벌 레이아웃 위젯
///
/// [context] BuildContext
///
/// [resizeToAvoidBottomInset] bool?
///
/// [appBar] AppBar
///
/// [onWillPop] Future<bool> Function()?
///
/// [child] Widget
///
/// [bottomNavigationBar] Widget?
///
/// [isSafeArea] bool?
class GlobalLayoutWidget extends StatelessWidget {
  const GlobalLayoutWidget({
    super.key,
    required this.context,
    this.resizeToAvoidBottomInset = false,
    this.appBar,
    this.onPopInvok,
    required this.body,
    this.bottomNavigationBar,
    this.canPop,
    this.isSafeArea = true,
    this.backgroundColor = Colors.white,
    this.topSafeArea = true,
  });

  /// 컨텍스트
  final BuildContext context;

  /// 온스크린 키보드 여부
  final bool? resizeToAvoidBottomInset;

  /// 앱바
  final PreferredSizeWidget? appBar;

  /// 모바일 뒤로가기 버튼 클릭시 펑션 처리
  final Function()? onPopInvok;

  /// 모바일 뒤로가기 허용 여부
  final bool? canPop;

  /// 자식 위젯
  final Widget body;

  /// 바텀 네비게이션 위젯
  final Widget? bottomNavigationBar;

  /// 세이프 영역 여부
  final bool isSafeArea;

  /// 세이프 영역 여부
  final Color? backgroundColor;

  /// 세이프 영역 top 여부
  final bool? topSafeArea;

  /// 세이프 영역 top 여부
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        onPopInvoked: (didPop) {
          if (onPopInvok != null) {
            onPopInvok!();
          }
        },
        canPop: canPop ?? true,
        child: isSafeArea
            ? Scaffold(
                resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                appBar: appBar,
                backgroundColor: backgroundColor,
                body: SafeArea(
                  top: topSafeArea!,
                  child: body,
                ),
                bottomNavigationBar: bottomNavigationBar,
              )
            : Scaffold(
                resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                appBar: appBar,
                backgroundColor: backgroundColor,
                body: body,
                bottomNavigationBar: bottomNavigationBar,
              ),
      ),
    );
  }
}
