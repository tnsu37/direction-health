import 'package:boilerplate/common/api.dart';
import 'package:boilerplate/common/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 건강영향 미래추정 — AN(기여사망자/발생건수) 막대그래프.
/// 온도/감염병: 기간별 x축 그룹, 범례=선택한 기후모형(GCM).
/// PM2.5/O3(대기오염): 기간별 x축 그룹, 범례=농도변화율(0% 기준 + 선택 변화율).
class HealthProjectionAnChart extends StatelessWidget {
  const HealthProjectionAnChart({
    super.key,
    required this.data,
    required this.mode,
    required this.chartTitle,
  });

  final FutureProjectionResponse data;
  final String mode; // ApiMap.mode() 결과값
  final String chartTitle;

  bool get _isAP => mode == 'PM2.5' || mode == 'O3';

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

  static const Color _baselineColor = Color(0xFFD32F2F);
  static const Color _selectedApColor = Color(0xFF1A3A6B);

  String _seriesKey(SummaryPoint p) =>
      _isAP ? (p.changeAp ?? 0).toString() : (p.gcm ?? 'Ensemble');

  int _periodOrder(String period) {
    if (period.contains('2031-2040')) return 0;
    if (period.contains('2041-2060')) return 1;
    if (period.contains('2081-2100')) return 2;
    return 99;
  }

  String _periodLabel(String period) {
    if (period.contains('2031-2040')) return '근미래\n(2031-2040)';
    if (period.contains('2041-2060')) return '중미래\n(2041-2060)';
    if (period.contains('2081-2100')) return '먼미래\n(2081-2100)';
    return period;
  }

  Color _colorOf(String key) {
    if (_isAP) {
      return key == '0' ? _baselineColor : _selectedApColor;
    }
    final idx = _gcmColors.keys.toList().indexOf(key);
    return _gcmColors[key] ??
        _fallbackColors[idx < 0 ? 0 : idx % _fallbackColors.length];
  }

  String _labelOf(String key) {
    if (_isAP) {
      final v = int.tryParse(key) ?? 0;
      if (v == 0) return '변화없음(0%)';
      final sign = v > 0 ? '+' : '';
      return '$sign$v%';
    }
    return key == 'Ensemble' ? '앙상블' : key;
  }

  String get _unitLabel {
    final isDeath = mode == '여름철 온도' || mode == 'PM2.5' || mode == 'O3';
    return isDeath ? '초과사망자수(명)' : '초과발생건수(건)';
  }

  @override
  Widget build(BuildContext context) {
    if (data.summaryData.isEmpty) return const SizedBox.shrink();

    final periods = data.summaryData.map((p) => p.period).toSet().toList()
      ..sort((a, b) => _periodOrder(a).compareTo(_periodOrder(b)));

    final seriesKeys = <String>[];
    for (final p in data.summaryData) {
      final k = _seriesKey(p);
      if (!seriesKeys.contains(k)) seriesKeys.add(k);
    }
    if (_isAP) {
      // 기준(0%)은 항상 왼쪽, 선택한 농도변화율은 부호와 관계없이 항상 오른쪽에 오도록 정렬.
      seriesKeys.sort((a, b) {
        final av = int.tryParse(a) ?? 0;
        final bv = int.tryParse(b) ?? 0;
        if (av == 0 && bv == 0) return 0;
        if (av == 0) return -1;
        if (bv == 0) return 1;
        return av.compareTo(bv);
      });
    }

    final Map<String, Map<String, double>> pivot = {};
    for (final p in data.summaryData) {
      pivot.putIfAbsent(p.period, () => {})[_seriesKey(p)] = p.anSum;
    }

    final allVals = data.summaryData.map((p) => p.anSum).toList();
    final maxVal =
        allVals.isEmpty ? 1.0 : allVals.reduce((a, b) => a > b ? a : b);
    final maxY = maxVal <= 0 ? 1.0 : maxVal * 1.22;

    final barWidth = seriesKeys.length > 3 ? 12.0 : 18.0;

    final barGroups = periods.asMap().entries.map((entry) {
      final i = entry.key;
      final period = entry.value;
      final rods = seriesKeys.map((key) {
        final v = pivot[period]?[key] ?? 0;
        return BarChartRodData(
          toY: v,
          color: _colorOf(key),
          width: barWidth,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
        );
      }).toList();
      return BarChartGroupData(x: i, barRods: rods, barsSpace: 4);
    }).toList();

    return Column(
      children: [
        if (chartTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(chartTitle, style: CommonStyle.textStyleFontBlack18600),
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
                    final key = seriesKeys[rodIndex];
                    return BarTooltipItem(
                      '${_labelOf(key)}\n${rod.toY.toStringAsFixed(1)}',
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
                  axisNameSize: 30,
                  axisNameWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(_unitLabel,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 52,
                    getTitlesWidget: (value, meta) {
                      if (value == meta.min || value == meta.max) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        meta.formattedValue,
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black87),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('기간',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  axisNameSize: 32,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= periods.length)
                        return const SizedBox.shrink();
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 6,
                        child: Text(
                          _periodLabel(periods[i]),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black87),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 4,
          children: seriesKeys.map((key) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 16, height: 14, color: _colorOf(key)),
                const SizedBox(width: 5),
                Text(_labelOf(key), style: const TextStyle(fontSize: 11)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
