import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:flutter/material.dart';

class AppNavOptionTab extends StatelessWidget {
  const AppNavOptionTab(
      {super.key,
      required this.selectTopMenuAndSub,
      required this.menus,
      required this.closeTab});

  final void Function(MainMenu menu, String subId) selectTopMenuAndSub;
  final List<MainMenu> menus;
  final VoidCallback closeTab;

  @override
  Widget build(BuildContext context) {
    final logoWidth = Common.bigSize.value ? 470.0 : 370.0;
    return Container(
      key: const ValueKey('app-nav-option-tab'),
      height: 210,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xffeeeeee))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: logoWidth,
            height: 210,
            child: Image.asset('assets/logo/tab_logo.png', fit: BoxFit.cover),
          ),
          ...List.generate(4, (i) {
            final items = Common.navTree[menus[i]]!;
            return _OptionColumn(
                menu: menus[i],
                items: items,
                selectTopMenuAndSub: selectTopMenuAndSub,
                closeTab: closeTab);
          }),
        ],
      ),
    );
  }
}

class _OptionColumn extends StatelessWidget {
  const _OptionColumn(
      {required this.menu,
      required this.items,
      required this.selectTopMenuAndSub,
      required this.closeTab});

  final MainMenu menu;
  final List<NavSubItem> items;
  final void Function(MainMenu menu, String subId) selectTopMenuAndSub;
  final VoidCallback closeTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Common.bigSize.value ? 250 : 200,
      padding: const EdgeInsets.symmetric(horizontal: 45),
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: InkWell(
                onTap: () {
                  selectTopMenuAndSub(menu, item.id);
                  closeTab();
                },
                child: Text(item.label,
                    style: Common.bigSize.value
                        ? CommonStyle.textStyleFontBlack18400
                        : CommonStyle.textStyleFontBlack16400)),
          );
        }).toList(),
      ),
    );
  }
}
