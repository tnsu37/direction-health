import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppNavBarTop extends StatelessWidget {
  const AppNavBarTop({
    super.key,
    required this.current,
    required this.categories,
    required this.menus,
    required this.onSelect,
    required this.height,
  });

  final String current;
  final List<String> categories;
  final List<MainMenu> menus;
  final void Function(MainMenu menu) onSelect;
  final double height;

  @override
  Widget build(BuildContext context) {
    final logoWidth = Common.bigSize.value ? 470.0 : 370.0;
    final menuWidth = Common.bigSize.value ? 250.0 : 200.0;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: logoWidth,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/logo/direction.svg',
                  height: Common.bigSize.value ? 45 : 35,
                ),
                const SizedBox(width: 15),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'DIRECTION ',
                        style: Common.bigSize.value
                            ? CommonStyle.textStyleFontBlack30700
                            : CommonStyle.textStyleFontBlack24700,
                      ),
                      TextSpan(
                        text: 'Health',
                        style: Common.bigSize.value
                            ? CommonStyle.textStyleFontBlack30500
                            : CommonStyle.textStyleFontBlack24500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height,
            width: Common.bigSize.value ? 1000 : 800,
            child: Row(
              children: List.generate(categories.length, (index) {
                final category = categories[index];

                return SizedBox(
                  width: menuWidth,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => onSelect(menus[index]),
                      child: Text(
                        category,
                        style: current == category
                            ? Common.bigSize.value
                                ? CommonStyle.textStyleMain24500
                                : CommonStyle.textStyleMain20500
                            : Common.bigSize.value
                                ? CommonStyle.textStyleFont5824500
                                : CommonStyle.textStyleFont5820500,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
