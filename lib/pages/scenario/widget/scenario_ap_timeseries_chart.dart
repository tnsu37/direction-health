import 'package:boilerplate/common/api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 기후변화시나리오 - 대기오염(PM2.5/O3) - 디폴트/지역선택 상태 차트.
/// X축: 시점(근/중/먼미래), Y축: 농도, 범례: 변화율(%) 시계열 라인차트.
/// (기간/농도변화를 좁혀 선택한 상태는 [ScenarioApChart] 막대그래프를 그대로 사용)
class ScenarioApTimeSeriesChart extends StatelessWidget {
  const ScenarioApTimeSeriesChart({
    super.key,
    required this.data,
    required this.mode,
    required this.chartTitle,
  });

  final FutureExposureResponse data;
  final String mode;
  final String chartTitle;

  static const List<String> _periodKeys = [
    '2031-2040',
    '2041-2060',
    '2081-2100'
  ];
  static const List<String> _periodLabels = ['근미래', '중미래', '먼미래'];

  Color _colorFor(int changeAp) {
    if (changeAp == 0) return const Color(0xFF222222);
    final t = (changeAp.abs() / 30).clamp(0.0, 1.0);
    return changeAp < 0
        ? Color.lerp(const Color(0xFFA5D6A7), const Color(0xFF1B5E20), t)!
        : Color.lerp(const Color(0xFFFFCC80), const Color(0xFFE65100), t)!;
  }

  int get _decimals => mode == 'O3' ? 2 : 1;

  String _changeApLabel(int v) {
    if (v == 0) return '기준(0%)';
    final sign = v > 0 ? '+' : '';
    return '$sign$v%';
  }

  @override
  Widget build(BuildContext context) {
    // changeAp → [근미래, 중미래, 먼미래] 농도값
    final Map<int, List<double?>> byChangeAp = {};
    for (final e in data.fullSummary) {
      final period = e['period']?.toString() ?? '';
      final idx = _periodKeys.indexWhere((p) => period.contains(p));
      if (idx == -1) continue; // baseline 등 제외
      final ca = (e['change_ap'] as num?)?.toInt() ?? 0;
      final v = (e['proj_val'] as num?)?.toDouble();
      final list =
          byChangeAp.putIfAbsent(ca, () => List<double?>.filled(3, null));
      list[idx] = v;
    }

    if (byChangeAp.isEmpty) return const SizedBox.shrink();

    final changeAps = byChangeAp.keys.toList()..sort();

    final allVals =
        byChangeAp.values.expand((l) => l).whereType<double>().toList();
    if (allVals.isEmpty) return const SizedBox.shrink();
    final minVal = allVals.reduce((a, b) => a < b ? a : b);
    final maxVal = allVals.reduce((a, b) => a > b ? a : b);
    final pad = (maxVal - minVal) * 0.15;
    final yMin = pad == 0 ? minVal - 1 : minVal - pad;
    final yMax = pad == 0 ? maxVal + 1 : maxVal + pad;

    final bars = changeAps.map((ca) {
      final isBaseline = ca == 0;
      final list = byChangeAp[ca]!;
      final spots = <FlSpot>[
        for (var i = 0; i < list.length; i++)
          if (list[i] != null) FlSpot(i.toDouble(), list[i]!),
      ];
      final color = _colorFor(ca);
      return LineChartBarData(
        spots: spots,
        isCurved: false,
        color: color,
        barWidth: isBaseline ? 2.5 : 1.3,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
              radius: isBaseline ? 3 : 2, color: color, strokeWidth: 0),
        ),
        belowBarData: BarAreaData(show: false),
      );
    }).toList();

    final unitLabel = mode == 'PM2.5' ? '농도(μg/m³)' : '농도(ppm)';

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
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (_periodKeys.length - 1).toDouble(),
              minY: yMin,
              maxY: yMax,
              clipData: const FlClipData.all(),
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
                      style: const TextStyle(fontSize: 10, color: Colors.black87),
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
                      final idx = value.toInt();
                      if (idx < 0 || idx >= _periodLabels.length)
                        return const SizedBox.shrink();
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 6,
                        child: Text(_periodLabels[idx],
                            style: const TextStyle(fontSize: 10)),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => spots.map((spot) {
                    final ca = changeAps[spot.barIndex];
                    return LineTooltipItem(
                      '${_changeApLabel(ca)}\n${spot.y.toStringAsFixed(_decimals)}',
                      const TextStyle(color: Colors.white, fontSize: 11),
                    );
                  }).toList(),
                ),
              ),
              lineBarsData: bars,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: changeAps.map((ca) {
            final isBaseline = ca == 0;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 16,
                    height: isBaseline ? 3 : 2,
                    color: _colorFor(ca)),
                const SizedBox(width: 4),
                Text(_changeApLabel(ca),
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            isBaseline ? FontWeight.w700 : FontWeight.normal)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
