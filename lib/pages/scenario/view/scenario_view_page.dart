import 'package:boilerplate/common/common.dart';
import 'package:boilerplate/global/result_table/result_table.dart';
import 'package:boilerplate/global/result_table/rt_factory.dart';
import 'package:boilerplate/pages/main/controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/scenario_controller.dart';
import '../widget/scenario_ap_chart.dart';
import '../widget/scenario_ap_timeseries_chart.dart';
import '../widget/scenario_temp_chart.dart';

class ScenarioViewPage extends GetView<ScenarioController> {
  const ScenarioViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.result.value;
      if (data == null) {
        return const Center(
          child: Text(
            '조회 버튼을 눌러 데이터를 불러오세요.',
            style: TextStyle(fontSize: 14, color: Colors.black45),
          ),
        );
      }

      final request = controller.fetchedRequest;
      final mode = request['mode']?.toString() ?? '';
      final isAP = mode == 'PM2.5' || mode == 'O3';
      final chartWidth = Common.bigSize.value ? 700.0 : 520.0;
      final chartTitle = _buildChartTitle(request);

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

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: chartWidth,
              child: isDefault
                  ? ScenarioApTimeSeriesChart(
                      data: data,
                      mode: mode,
                      chartTitle: chartTitle,
                    )
                  : ScenarioApChart(
                      data: data,
                      mode: mode,
                      chartTitle: chartTitle,
                      targetPeriod: targetPeriod,
                    ),
            ),
            const SizedBox(width: 24),
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
            const SizedBox(width: 24),
            ResultTable(tableSet: tableSet),
          ],
        );
      }
    });
  }

  String _buildChartTitle(Map<String, dynamic> request) {
    final mc = MainController.to;
    final sido = request['sido_']?.toString() ?? mc.filterSido.value;
    final region = (sido == '전체' || sido.isEmpty) ? '전국' : sido;
    final mode = request['mode']?.toString() ?? '';
    final isAP = mode == 'PM2.5' || mode == 'O3';

    if (isAP) {
      return '$region $mode 중간값 수준별 평균농도';
    } else {
      final sspRaw = request['ssp']?.toString() ?? '';
      final sspLabel = _sspLabel(sspRaw);
      return '$region $sspLabel 시나리오';
    }
  }

  String _sspLabel(String ssp) {
    const table = {
      'SSP126': 'SSP1-2.6',
      'SSP245': 'SSP2-4.5',
      'SSP370': 'SSP3-7.0',
      'SSP585': 'SSP5-8.5',
    };
    return table[ssp] ?? ssp;
  }

  List<String> _parseGcms(dynamic raw) {
    if (raw == null) return ['Ensemble'];
    if (raw is String) return [raw == '앙상블' ? 'Ensemble' : raw];
    if (raw is List) {
      return raw.map((e) => e.toString() == '앙상블' ? 'Ensemble' : e.toString()).toList();
    }
    return ['Ensemble'];
  }
}
