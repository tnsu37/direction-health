import 'package:boilerplate/common/api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScenarioTempChart extends StatelessWidget {
  const ScenarioTempChart({
    super.key,
    required this.data,
    required this.mode,
    required this.chartTitle,
    required this.selectedGcms,
  });

  final FutureExposureResponse data;
  final String mode;
  final String chartTitle;
  final List<String> selectedGcms;

  static const Map<String, Color> _gcmColors = {
    'Ensemble': Color(0xFF1A3A6B),
    'WRF': Color(0xFFE65100),
    'CCLM': Color(0xFF2E7D32),
    'GRIMs': Color(0xFF6A1B9A),
    'HadGEM3-RA': Color(0xFF00695C),
    'RegCM': Color(0xFFC62828),
  };

  static const List<Color> _fallbackColors = [
    Color(0xFF1565C0),
    Color(0xFFEF6C00),
    Color(0xFF2E7D32),
    Color(0xFF6A1B9A),
    Color(0xFF00695C),
    Color(0xFFC62828),
  ];

  @override
  Widget build(BuildContext context) {
    final trend = data.yearlyTrend;
    if (trend.isEmpty) return const SizedBox.shrink();

    // Group by GCM
    final Map<String, List<YearlyTrendPoint>> byGcm = {};
    for (final p in trend) {
      byGcm.putIfAbsent(p.gcm, () => []).add(p);
    }

    // Sorted unique years → x index
    final years = trend.map((p) => p.year).toSet().toList()..sort();
    final yearToX = {for (int i = 0; i < years.length; i++) years[i]: i.toDouble()};

    // Y range
    final allVals = trend.map((p) => p.meanVal).toList();
    final minY = allVals.reduce((a, b) => a < b ? a : b);
    final maxY = allVals.reduce((a, b) => a > b ? a : b);
    final yPad = (maxY - minY) * 0.18;
    final yMin = (minY - yPad).floorToDouble();
    final yMax = (maxY + yPad).ceilToDouble();

    final gcmList = byGcm.keys.toList();

    // Line bars
    final bars = gcmList.asMap().entries.map((entry) {
      final gcm = entry.value;
      final isEnsemble = gcm == 'Ensemble';
      final color = _gcmColors[gcm] ?? _fallbackColors[entry.key % _fallbackColors.length];
      final points = (byGcm[gcm]!.toList())..sort((a, b) => a.year.compareTo(b.year));
      final spots = points.map((p) => FlSpot(yearToX[p.year]!, p.meanVal)).toList();
      return LineChartBarData(
        spots: spots,
        isCurved: false,
        color: color,
        barWidth: isEnsemble ? 2.5 : 1.5,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      );
    }).toList();

    // Vertical period lines
    VerticalLine _periodLine(int year, String label) {
      final x = yearToX[year];
      return VerticalLine(
        x: x ?? 0,
        color: Colors.grey.withOpacity(0.55),
        strokeWidth: 1,
        dashArray: [5, 4],
        label: VerticalLineLabel(
          show: x != null,
          labelResolver: (_) => label,
          alignment: Alignment.topLeft,
          style: const TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.only(left: 4, bottom: 4),
        ),
      );
    }

    final verticalLines = [
      _periodLine(2031, '근미래'),
      _periodLine(2041, '중미래'),
      _periodLine(2081, '먼미래'),
    ];

    final unitLabel = mode == '여름철 온도' ? '평균 온도(℃)' : '연평균 온도(℃)';

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
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (years.length - 1).toDouble(),
              minY: yMin,
              maxY: yMax,
              extraLinesData: ExtraLinesData(verticalLines: verticalLines),
              clipData: const FlClipData.all(),
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
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(unitLabel,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  sideTitles: const SideTitles(showTitles: true, reservedSize: 45),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('연도', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  axisNameSize: 32,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= years.length) return const SizedBox.shrink();
                      final year = years[idx];
                      if (year % 10 != 0) return const SizedBox.shrink();
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 6,
                        child: Text('$year', style: const TextStyle(fontSize: 10)),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => spots.map((spot) {
                    final idx = spot.x.toInt();
                    final year = idx < years.length ? years[idx] : 0;
                    final gcm = gcmList[spot.barIndex];
                    final display = gcm == 'Ensemble' ? '앙상블' : gcm;
                    return LineTooltipItem(
                      '$display\n$year: ${spot.y.toStringAsFixed(2)}℃',
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
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: gcmList.asMap().entries.map((entry) {
            final gcm = entry.value;
            final isEnsemble = gcm == 'Ensemble';
            final color = _gcmColors[gcm] ?? _fallbackColors[entry.key % _fallbackColors.length];
            final displayName = isEnsemble ? '앙상블' : gcm;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 22, height: isEnsemble ? 3 : 2, color: color),
                const SizedBox(width: 5),
                Text(displayName,
                    style: TextStyle(fontSize: 11, fontWeight: isEnsemble ? FontWeight.w700 : FontWeight.normal)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
