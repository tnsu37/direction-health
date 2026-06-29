import 'package:boilerplate/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BreadcrumbBar extends StatelessWidget {
  const BreadcrumbBar(
      {super.key,
      required this.menuLabel,
      required this.parentLabel,
      required this.subLabel});
  final String menuLabel;
  final String parentLabel;
  final String subLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 30, top: 13, bottom: 13),
      color: CommonColor.mainColor,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Breadcrumb items ──
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Home icon
              SvgPicture.asset('assets/icons/home.svg', height: 24),
              const SizedBox(width: 15),
              // Main menu
              Text(menuLabel, style: CommonStyle.textStyleWhite16600),
              if (parentLabel.isNotEmpty) ...[
                _Separator(),
                Text(parentLabel, style: CommonStyle.textStyleWhite16600),
              ],
              if (subLabel.isNotEmpty) ...[
                _Separator(),
                Text(subLabel, style: CommonStyle.textStyleWhite16600),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Icon(Icons.chevron_right, size: 18, color: Colors.white),
    );
  }
}
