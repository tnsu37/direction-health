import 'package:boilerplate/common/api.dart';
import 'package:boilerplate/common/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScenarioTempChart extends StatelessWidget {
  const ScenarioTempChart({
    super.key,
    required this.data,
    required this.mode,
    required this.chartTitle,
    required this.selectedGcms,
    this.targetPeriod = '전체',
  });

  final FutureExposureResponse data;
  final String mode;
  final String chartTitle;
  final List<String> selectedGcms;

  /// ApiMap.period() 결과값. '전체'가 아니면 해당 기간(예: '2031-2040')의 값만 표시.
  final String targetPeriod;

  // '2031-2040' → (2031, 2040), '전체' → null
  (int, int)? get _periodRange {
    final m = RegExp(r'(\d{4})-(\d{4})').firstMatch(targetPeriod);
    if (m == null) return null;
    return (int.parse(m.group(1)!), int.parse(m.group(2)!));
  }

  static const Map<String, Color> _gcmColors = {
    'Ensemble': Color(0xFF243B64),
    'WRF': Color(0xFFE07A3F),
    'CCLM': Color(0xFF4E9B69),
    'GRIMs': Color(0xFF9B6BC1),
    'HadGEM3-RA': Color(0xFF2F91B3),
    'RegCM': Color(0xFFD95763),
  };

  static const List<Color> _fallbackColors = [
    Color(0xFF2F91B3), // 블루
    Color(0xFFE07A3F), // 오렌지
    Color(0xFF4E9B69), // 그린
    Color(0xFF9B6BC1), // 퍼플
    Color(0xFFD95763), // 레드
    Color(0xFFB58A3D), // 골드
  ];

  @override
  Widget build(BuildContext context) {
    final range = _periodRange;
    final trend = range == null
        ? data.yearlyTrend
        : data.yearlyTrend
            .where((p) => p.year >= range.$1 && p.year <= range.$2)
            .toList();
    if (trend.isEmpty) return const SizedBox.shrink();

    // Group by GCM
    final Map<String, List<YearlyTrendPoint>> byGcm = {};
    for (final p in trend) {
      byGcm.putIfAbsent(p.gcm, () => []).add(p);
    }

    // Sorted unique years → x index
    final years = trend.map((p) => p.year).toSet().toList()..sort();
    final yearToX = {
      for (int i = 0; i < years.length; i++) years[i]: i.toDouble()
    };

    // Y range
    final allVals = trend.map((p) => p.meanVal).toList();
    final minY = allVals.reduce((a, b) => a < b ? a : b);
    final maxY = allVals.reduce((a, b) => a > b ? a : b);
    final yPad = (maxY - minY) * 0.18;
    final yMin = (minY - yPad).floorToDouble();
    final yMax = (maxY + yPad).ceilToDouble();

    const gcmOrder = [
      'WRF',
      'CCLM',
      'GRIMs',
      'HadGEM3-RA',
      'RegCM',
      'Ensemble',
    ];

    final gcmList = byGcm.keys.toList()
      ..sort((a, b) {
        final ai = gcmOrder.indexOf(a);
        final bi = gcmOrder.indexOf(b);

        if (ai == -1 && bi == -1) return a.compareTo(b);
        if (ai == -1) return -1;
        if (bi == -1) return 1;

        return ai.compareTo(bi);
      });

    // Line bars — 전체 기간(2060~2080년 포함)을 하나의 선으로 이어서 그린다.
    // 해당 구간은 회색 음영 + 경계 점선으로만 구분 표시한다.
    final List<LineChartBarData> bars = [];
    final List<String> barGcmNames = [];

    for (final entry in gcmList.asMap().entries) {
      final gcm = entry.value;
      final isEnsemble = gcm == 'Ensemble';

      final color = _gcmColors[gcm] ??
          _fallbackColors[entry.key % _fallbackColors.length];

      final points = byGcm[gcm]!.toList()
        ..sort((a, b) => a.year.compareTo(b.year));

      final spots =
          points.map((p) => FlSpot(yearToX[p.year]!, p.meanVal)).toList();

      if (spots.isEmpty) continue;

      bars.add(LineChartBarData(
        spots: spots,
        isCurved: false,
        color: color,
        barWidth: isEnsemble ? 2.5 : 1.5,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ));
      barGcmNames.add(gcm);
    }

    // 연도(정수) → x좌표. 데이터에 정확히 없는 연도는 인접한 두 연도 사이를 보간.
    double? _xForYear(int year) {
      if (yearToX.containsKey(year)) return yearToX[year];
      int? lower, upper;
      for (final y in years) {
        if (y <= year) lower = y;
        if (y >= year && upper == null) upper = y;
      }
      if (lower == null && upper == null) return null;
      if (lower == null) return yearToX[upper!];
      if (upper == null) return yearToX[lower];
      if (lower == upper) return yearToX[lower];
      final lx = yearToX[lower]!, ux = yearToX[upper]!;
      final t = (year - lower) / (upper - lower);
      return lx + (ux - lx) * t;
    }

    double? _xMid(int startYear, int endYear) {
      final x1 = _xForYear(startYear);
      final x2 = _xForYear(endYear);
      if (x1 == null || x2 == null) return null;
      return (x1 + x2) / 2;
    }

    // 기간 구분선 (라벨 없음)
    VerticalLine _periodDivider(int year) {
      final x = _xForYear(year);
      return VerticalLine(
        x: x ?? 0,
        color: Colors.grey.withOpacity(0.55),
        strokeWidth: 1,
        dashArray: [5, 4],
      );
    }

    // 기간 라벨 (해당 기간의 중간 지점에 표시, 선은 그리지 않음)
    VerticalLine _periodMidLabel(double? x, String label) {
      return VerticalLine(
        x: x ?? 0,
        color: Colors.transparent,
        strokeWidth: 0,
        label: VerticalLineLabel(
          show: x != null,
          labelResolver: (_) => label,
          alignment: Alignment.topCenter,
          style: const TextStyle(
              fontSize: 10, color: Colors.black54, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.only(bottom: 4),
        ),
      );
    }

    // 특정 기간을 선택한 상태에서는 해당 기간만 보여주므로
    // 근/중/먼미래 구분선·공백구간 음영은 표시하지 않는다.
    final showFullRangeOverlays = range == null;

    final verticalLines = !showFullRangeOverlays
        ? const <VerticalLine>[]
        : [
            _periodDivider(2031),
            _periodDivider(2041),
            // 모델링 공백 구간(2061~2080년) 경계선
            _periodDivider(2060),
            _periodDivider(2081),
            _periodMidLabel(_xMid(2031, 2040), '근미래'),
            _periodMidLabel(_xMid(2041, 2060), '중미래'),
            _periodMidLabel(_xMid(2081, 2100), '먼미래'),
          ];

    // 2060~2080년(모델링 공백 구간) 회색 처리
    final gapX1 = showFullRangeOverlays ? _xForYear(2060) : null;
    final gapX2 = showFullRangeOverlays ? _xForYear(2080) : null;

    final rangeAnnotations = (gapX1 != null && gapX2 != null)
        ? RangeAnnotations(
            verticalRangeAnnotations: [
              VerticalRangeAnnotation(
                x1: gapX1,
                x2: gapX2 + 1,
                color: Colors.grey.withOpacity(0.1),
              ),
            ],
          )
        : null;

    final unitLabel = mode == '여름철 온도' ? '평균 온도(℃)' : '연평균 온도(℃)';

    return Column(
      children: [
        if (chartTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(chartTitle, style: CommonStyle.textStyleFontBlack18600),
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
              rangeAnnotations: rangeAnnotations ?? const RangeAnnotations(),
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
                  sideTitles:
                      const SideTitles(showTitles: true, reservedSize: 45),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('연도',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  axisNameSize: 32,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= years.length)
                        return const SizedBox.shrink();
                      final year = years[idx];
                      // 특정 기간만 보일 때는 매년 표기, 전체 기간은 10년 단위로 표기.
                      if (showFullRangeOverlays && year % 10 != 0) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 6,
                        child:
                            Text('$year', style: const TextStyle(fontSize: 10)),
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
                    final gcm = barGcmNames[spot.barIndex];
                    final display = gcm == 'Ensemble' ? '앙상블' : gcm;
                    return LineTooltipItem(
                      '$display\n$year: ${spot.y.toStringAsFixed(1)}℃',
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
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 4,
          children: gcmList.asMap().entries.map((entry) {
            final gcm = entry.value;
            final isEnsemble = gcm == 'Ensemble';
            final color = _gcmColors[gcm] ??
                _fallbackColors[entry.key % _fallbackColors.length];
            final displayName = isEnsemble ? '앙상블' : gcm;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 22, height: isEnsemble ? 3 : 2, color: color),
                const SizedBox(width: 5),
                Text(displayName,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isEnsemble ? FontWeight.w700 : FontWeight.normal)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
