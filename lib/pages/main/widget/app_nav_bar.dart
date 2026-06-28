import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:flutter/material.dart';
import '_app_nav_bar_top.dart';
import '_app_nav_option_tab.dart';

class AppNavBar extends StatefulWidget {
  const AppNavBar(
      {super.key,
      required this.current,
      required this.onSelect,
      required this.selectTopMenuAndSub});

  final String current;
  final void Function(MainMenu menu) onSelect;
  final void Function(MainMenu menu, String subId) selectTopMenuAndSub;

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  bool _isHovered = false;

  static const List<String> categories = [
    '과거노출',
    '건강영향',
    '기후변화 시나리오',
    '건강영향 미래 추정',
  ];

  static const List<MainMenu> menus = [
    MainMenu.exposure,
    MainMenu.healthImpact,
    MainMenu.climateScenario,
    MainMenu.futureHealth,
  ];

  @override
  Widget build(BuildContext context) {
    final navHeight = Common.bigSize.value ? 90.0 : 75.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.white,
        elevation: _isHovered ? 4 : 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppNavBarTop(
              current: widget.current,
              categories: categories,
              menus: menus,
              onSelect: widget.onSelect,
              height: navHeight,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              child: _isHovered
                  ? AppNavOptionTab(
                      selectTopMenuAndSub: widget.selectTopMenuAndSub,
                      menus: menus,
                      closeTab: () {
                        setState(() => _isHovered = false);
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
