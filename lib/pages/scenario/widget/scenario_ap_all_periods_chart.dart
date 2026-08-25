import 'package:boilerplate/common/api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 기후변화시나리오 - 대기오염(PM2.5/O3) - 기간 전체 & 농도변화율만 선택한 상태 차트.
/// X축: 시점(기준기간/근/중/먼미래), Y축: 농도, 선택한 농도변화율 1개에 대한 4개 막대그래프.
class ScenarioApAllPeriodsChart extends StatelessWidget {
  const ScenarioApAllPeriodsChart({
    super.key,
    required this.data,
    required this.mode,
    required this.chartTitle,
    required this.changeAp,
  });

  final FutureExposureResponse data;
  final String mode;
  final String chartTitle;
  final int changeAp;

  static const Color _barColor = Color(0xFF1A3A6B);
  static const Color _baselineColor = Color(0xFFD32F2F);

  int get _decimals => mode == 'O3' ? 2 : 1;

  String _shortPeriodLabel(String period) {
    if (period.contains('2031-2040')) return '근미래';
    if (period.contains('2041-2060')) return '중미래';
    if (period.contains('2081-2100')) return '먼미래';
    return period;
  }

  // 근/중/먼미래로 정의된 3개 구간인지 여부 (2061-2080 등은 미정의 구간으로 제외)
  bool _isForecastPeriod(String period) =>
      period.contains('2031-2040') ||
      period.contains('2041-2060') ||
      period.contains('2081-2100');

  String _changeLabel(int v) {
    if (v == 0) return '기준(0%)';
    final sign = v > 0 ? '+' : '';
    return '$sign$v%';
  }

  @override
  Widget build(BuildContext context) {
    final baseline = data.selectedScenario.firstWhere(
      (e) => e['period']?.toString().contains('Baseline') == true,
      orElse: () => {},
    );
    final periodEntries = data.selectedScenario
        .where((e) => _isForecastPeriod(e['period']?.toString() ?? ''))
        .toList()
      ..sort((a, b) => (a['period']?.toString() ?? '')
          .compareTo(b['period']?.toString() ?? ''));

    final labels = <String>['기준'];
    final values = <double?>[(baseline['proj_val'] as num?)?.toDouble()];
    for (final e in periodEntries) {
      labels.add(_shortPeriodLabel(e['period']?.toString() ?? ''));
      values.add((e['proj_val'] as num?)?.toDouble());
    }

    final validVals = values.whereType<double>().toList();
    if (validVals.isEmpty) return const SizedBox.shrink();
    final maxY = validVals.reduce((a, b) => a > b ? a : b) * 1.22;

    final unitLabel = mode == 'PM2.5' ? '농도(μg/m³)' : '농도(ppm)';

    final barGroups = <BarChartGroupData>[
      for (int i = 0; i < values.length; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: values[i] ?? 0,
              color: i == 0 ? _baselineColor : _barColor,
              width: 28,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(2)),
            ),
          ],
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (chartTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(chartTitle,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333))),
          ),
        SizedBox(
          height: 380,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              minY: 0,
              barGroups: barGroups,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (v) => FlLine(
                    color: Colors.grey.withOpacity(0.15), strokeWidth: 1),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.black54, width: 1),
                  bottom: BorderSide(color: Colors.black54, width: 1),
                ),
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: const Color(0xFF333333),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${labels[group.x]}\n${rod.toY.toStringAsFixed(_decimals)}',
                      const TextStyle(color: Colors.white, fontSize: 11),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(unitLabel,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 52,
                    getTitlesWidget: (value, meta) => Text(
                      value.toStringAsFixed(_decimals),
                      style:
                          const TextStyle(fontSize: 10, color: Colors.black87),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('시점',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  axisNameSize: 32,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= labels.length) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 6,
                        child: Text(labels[i],
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black87)),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(width: 16, height: 14, color: _baselineColor),
            const SizedBox(width: 5),
            const Text('기준기간(2015-2019)', style: TextStyle(fontSize: 11)),
            const SizedBox(width: 18),
            Container(width: 16, height: 14, color: _barColor),
            const SizedBox(width: 5),
            Text(_changeLabel(changeAp), style: const TextStyle(fontSize: 11)),
          ],
        ),
      ],
    );
  }
}
