import 'package:boilerplate/common/api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScenarioApChart extends StatelessWidget {
  const ScenarioApChart({
    super.key,
    required this.data,
    required this.mode,
    required this.chartTitle,
    required this.targetPeriod,
  });

  final FutureExposureResponse data;
  final String mode;
  final String chartTitle;
  final String targetPeriod;

  static const Color _barColor = Color(0xFF1A3A6B);
  static const Color _baselineColor = Color(0xFFD32F2F);

  @override
  Widget build(BuildContext context) {
    // 표시할 기간 결정 — '전체'이면 첫 번째 non-baseline 기간
    String displayPeriod = targetPeriod;
    if (displayPeriod == '전체') {
      final first = data.fullSummary.firstWhere(
        (e) => !(e['period']?.toString().contains('Baseline') == true),
        orElse: () => {},
      );
      displayPeriod = first['period']?.toString() ?? '';
    }

    final entries = data.fullSummary
        .where((e) => e['period']?.toString() == displayPeriod)
        .toList()
      ..sort((a, b) => ((a['change_ap'] as num?)?.toInt() ?? 0)
          .compareTo((b['change_ap'] as num?)?.toInt() ?? 0));

    if (entries.isEmpty) return const SizedBox.shrink();

    final changeAps = entries.map((e) => (e['change_ap'] as num).toInt()).toList();
    final projVals = entries.map((e) => (e['proj_val'] as num).toDouble()).toList();
    final maxY = projVals.reduce((a, b) => a > b ? a : b) * 1.22;

    final unitLabel = mode == 'PM2.5' ? '농도(μg/m³)' : '농도(ppm)';
    final labelEvery = changeAps.length > 15 ? 2 : 1;

    final barGroups = entries.asMap().entries.map((entry) {
      final i = entry.key;
      final ca = changeAps[i];
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: projVals[i],
            color: ca == 0 ? _baselineColor : _barColor,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
          ),
        ],
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (chartTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(chartTitle,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
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
                getDrawingHorizontalLine: (v) =>
                    FlLine(color: Colors.grey.withOpacity(0.15), strokeWidth: 1),
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
                    final ca = changeAps[group.x];
                    final sign = ca > 0 ? '+' : '';
                    final label = ca == 0 ? '기준(0%)' : '$sign$ca%';
                    return BarTooltipItem(
                      '$label\n${rod.toY.toStringAsFixed(2)}',
                      const TextStyle(color: Colors.white, fontSize: 11),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(unitLabel,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  sideTitles: const SideTitles(showTitles: true, reservedSize: 52),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('농도변화 수준(%)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  axisNameSize: 32,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= changeAps.length) return const SizedBox.shrink();
                      if (i % labelEvery != 0) return const SizedBox.shrink();
                      final ca = changeAps[i];
                      final sign = ca > 0 ? '+' : '';
                      final label = ca == 0 ? '기준' : '$sign$ca%';
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 6,
                        child: Text(label, style: const TextStyle(fontSize: 9, color: Colors.black87)),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Legend
        Row(
          children: [
            Container(width: 16, height: 14, color: _baselineColor,
                child: const SizedBox.shrink()),
            const SizedBox(width: 5),
            const Text('기준기간(0%)', style: TextStyle(fontSize: 11)),
            const SizedBox(width: 18),
            Container(width: 16, height: 14, color: _barColor),
            const SizedBox(width: 5),
            const Text('농도변화', style: TextStyle(fontSize: 11)),
          ],
        ),
      ],
    );
  }
}
