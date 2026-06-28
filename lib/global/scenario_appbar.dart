// import 'package:boilerplate/common/common.dart';
// import 'package:boilerplate/global/global_dropdown_slider.dart';
// import 'package:boilerplate/pages/main/controller/main_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../global/global_dropdown_button.dart';
// import '../../../global/global_click_button.dart';
// import 'package:multi_dropdown/multiselect_dropdown.dart';

// class ScenarioAppbar extends StatelessWidget {
//   const ScenarioAppbar({
//     super.key,
//     required this.values,
//     required this.items,
//     required this.onChanged,
//     required this.reset,
//     required this.output,
//     required this.multiController,
//   });

//   final List<RxString> values;
//   final List<RxList<String>> items;
//   final Function(int, String?) onChanged;
//   final Function reset;
//   final Function output;
//   final MultiSelectController<int> multiController;
//   static List<String> hintText = ['시도', '시군구', '시작 년도', '끝 년도', 'SSP'];

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         SizedBox(
//           height: 111,
//           child: Obx(() => ListView.builder(
//                 padding: const EdgeInsets.only(
//                     right: 10, top: 30, bottom: 30, left: 10),
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: MainController.to.subIndex.value == 0 ? 5 : 4,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Obx(
//                         () => GlobalDropdownButton(
//                           width: Common.bigSize.value ? 190 : 155,
//                           onChaged: (String? value) {
//                             onChanged(index, value);
//                           },
//                           item: values[index].value,
//                           items: items[index].value,
//                           hintText: hintText[index],
//                         ),
//                       ));
//                 },
//               )),
//         ),
//         Obx(
//           () => MainController.to.subIndex.value == 0
//               ? SizedBox(
//                   width: Common.bigSize.value ? 190 : 155,
//                   height: 50,
//                   child: MultiSelectDropDown(
//                       controller: multiController,
//                       borderRadius: 5,
//                       borderWidth: 1,
//                       borderColor: const Color(0xffdcdfe6),
//                       dropdownBorderRadius: 0,
//                       hint: 'GCM',
//                       hintColor: CommonColor.hintColor,
//                       hintFontSize: 32,
//                       hintPadding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 10),
//                       singleSelectItemStyle:
//                           CommonStyle.textStyleFontBlack25300,
//                       optionTextStyle: CommonStyle.textStyleFontBlack25300,
//                       chipConfig: ChipConfig(
//                           backgroundColor: CommonColor.mainColor,
//                           runSpacing: 3,
//                           padding: const EdgeInsets.only(left: 10, right: 2)),
//                       selectedOptionTextColor: CommonColor.fontBlack,
//                       selectedOptionIcon: Icon(Icons.expand_more,
//                           color: CommonColor.mainColor, size: 25),
//                       onOptionSelected: (options) {
//                         debugPrint(options.toString());
//                         if (options.isEmpty) {
//                           multiController.addSelectedOption(
//                               const ValueItem(label: '앙상블', value: 0));
//                         }
//                       },
//                       dropdownMargin: 2,
//                       options: Common.gcm))
//               : GlobalDropdownSlider(
//                   initial: 0,
//                   onDisplayChanged: (s) {
//                     values[4].value = s;
//                     print(values[4].value);
//                   },
//                 ),
//         ),
//         const Spacer(),
//         GlobalClickButton(isReset: true, onTap: reset),
//         Padding(
//           padding: const EdgeInsets.only(left: 10, right: 30),
//           child: GlobalClickButton(isReset: false, onTap: output),
//         ),
//       ],
//     );
//   }
// }
