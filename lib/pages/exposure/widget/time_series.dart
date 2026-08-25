import 'package:boilerplate/common/api.dart';
import 'package:boilerplate/common/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// x축 라벨 표기 방식 4종
// (1) daily: 연도&월 모두 선택 → 1,5,9,...,29일만 표기
// (2) allYears: 월만 선택(연도 전체) → 모든 연도 표기
// (3) allMonths: 연도만 선택(월 전체) → 모든 월 표기
// (4) yearlyDefault: 전체(디폴트) → 매년 대표 월(여름철 온도=9월, 그 외=12월)만 표기
enum _XAxisLabelMode { daily, allYears, allMonths, yearlyDefault }

class TimeSeries extends StatelessWidget {
  final List<TimeSeriesEntry> timeseriesData;
  final String yTitle;
  final String xTitle;
  final String mode;

  const TimeSeries({
    super.key,
    required this.timeseriesData,
    this.yTitle = '평균온도(℃)',
    this.xTitle = '날짜',
    this.mode = '',
  });

  int get _decimals => mode == 'O3' ? 2 : 1;

  _XAxisLabelMode _detectXAxisLabelMode() {
    if (timeseriesData.any((e) => e.period.length >= 10)) {
      return _XAxisLabelMode.daily;
    }
    final years = timeseriesData.map((e) => e.year).toSet();
    final months = timeseriesData.map((e) => e.month).toSet();
    if (years.length <= 1 && months.length > 1)
      return _XAxisLabelMode.allMonths;
    if (months.length <= 1 && years.length > 1) return _XAxisLabelMode.allYears;
    return _XAxisLabelMode.yearlyDefault;
  }

  bool _shouldLabel(_XAxisLabelMode xMode, TimeSeriesEntry e) {
    switch (xMode) {
      case _XAxisLabelMode.daily:
        if (e.period.length < 10) return false;
        final day = int.tryParse(e.period.substring(8, 10)) ?? 0;
        return day <= 29 && (day - 1) % 4 == 0;
      case _XAxisLabelMode.allYears:
      case _XAxisLabelMode.allMonths:
        return true;
      case _XAxisLabelMode.yearlyDefault:
        final targetMonth = mode == '여름철 온도'
            ? 9
            : mode == 'O3'
                ? 9
                : 12;
        return e.month == targetMonth;
    }
  }

  String _labelFor(_XAxisLabelMode xMode, TimeSeriesEntry e) {
    switch (xMode) {
      case _XAxisLabelMode.daily:
        return e.period.length >= 10 ? e.period.substring(5) : e.period;
      case _XAxisLabelMode.allYears:
        return '${e.year}년';
      case _XAxisLabelMode.allMonths:
        return '${e.month}월';
      case _XAxisLabelMode.yearlyDefault:
        return '${e.year}년';
    }
  }

  @override
  Widget build(BuildContext context) {
    final values = timeseriesData.map((e) => (e.value)).toList();

    final spots = List.generate(
      values.length,
      (i) => FlSpot(i.toDouble(), values[i]),
    );

    final dataMin = values.reduce((a, b) => a < b ? a : b);
    final dataMax = values.reduce((a, b) => a > b ? a : b);

    final range = (dataMax - dataMin).abs();

    late final double minY;
    late final double maxY;
    late final double yInterval;

    if (mode == 'O3') {
      final padding = range == 0 ? 0.01 : range * 0.2;

      // 0.01 단위로 내림/올림
      minY = ((dataMin - padding) * 100).floor() / 100.0;
      maxY = ((dataMax + padding) * 100).ceil() / 100.0;

      // 오존은 0.01 간격 권장
      yInterval = 0.01;
    } else {
      final padding = range == 0 ? dataMax.abs() * 0.2 : range * 0.2;

      minY = (dataMin - padding).floorToDouble();
      maxY = (dataMax + padding).ceilToDouble();

      yInterval = 5;
    }

    final xAxisLabelMode = _detectXAxisLabelMode();

    return SizedBox(
      height: 420,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (spots.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: yInterval,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.15),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.black54, width: 1),
              bottom: BorderSide(color: Colors.black54, width: 1),
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              axisNameSize: 30,
              axisNameWidget: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(yTitle, style: CommonStyle.textStyle13600),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(_decimals),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameSize: 40,
              axisNameWidget: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(xTitle, style: CommonStyle.textStyle13600),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index < 0 || index >= timeseriesData.length) {
                    return const SizedBox.shrink();
                  }

                  final entry = timeseriesData[index];

                  if (!_shouldLabel(xAxisLabelMode, entry)) {
                    return const SizedBox.shrink();
                  }

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 10,
                    angle: -0.65,
                    child: Text(
                      _labelFor(xAxisLabelMode, entry),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  final index = spot.x.toInt();
                  return LineTooltipItem(
                    '${timeseriesData[index].period}\n${spot.y.toStringAsFixed(_decimals)}',
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              barWidth: 2,
              color: const Color(0xff6f7f95),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 2,
                    color: Colors.white,
                    strokeWidth: 1,
                    strokeColor: const Color(0xff003c8f),
                  );
                },
              ),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          extraLinesData: const ExtraLinesData(),
        ),
      ),
    );
  }
}
