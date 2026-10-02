import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/global/result_table/result_table.dart';
import 'package:boilerplate/global/result_table/rt_factory.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/scenario_controller.dart';
import '../widget/scenario_ap_all_periods_chart.dart';
import '../widget/scenario_ap_chart.dart';
import '../widget/scenario_ap_timeseries_chart.dart';
import '../widget/scenario_temp_chart.dart';

class ScenarioViewPage extends GetView<ScenarioController> {
  const ScenarioViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.result.value;
      final request = controller.fetchedRequest;
      final mode = request['mode']?.toString() ?? '';
      final isAP = mode == 'PM2.5' || mode == 'O3';
      final chartWidth = Common.bigSize.value ? 750.0 : 520.0;
      final chartTitle = controller.chartTitle;

      final tableSet = ResultTableFactory.fromFutureScenario(
        request: request,
        data: data,
      );

      if (isAP) {
        final targetPeriod = (request['target_period'] ?? '전체').toString();
        final changeApRaw = request['change_ap_'] ?? request['change_ap'];
        final changeAp = (changeApRaw is num) ? changeApRaw.toInt() : 0;
        // 기간·농도변화를 아직 좁혀 선택하지 않은 디폴트/지역선택 상태 → 시계열 라인차트
        final isDefault = targetPeriod == '전체' && changeAp == 0;
        // 기간은 전체, 농도변화율만 특정 값을 선택한 상태 → 시점별(기준/근/중/먼미래) 4개 막대그래프
        final isAllPeriodsSelected = targetPeriod == '전체' && changeAp != 0;

        final Widget apChart;
        if (isDefault) {
          apChart = ScenarioApTimeSeriesChart(
            data: data,
            mode: mode,
            chartTitle: chartTitle,
          );
        } else if (isAllPeriodsSelected) {
          apChart = ScenarioApAllPeriodsChart(
            data: data,
            mode: mode,
            chartTitle: chartTitle,
            changeAp: changeAp,
          );
        } else {
          apChart = ScenarioApChart(
            data: data,
            mode: mode,
            chartTitle: chartTitle,
            targetPeriod: targetPeriod,
            changeAp: changeAp,
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: chartWidth,
              child: apChart,
            ),
            const SizedBox(width: 50),
            ResultTable(tableSet: tableSet),
          ],
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: chartWidth,
              child: ScenarioTempChart(
                data: data,
                mode: mode,
                chartTitle: chartTitle,
                selectedGcms: _parseGcms(request['gcm']),
              ),
            ),
            const SizedBox(width: 50),
            ResultTable(tableSet: tableSet),
          ],
        );
      }
    });
  }

  List<String> _parseGcms(dynamic raw) {
    if (raw == null) return ['Ensemble'];
    if (raw is String) return [raw == '앙상블' ? 'Ensemble' : raw];
    if (raw is List) {
      return raw
          .map((e) => e.toString() == '앙상블' ? 'Ensemble' : e.toString())
          .toList();
    }
    return ['Ensemble'];
  }
}
