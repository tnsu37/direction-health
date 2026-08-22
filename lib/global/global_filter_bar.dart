import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import './global_dropdown_slider.dart';

class GlobalFilterBar extends StatelessWidget {
  const GlobalFilterBar({super.key, required this.controller});
  final MainController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildByConfig(controller.filterConfig));
  }

  Widget _buildByConfig(FilterConfig cfg) {
    switch (cfg) {
      /// 과거노출 > 연중 온도
      case FilterConfig.exposureTemp:
        return _FilterCard(rows: [
          _FilterRow(items: [
            _StyledDropdown(
                item: _DropdownItem(
              label: '연도',
              value: controller.filterYear.value,
              options: Common.years,
              onChanged: (v) => controller.filterYear.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '월',
              value: controller.filterMonth.value,
              options: Common.months,
              onChanged: (v) => controller.filterMonth.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시도',
              value: controller.filterSido.value,
              options: Common.sido1,
              onChanged: (v) {
                controller.filterSido.value = v!;
                controller.filterSigungu.value = '전체';
              },
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시군구',
              value: controller.filterSigungu.value,
              options: controller.sgg,
              onChanged: (v) => controller.filterSigungu.value = v!,
            )),
          ], controller: controller),
        ]);

      /// 과거노출 > 여름철 온도
      case FilterConfig.exposureSummerTemp:
        return _FilterCard(rows: [
          _FilterRow(items: [
            _StyledDropdown(
                item: _DropdownItem(
              label: '연도',
              value: controller.filterYear.value,
              options: Common.years,
              onChanged: (v) => controller.filterYear.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '월',
              value: controller.filterMonth.value,
              options: Common.summer,
              onChanged: (v) => controller.filterMonth.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시도',
              value: controller.filterSido.value,
              options: Common.sido1,
              onChanged: (v) {
                controller.filterSido.value = v!;
                controller.filterSigungu.value = '전체';
              },
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시군구',
              value: controller.filterSigungu.value,
              options: controller.sgg,
              onChanged: (v) => controller.filterSigungu.value = v!,
            )),
          ], controller: controller),
        ]);

      /// 과거노출 > 여름철 오존
      case FilterConfig.exposureSummerO3:
        return _FilterCard(rows: [
          _FilterRow(items: [
            _StyledDropdown(
                item: _DropdownItem(
              label: '연도',
              value: controller.filterYear.value,
              options: Common.years2,
              onChanged: (v) => controller.filterYear.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '월',
              value: controller.filterMonth.value,
              options: Common.summer,
              onChanged: (v) => controller.filterMonth.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시도',
              value: controller.filterSido.value,
              options: Common.sido1,
              onChanged: (v) {
                controller.filterSido.value = v!;
                controller.filterSigungu.value = '전체';
              },
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시군구',
              value: controller.filterSigungu.value,
              options: controller.sgg,
              onChanged: (v) => controller.filterSigungu.value = v!,
            )),
          ], controller: controller),
        ]);

      /// 과거노출 > 초미세먼지(PM2.5)
      case FilterConfig.exposurePM:
        return _FilterCard(rows: [
          _FilterRow(items: [
            _StyledDropdown(
                item: _DropdownItem(
              label: '연도',
              value: controller.filterYear.value,
              options: Common.years2,
              onChanged: (v) => controller.filterYear.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '월',
              value: controller.filterMonth.value,
              options: Common.months,
              onChanged: (v) => controller.filterMonth.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시도',
              value: controller.filterSido.value,
              options: Common.sido2,
              onChanged: (v) {
                controller.filterSido.value = v!;
                controller.filterSigungu.value = '전체';
              },
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시군구',
              value: controller.filterSigungu.value,
              options: controller.sgg,
              onChanged: (v) => controller.filterSigungu.value = v!,
            )),
          ], controller: controller),
        ]);

      /// 건강영향 > 사망 > 여름철 온도
      case FilterConfig.healthImpactDeath:
        return _FilterCard(rows: [
          _FilterRow(items: [
            _StyledDropdown(
                item: _DropdownItem(
              label: '시도',
              value: controller.filterSido.value,
              options: Common.sido1,
              onChanged: (v) {
                controller.filterSido.value = v!;
                controller.filterSigungu.value = '전체';
              },
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시군구',
              value: controller.filterSigungu.value,
              options: controller.sgg,
              onChanged: (v) => controller.filterSigungu.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '평가그룹',
              value: controller.filterEvalGroup.value,
              options: Common.evalGroups1,
              onChanged: (v) => controller.filterEvalGroup.value = v!,
            )),
          ], controller: controller),
        ]);

      /// 건강영향 > 쯔쯔가무시병 > 연중온도
      case FilterConfig.healthImpactScrubTyphus:
        return _FilterCard(rows: [
          _FilterRow(items: [
            _StyledDropdown(
                item: _DropdownItem(
              label: '시도',
              value: controller.filterSido.value,
              options: Common.sido1,
              onChanged: (v) => controller.filterSido.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시군구',
              value: controller.filterSigungu.value,
              options: controller.sgg,
              onChanged: (v) => controller.filterSigungu.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '평가그룹',
              value: controller.filterEvalGroup.value,
              options: Common.evalGroups2,
              onChanged: (v) => controller.filterEvalGroup.value = v!,
            )),
          ], controller: controller),
        ]);

      /// 건강영향 > 말라리아 > 연중온도
      case FilterConfig.healthImpactMalaria:
        return _FilterCard(rows: [
          _FilterRow(items: [
            _StyledDropdown(
                item: _DropdownItem(
              label: '시도',
              value: controller.filterSido.value,
              options: Common.sido3,
              onChanged: (v) {
                controller.filterSido.value = v!;
                controller.filterSigungu.value = '전체';
              },
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시군구',
              value: controller.filterSigungu.value,
              options: controller.sgg,
              onChanged: (v) => controller.filterSigungu.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '평가그룹',
              value: controller.filterEvalGroup.value,
              options: Common.evalGroups2,
              onChanged: (v) => controller.filterEvalGroup.value = v!,
            )),
          ], controller: controller),
        ]);

      /// 건강영향 > 수인성 > 연중온도
      case FilterConfig.healthImpactWaterborne:
        return _FilterCard(rows: [
          _FilterRow(items: [
            _StyledDropdown(
                item: _DropdownItem(
              label: '시도',
              value: controller.filterSido.value,
              options: Common.sido1,
              onChanged: (v) {
                controller.filterSido.value = v!;
                controller.filterSigungu.value = '전체';
              },
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시군구',
              value: controller.filterSigungu.value,
              options: controller.sgg,
              onChanged: (v) => controller.filterSigungu.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '평가그룹',
              value: controller.filterEvalGroup.value,
              options: Common.evalGroups3,
              onChanged: (v) => controller.filterEvalGroup.value = v!,
            )),
          ], controller: controller),
        ]);

      /// 기후변화 시나리오 > 온도 (연중 온도 & 여름철 온도)
      case FilterConfig.climateTempScenario:
        return _FilterCard(rows: [
          _FilterRow(
              showSearchBtn: false,
              items: [
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시도',
                  value: controller.filterSido.value,
                  options: Common.sido1,
                  onChanged: (v) {
                    controller.filterSido.value = v!;
                    controller.filterSigungu.value = '전체';
                  },
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시군구',
                  value: controller.filterSigungu.value,
                  options: controller.sgg,
                  onChanged: (v) => controller.filterSigungu.value = v!,
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '기간',
                  value: controller.filterPeriod.value,
                  options: Common.periods,
                  onChanged: (v) => controller.filterPeriod.value = v!,
                )),
              ],
              controller: controller),
          _FilterRow(items: [
            _StyledDropdown(
                item: _DropdownItem(
              label: '시나리오',
              value: controller.filterScenario.value,
              options: Common.scenarios,
              onChanged: (v) => controller.filterScenario.value = v!,
            )),
            _MultiDropdownItem(
              label: '기후모형',
              options: Common.climateModels,
              selectedValues: controller.filterClimateModels,
              onChanged: controller.setClimateModels,
            ),
          ], controller: controller),
        ]);

      /// 기후변화 시나리오 > AP(PM2.5 & O3)
      case FilterConfig.climateAPScenario:
        return _FilterCard(rows: [
          _FilterRow(items: [
            _StyledDropdown(
                item: _DropdownItem(
              label: '시도',
              value: controller.filterSido.value,
              options: Common.sido2,
              onChanged: (v) {
                controller.filterSido.value = v!;
                controller.filterSigungu.value = '전체';
              },
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시군구',
              value: controller.filterSigungu.value,
              options: controller.sgg,
              onChanged: (v) => controller.filterSigungu.value = v!,
            )),
            _StyledDropdown(
                item: _DropdownItem(
              label: '기간',
              value: controller.filterPeriod.value,
              options: Common.periods,
              onChanged: (v) => controller.filterPeriod.value = v!,
            )),
            _ConcChangeSliderItem(
              value: controller.filterConcChange.value,
              onChanged: (v) => controller.filterConcChange.value = v,
            ),
          ], controller: controller),
        ]);

      /// 건강영향 미래 추정 > 사망 > 여름철 온도
      case FilterConfig.futureHealthTemp:
        return _FilterCard(rows: [
          _FilterRow(
              showSearchBtn: false,
              items: [
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시도',
                  value: controller.filterSido.value,
                  options: Common.sido1,
                  onChanged: (v) {
                    controller.filterSido.value = v!;
                    controller.filterSigungu.value = '전체';
                  },
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시군구',
                  value: controller.filterSigungu.value,
                  options: controller.sgg,
                  onChanged: (v) => controller.filterSigungu.value = v!,
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '기간',
                  value: controller.filterPeriod.value,
                  options: Common.periods,
                  onChanged: (v) => controller.filterPeriod.value = v!,
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '평가그룹',
                  value: controller.filterEvalGroup.value,
                  options: Common.evalGroups1,
                  onChanged: (v) => controller.filterEvalGroup.value = v!,
                )),
              ],
              controller: controller),
          _FilterRow(items: [
            _StyledDropdown(
                item: _DropdownItem(
              label: '시나리오',
              value: controller.filterScenario.value,
              options: Common.scenarios,
              onChanged: (v) => controller.filterScenario.value = v!,
            )),
            _MultiDropdownItem(
              label: '기후모형',
              options: Common.climateModels,
              selectedValues: controller.filterClimateModels,
              onChanged: controller.setClimateModels,
            ),
            _StyledDropdown(
                item: _DropdownItem(
              label: '적응정책',
              value: controller.filterAdaptation.value,
              options: Common.adaptations1,
              onChanged: (v) => controller.filterAdaptation.value = v!,
            )),
          ], controller: controller),
        ]);

      /// 건강영향 미래 추정 > 사망 > 초미세먼지
      case FilterConfig.futureHealthPm25:
        return _FilterCard(rows: [
          _FilterRow(
              showSearchBtn: false,
              items: [
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시도',
                  value: controller.filterSido.value,
                  options: Common.sido1,
                  onChanged: (v) {
                    controller.filterSido.value = v!;
                    controller.filterSigungu.value = '전체';
                  },
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시군구',
                  value: controller.filterSigungu.value,
                  options: controller.sgg,
                  onChanged: (v) => controller.filterSigungu.value = v!,
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '기간',
                  value: controller.filterPeriod.value,
                  options: Common.periods,
                  onChanged: (v) => controller.filterPeriod.value = v!,
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '평가그룹',
                  value: controller.filterEvalGroup.value,
                  options: Common.evalGroups1,
                  onChanged: (v) => controller.filterEvalGroup.value = v!,
                )),
              ],
              controller: controller),
          _FilterRow(items: [
            _ConcChangeSliderItem(
              value: controller.filterConcChange.value,
              onChanged: (v) => controller.filterConcChange.value = v,
            ),
          ], controller: controller),
        ]);

      /// 건강영향 미래 추정 > 사망 > 오존
      case FilterConfig.futureHealthO3:
        return _FilterCard(rows: [
          _FilterRow(
              showSearchBtn: false,
              items: [
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시도',
                  value: controller.filterSido.value,
                  options: Common.sido1,
                  onChanged: (v) {
                    controller.filterSido.value = v!;
                    controller.filterSigungu.value = '전체';
                  },
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시군구',
                  value: controller.filterSigungu.value,
                  options: controller.sgg,
                  onChanged: (v) => controller.filterSigungu.value = v!,
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '기간',
                  value: controller.filterPeriod.value,
                  options: Common.periods,
                  onChanged: (v) => controller.filterPeriod.value = v!,
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '평가그룹',
                  value: controller.filterEvalGroup.value,
                  options: Common.evalGroups1,
                  onChanged: (v) => controller.filterEvalGroup.value = v!,
                )),
              ],
              controller: controller),
          _FilterRow(items: [
            _ConcChangeSliderItem(
              value: controller.filterConcChange.value,
              onChanged: (v) => controller.filterConcChange.value = v,
            ),
            _StyledDropdown(
                item: _DropdownItem(
              label: '시나리오',
              value: controller.filterScenario.value,
              options: Common.scenarios,
              onChanged: (v) => controller.filterScenario.value = v!,
            )),
          ], controller: controller),
        ]);

      /// 건강영향 미래 추정 > 쯔쯔가무시병 > 연중 온도
      case FilterConfig.futureHealthScrubTyphus:
        return _FilterCard(rows: [
          _FilterRow(
              showSearchBtn: false,
              items: [
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시도',
                  value: controller.filterSido.value,
                  options: Common.sido1,
                  onChanged: (v) {
                    controller.filterSido.value = v!;
                    controller.filterSigungu.value = '전체';
                  },
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시군구',
                  value: controller.filterSigungu.value,
                  options: controller.sgg,
                  onChanged: (v) => controller.filterSigungu.value = v!,
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '기간',
                  value: controller.filterPeriod.value,
                  options: Common.periods,
                  onChanged: (v) => controller.filterPeriod.value = v!,
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '평가그룹',
                  value: controller.filterEvalGroup.value,
                  options: Common.evalGroups2,
                  onChanged: (v) => controller.filterEvalGroup.value = v!,
                )),
              ],
              controller: controller),
          _FilterRow(items: [
            _StyledDropdown(
                item: _DropdownItem(
              label: '시나리오',
              value: controller.filterScenario.value,
              options: Common.scenarios,
              onChanged: (v) => controller.filterScenario.value = v!,
            )),
            _MultiDropdownItem(
              label: '기후모형',
              options: Common.climateModels,
              selectedValues: controller.filterClimateModels,
              onChanged: controller.setClimateModels,
            ),
          ], controller: controller),
        ]);

      /// 건강영향 미래 추정 > 말라리아 > 연중 온도
      case FilterConfig.futureHealthMalaria:
        return _FilterCard(rows: [
          _FilterRow(
              showSearchBtn: false,
              items: [
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시도',
                  value: controller.filterSido.value,
                  options: Common.sido3,
                  onChanged: (v) {
                    controller.filterSido.value = v!;
                    controller.filterSigungu.value = '전체';
                  },
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시군구',
                  value: controller.filterSigungu.value,
                  options: controller.sgg,
                  onChanged: (v) => controller.filterSigungu.value = v!,
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '기간',
                  value: controller.filterPeriod.value,
                  options: Common.periods,
                  onChanged: (v) => controller.filterPeriod.value = v!,
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '평가그룹',
                  value: controller.filterEvalGroup.value,
                  options: Common.evalGroups2,
                  onChanged: (v) => controller.filterEvalGroup.value = v!,
                )),
              ],
              controller: controller),
          _FilterRow(items: [
            _StyledDropdown(
                item: _DropdownItem(
              label: '시나리오',
              value: controller.filterScenario.value,
              options: Common.scenarios,
              onChanged: (v) => controller.filterScenario.value = v!,
            )),
            _MultiDropdownItem(
              label: '기후모형',
              options: Common.climateModels,
              selectedValues: controller.filterClimateModels,
              onChanged: controller.setClimateModels,
            ),
          ], controller: controller),
        ]);

      /// 건강영향 미래 추정 > 수인성 감염병 > 연중 온도
      case FilterConfig.futureHealthWaterborne:
        return _FilterCard(rows: [
          _FilterRow(
              showSearchBtn: false,
              items: [
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시도',
                  value: controller.filterSido.value,
                  options: Common.sido1,
                  onChanged: (v) {
                    controller.filterSido.value = v!;
                    controller.filterSigungu.value = '전체';
                  },
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '시군구',
                  value: controller.filterSigungu.value,
                  options: controller.sgg,
                  onChanged: (v) => controller.filterSigungu.value = v!,
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '기간',
                  value: controller.filterPeriod.value,
                  options: Common.periods,
                  onChanged: (v) => controller.filterPeriod.value = v!,
                )),
                _StyledDropdown(
                    item: _DropdownItem(
                  label: '평가그룹',
                  value: controller.filterEvalGroup.value,
                  options: Common.evalGroups3,
                  onChanged: (v) => controller.filterEvalGroup.value = v!,
                )),
              ],
              controller: controller),
          _FilterRow(items: [
            _StyledDropdown(
              item: _DropdownItem(
                label: '시나리오',
                value: controller.filterScenario.value,
                options: Common.scenarios,
                onChanged: (v) => controller.filterScenario.value = v!,
              ),
            ),
            _MultiDropdownItem(
              label: '기후모형',
              options: Common.climateModels,
              selectedValues: controller.filterClimateModels,
              onChanged: controller.setClimateModels,
            ),
          ], controller: controller),
        ]);
    }
  }
}

