import 'package:boilerplate/common/api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TimeSeries extends StatelessWidget {
  final List<TimeSeriesEntry> timeseriesData;
  final String yTitle;
  final String xTitle;

  const TimeSeries({
    super.key,
    required this.timeseriesData,
    this.yTitle = '평균온도(℃)',
    this.xTitle = '날짜',
  });

  @override
  Widget build(BuildContext context) {
    final periods = timeseriesData.map((e) => e.period).toList();

    final values = timeseriesData.map((e) => (e.value)).toList();

    final spots = List.generate(
      values.length,
      (i) => FlSpot(i.toDouble(), values[i]),
    );

    final dataMin = values.reduce((a, b) => a < b ? a : b);
    final dataMax = values.reduce((a, b) => a > b ? a : b);

    final range = (dataMax - dataMin).abs();

    final padding = range == 0 ? dataMax.abs() * 0.2 : range * 0.2;

    final minY = (dataMin - padding).floorToDouble();
    final maxY = (dataMax + padding).ceilToDouble();

    final labelInterval =
        periods.length <= 12 ? 1 : (periods.length / 8).ceil();

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
            horizontalInterval: 5,
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
              axisNameWidget: Text(
                yTitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              sideTitles: const SideTitles(
                showTitles: true,
                reservedSize: 45,
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameSize: 40,
              axisNameWidget: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  xTitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index < 0 || index >= periods.length) {
                    return const SizedBox.shrink();
                  }

                  final showLabel = index == 0 ||
                      index == periods.length - 1 ||
                      index % labelInterval == 0;

                  if (!showLabel) {
                    return const SizedBox.shrink();
                  }

                  // 2019-08-01 -> 08-01 로 줄이기
                  final label = periods[index].length >= 10
                      ? periods[index].substring(5)
                      : periods[index];

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 10,
                    angle: -0.65,
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                      ),
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
                    '${periods[index]}\n${spot.y.toStringAsFixed(2)}',
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
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
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
