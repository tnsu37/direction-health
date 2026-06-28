import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SideNavFlatItem extends StatelessWidget {
  const SideNavFlatItem(
      {super.key,
      required this.label,
      required this.isActive,
      required this.onTap});

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 228,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdcdcdc)))),
          child: Text(
            label,
            style: Common.bigSize.value
                ? isActive
                    ? CommonStyle.textStyleMain20500
                    : CommonStyle.textStyle20500
                : isActive
                    ? CommonStyle.textStyleMain16500
                    : CommonStyle.textStyle16500,
          )),
    );
  }
}

class ExpandableNavItem extends StatelessWidget {
  const ExpandableNavItem({
    super.key,
    required this.label,
    required this.isExpanded,
    required this.isParentActive,
    required this.children,
    required this.selectedId,
    required this.onParentTap,
    required this.onChildTap,
  });

  final String label;
  final bool isExpanded;
  final bool isParentActive;
  final List<NavSubItem> children;
  final String selectedId;
  final VoidCallback onParentTap;
  final void Function(String childId) onChildTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onParentTap,
          child: Container(
            width: 228,
            margin: EdgeInsets.only(bottom: isExpanded ? 10 : 0),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffdcdcdc)))),
            child: Row(
              children: [
                Text(
                  label,
                  style: Common.bigSize.value
                      ? isParentActive
                          ? CommonStyle.textStyleMain20500
                          : CommonStyle.textStyle20500
                      : isParentActive
                          ? CommonStyle.textStyleMain16500
                          : CommonStyle.textStyle16500,
                ),
                const Spacer(),
                isExpanded
                    ? SvgPicture.asset('assets/icons/down_arrow.svg', width: 19)
                    : SvgPicture.asset('assets/icons/right_arrow.svg',
                        height: 19)
              ],
            ),
          ),
        ),
        if (isExpanded)
          ...children.map((child) {
            final isActive = child.id == selectedId;
            return GestureDetector(
              onTap: () => onChildTap(child.id),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(child.label,
                    style: Common.bigSize.value
                        ? isActive
                            ? CommonStyle.textStyleFontBlack20400
                            : CommonStyle.textStyleAA20400
                        : isActive
                            ? CommonStyle.textStyleFontBlack16400
                            : CommonStyle.textStyleAA16400),
              ),
            );
          })
      ],
    );
  }
}
