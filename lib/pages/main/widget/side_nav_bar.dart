import 'package:boilerplate/common/common.dart';
import 'package:flutter/material.dart';
import '../controller/main_controller.dart';
import '_side_nav_item.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({
    super.key,
    required this.items,
    required this.expandedId,
    required this.selectedId,
    required this.menuLabel,
    required this.selectFlatItem,
    required this.toggleParent,
    required this.selectLeaf,
  });

  final List<NavSubItem> items;
  final List<String> expandedId;
  final String selectedId;
  final String menuLabel;
  final void Function(String subId) selectFlatItem;
  final void Function(String parentId) toggleParent;
  final void Function(String leafId) selectLeaf;

  @override
  Widget build(BuildContext context) {
    bool big = Common.bigSize.value;
    return Container(
      width: big ? 340 : 270,
      padding: EdgeInsets.only(top: 20, left: 40, right: big ? 40 : 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: big ? 122 : 95,
            margin: const EdgeInsets.only(bottom: 25),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                    color: Colors.black.withOpacity(0.25))
              ],
              image: const DecorationImage(
                  image: AssetImage('assets/images/side_nav_box.png'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: Text(menuLabel,
                style: Common.bigSize.value
                    ? CommonStyle.textStyleWhite23400
                    : CommonStyle.textStyleWhite18400),
          ),
          Container(
            width: 260,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: const Color(0xffededed)),
            ),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                NavSubItem item = items[index];
                if (item.children.isEmpty) {
                  final isActive = selectedId == item.id;
                  return Padding(
                    padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
                    child: SideNavFlatItem(
                        label: item.label,
                        isActive: isActive,
                        onTap: () => selectFlatItem(item.id)),
                  );
                } else {
                  final isExpanded = expandedId.contains(item.id);
                  final anyChildActive =
                      item.children.any((c) => c.id == selectedId);
                  return Padding(
                    padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
                    child: ExpandableNavItem(
                      label: item.label,
                      isExpanded: isExpanded,
                      isParentActive: anyChildActive,
                      children: item.children,
                      selectedId: selectedId,
                      onParentTap: () => toggleParent(item.id),
                      onChildTap: (childId) => selectLeaf(childId),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