// ──────────────────────────────────────────────
//  Internal layout helpers
// ──────────────────────────────────────────────

class _FilterCard extends StatelessWidget {
  const _FilterCard({required this.rows});
  final List<_FilterRow> rows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 37),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows
            .asMap()
            .entries
            .map((e) => Padding(
                  padding: EdgeInsets.only(top: e.key == 0 ? 0 : 30),
                  child: e.value,
                ))
            .toList(),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.items,
    required this.controller,
    this.showSearchBtn = true,
  });

  final List<Widget> items;
  final MainController controller;
  final bool showSearchBtn;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...items.map((item) => Padding(
              padding: EdgeInsets.only(right: Common.bigSize.value ? 30 : 15),
              child: item,
            )),
        if (showSearchBtn) _SearchButton(onTap: controller.search),
      ],
    );
  }
}

class _DropdownItem {
  const _DropdownItem({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });
  final String label;
  final String value;
  final List<String> options;
  final void Function(String?) onChanged;
}

// ──────────────────────────────────────────────
//  Styled dropdown
// ──────────────────────────────────────────────

class _StyledDropdown extends StatelessWidget {
  const _StyledDropdown({required this.item});
  final _DropdownItem item;

  @override
  Widget build(BuildContext context) {
    bool big = Common.bigSize.value;
    return SizedBox(
      width: big ? 294 : 200.2,
      height: big ? 44 : 37,
      child: Row(
        children: [
          Text(item.label,
              style: big
                  ? CommonStyle.textStyleFontBlack24500
                  : CommonStyle.textStyleFontBlack14500),
          SizedBox(width: big ? 10 : 5),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                value: item.value,
                items: item.options
                    .map(
                      (o) => DropdownMenuItem(
                          value: o,
                          child: Text(o,
                              style: (big
                                  ? CommonStyle.textStyleFontBlack20300
                                  : CommonStyle.textStyleFontBlack13300))),
                    )
                    .toList(),
                onChanged: item.onChanged,
                iconStyleData: IconStyleData(
                  icon: const Icon(Icons.expand_more),
                  iconSize: big ? 20 : 15,
                  iconEnabledColor: CommonColor.hintColor,
                ),
                buttonStyleData: ButtonStyleData(
                  padding: EdgeInsets.only(right: big ? 10 : 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(color: const Color(0xffdcdfe6))),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 350,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xff101828).withOpacity(0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 2),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3)),
                  offset: const Offset(0, -4),
                  elevation: 6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
//  복수선택 드롭박스
// ──────────────────────────────────────────────

class _MultiDropdownItem extends StatefulWidget {
  const _MultiDropdownItem({
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
  });

  final String label;
  final List<String> options;
  final RxList<String> selectedValues;
  final void Function(List<String>) onChanged;

  @override
  State<_MultiDropdownItem> createState() => _MultiDropdownItemState();
}

class _MultiDropdownItemState extends State<_MultiDropdownItem> {
  late final MultiSelectController<String> _controller;

  static const List<String> _defaultValues = ['앙상블', 'WRF'];

  List<ValueItem<String>> get _optionItems =>
      widget.options.map((e) => ValueItem<String>(label: e, value: e)).toList();

  List<ValueItem<String>> _toValueItems(List<String> values) {
    return widget.options
        .where((e) => values.contains(e))
        .map((e) => ValueItem<String>(label: e, value: e))
        .toList();
  }

  @override
  void initState() {
    super.initState();

    _controller = MultiSelectController<String>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller.setOptions(_optionItems);
      _controller.setSelectedOptions(_toValueItems(widget.selectedValues));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncControllerWithRx() {
    final selectedItems = _toValueItems(widget.selectedValues);

    final current = _controller.selectedOptions
        .map((e) => e.value)
        .whereType<String>()
        .toList();

    if (current.join('|') == widget.selectedValues.join('|')) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller.setSelectedOptions(selectedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool big = Common.bigSize.value;

    return SizedBox(
      width: big ? 618.4 : 415,
      height: big ? 44 : 37,
      child: Row(
        children: [
          Text(
            widget.label,
            style: big
                ? CommonStyle.textStyleFontBlack24500
                : CommonStyle.textStyleFontBlack14500,
          ),
          SizedBox(width: big ? 10 : 5),
          Expanded(
            child: Obx(() {
              _syncControllerWithRx();

              return MultiSelectDropDown<String>(
                controller: _controller,
                selectedOptions: _toValueItems(widget.selectedValues),
                options: _optionItems,
                onOptionSelected: (selectedOptions) {
                  final selected = selectedOptions
                      .map((e) => e.value)
                      .whereType<String>()
                      .toList();

                  print('선택: $selected');

                  if (selected.isEmpty) {
                    widget.onChanged(_defaultValues);
                    return;
                  }

                  widget.onChanged(selected);
                },
                clearIcon: null,
                suffixIcon: Icon(
                  Icons.expand_more,
                  size: Common.bigSize.value ? 20 : 15,
                  color: CommonColor.hintColor,
                ),
                animateSuffixIcon: false,
                padding: const EdgeInsets.only(right: 5, left: 15),
                borderRadius: 5,
                borderWidth: 1,
                borderColor: const Color(0xffdcdfe6),
                focusedBorderColor: const Color(0xffdcdfe6),
                focusedBorderWidth: 1,
                dropdownBorderRadius: 3,
                dropdownMargin: 2,
                optionTextStyle: big
                    ? CommonStyle.textStyleFontBlack20300
                    : CommonStyle.textStyleFontBlack13300,
                selectedOptionIcon: const Icon(Icons.check, size: 10),
                selectedOptionTextColor: CommonColor.fontBlack,
                chipConfig: const ChipConfig(
                  wrapType: WrapType.scroll,
                  backgroundColor: Colors.transparent,
                  runSpacing: 0,
                  spacing: 0,
                  padding: EdgeInsets.zero,
                ),
                selectedItemBuilder: (context, item) {
                  final values = widget.selectedValues;
                  final index = values.indexOf(item.value ?? '');

                  final text = index == values.length - 1
                      ? item.label
                      : '${item.label}, ';

                  return Center(
                    heightFactor: 1,
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: big
                          ? CommonStyle.textStyleFontBlack20300
                          : CommonStyle.textStyleFontBlack13300,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
//  농도 변화율 탭
// ──────────────────────────────────────────────
class _ConcChangeSliderItem extends StatelessWidget {
  const _ConcChangeSliderItem({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    final bool big = Common.bigSize.value;

    return SizedBox(
      width: big ? 288.2 : 200.2,
      height: big ? 44 : 37,
      child: Row(
        children: [
          Text(
            '농도변화율',
            style: big
                ? CommonStyle.textStyleFontBlack24500
                : CommonStyle.textStyleFontBlack14500,
          ),
          SizedBox(width: big ? 10 : 5),
          Expanded(
            child: GlobalDropdownSlider(
              initial: value,
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
//  Search button
// ──────────────────────────────────────────────

class _SearchButton extends StatelessWidget {
  const _SearchButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    bool big = Common.bigSize.value;
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: big ? 44 : 37,
          width: big ? 100 : 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: CommonColor.mainColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text('조회',
              style: big
                  ? CommonStyle.textStyleWhite20500
                  : CommonStyle.textStyleWhite15500),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
//  Download buttons row (시각화 저장 / CSV 저장)
// ──────────────────────────────────────────────

// class DownloadButtonsRow extends StatelessWidget {
//   const DownloadButtonsRow({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _DownloadBtn(
//           icon: Icons.image_outlined,
//           label: '시각화 저장',
//           onTap: () {},
//         ),
//         const SizedBox(width: 8),
//         _DownloadBtn(
//           icon: Icons.download_outlined,
//           label: 'CSV 저장',
//           onTap: () {},
//         ),
//       ],
//     );
//   }
// }

// class _DownloadBtn extends StatefulWidget {
//   const _DownloadBtn({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   @override
//   State<_DownloadBtn> createState() => _DownloadBtnState();
// }

// class _DownloadBtnState extends State<_DownloadBtn> {
//   bool _hover = false;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _hover = true),
//       onExit: (_) => setState(() => _hover = false),
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: widget.onTap,
//         child: Container(
//           height: 30,
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: _hover ? const Color(0xFFF5F5F5) : Colors.white,
//             border: Border.all(color: DirectionColors.downloadBtnBorder),
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(widget.icon, size: 14, color: const Color(0xFF555555)),
//               const SizedBox(width: 5),
//               Text(widget.label, style: DirectionTextStyle.downloadBtn),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
