import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:boilerplate/common/api.dart';
import 'rt_model.dart';

class ResultTableFactory {
  ResultTableFactory._();

  static final _largeFmt = NumberFormat('#,##0.0');

  // ─── Public factory methods ───────────────────────────────────────────────

  static ResultTableSet fromPastExposure({
    required Map<String, dynamic> request,
    required ExposureApiResponse data,
  }) {
    final mode = request['mode']?.toString() ?? '';
    final yearRaw = (request['year_'] ?? request['year']);
    final monthRaw = (request['month_'] ?? request['month']);
    final yearStr = yearRaw?.toString() ?? '전체';
    final monthStr = monthRaw?.toString() ?? '전체';
    final unitLabel = _unitLabel(mode);

    final isAllYear = yearStr == '전체';
    final isAllMonth = monthStr == '전체';

    if (isAllYear && isAllMonth) {
      return ResultTableSet.single(_pastCase11(data, unitLabel));
    } else if (!isAllYear && isAllMonth) {
      return ResultTableSet.single(_pastCase12(data, yearStr, unitLabel));
    } else if (isAllYear && !isAllMonth) {
      return ResultTableSet.single(_pastCase13(data, monthStr, unitLabel));
    } else {
      return ResultTableSet.single(_pastCase14(data, yearStr, monthStr, unitLabel));
    }
  }

  static ResultTableSet fromFutureScenario({
    required Map<String, dynamic> request,
    required FutureExposureResponse data,
  }) {
    final mode = request['mode']?.toString() ?? '';
    if (mode == 'PM2.5' || mode == 'O3') {
      return _scenarioAP(request: request, data: data, mode: mode);
    } else {
      return _scenarioTemp(request: request, data: data, mode: mode);
    }
  }

  static ResultTableSet fromFutureProjection({
    required Map<String, dynamic> request,
    required FutureProjectionResponse data,
  }) {
    final mode = request['mode']?.toString() ?? '';
    if (mode == 'PM2.5') {
      return _projectionPM25(data: data);
    } else {
      return _projectionTempOrInfectious(request: request, data: data);
    }
  }

  // ─── Past Exposure sub-cases ──────────────────────────────────────────────

  // 전체 연도 / 전체 월 → rows=월, cols=연도
  static ResultTableModel _pastCase11(ExposureApiResponse data, String unitLabel) {
    final Map<int, Map<int, double?>> monthly = {};
    for (final e in data.monthly) {
      final (y, m) = _parseYearMonth(e.period);
      if (y != null && m != null) {
        monthly[y] ??= {};
        monthly[y]![m] = e.value;
      }
    }
    final Map<int, double?> yearly = {};
    String yearlyLabel = '연평균';
    for (final e in data.yearly) {
      final y = _parseYear(e.period);
      if (y != null) {
        yearly[y] = e.value;
        yearlyLabel = _parseYearlyLabel(e.period);
      }
    }

    final sortedYears = monthly.keys.toList()..sort();
    final months = <int>{};
    for (final m in monthly.values) months.addAll(m.keys);
    final sortedMonths = months.toList()..sort();

    final headers = <RtCell>[
      const RtCell('', bold: true),
      ...sortedYears.map((y) => RtCell('$y년', bold: true)),
    ];

    final rows = <List<RtCell>>[
      ...sortedMonths.map((m) => <RtCell>[
            RtCell('$m월', bold: true),
            ...sortedYears.map((y) => RtCell(_fmt(monthly[y]?[m]))),
          ]),
      <RtCell>[
        RtCell(yearlyLabel, bold: true),
        ...sortedYears.map((y) => RtCell(_fmt(yearly[y]))),
      ],
    ];

    return ResultTableModel(headers: headers, rows: rows);
  }

  // 특정 연도 / 전체 월 → 1행: 월별값 + 연평균
  static ResultTableModel _pastCase12(
      ExposureApiResponse data, String yearStr, String unitLabel) {
    final months = data.monthly;
    final monthLabels = months.map((e) {
      final (_, m) = _parseYearMonth(e.period);
      return m != null ? '$m월' : e.period;
    }).toList();
    final yearly = data.yearly.isNotEmpty ? data.yearly.first : null;
    final yearlyLabel = yearly != null ? _parseYearlyLabel(yearly.period) : '연평균';

    final headers = <RtCell>[
      RtCell('$yearStr년', bold: true),
      ...monthLabels.map((l) => RtCell(l, bold: true)),
      RtCell(yearlyLabel, bold: true),
    ];
    final row = <RtCell>[
      RtCell(unitLabel, bold: true),
      ...months.map((e) => RtCell(_fmt(e.value))),
      RtCell(_fmt(yearly?.value)),
    ];
    return ResultTableModel(headers: headers, rows: [row]);
  }

  // 전체 연도 / 특정 월 → 1행: 연도별 해당 월 값
  static ResultTableModel _pastCase13(
      ExposureApiResponse data, String monthStr, String unitLabel) {
    final items = data.monthly;
    final yearLabels = items.map((e) {
      final y = _parseYear(e.period);
      return y != null ? '$y년' : e.period;
    }).toList();

    final headers = <RtCell>[
      const RtCell('', bold: true),
      ...yearLabels.map((l) => RtCell(l, bold: true)),
    ];
    final row = <RtCell>[
      RtCell(unitLabel, bold: true),
      ...items.map((e) => RtCell(_fmt(e.value))),
    ];
    return ResultTableModel(headers: headers, rows: [row]);
  }

  // 특정 연도 / 특정 월 → 단일 값
  static ResultTableModel _pastCase14(
      ExposureApiResponse data, String yearStr, String monthStr, String unitLabel) {
    final value = data.monthly.isNotEmpty ? data.monthly.first.value : null;
    final headers = <RtCell>[
      const RtCell('', bold: true),
      RtCell('$yearStr년 $monthStr월', bold: true),
    ];
    final row = <RtCell>[
      RtCell(unitLabel, bold: true),
      RtCell(_fmt(value)),
    ];
    return ResultTableModel(headers: headers, rows: [row]);
  }

  // ─── Future Scenario: Temperature ────────────────────────────────────────

  static ResultTableSet _scenarioTemp({
    required Map<String, dynamic> request,
    required FutureExposureResponse data,
    required String mode,
  }) {
    if (data.periodSummary.isEmpty) return ResultTableSet([]);
    final selectedGcms = _parseSelectedGcms(request['gcm_'] ?? request['gcm']);

    // Pivot: period → gcm → {mean, sd}
    final Map<String, Map<String, Map<String, double?>>> pivot = {};
    final Map<String, int> periodOrder = {};
    final Map<String, int> gcmOrder = {};

    for (final p in data.periodSummary) {
      if (!periodOrder.containsKey(p.period)) {
        periodOrder[p.period] = periodOrder.length;
      }
      if (!gcmOrder.containsKey(p.gcm)) {
        gcmOrder[p.gcm] = gcmOrder.length;
      }
      pivot[p.gcm] ??= {};
      pivot[p.gcm]![p.period] = {'mean': p.meanVal, 'sd': p.sdVal};
    }

    final sortedPeriods = periodOrder.keys.toList()
      ..sort((a, b) {
        if (a.contains('Baseline')) return -1;
        if (b.contains('Baseline')) return 1;
        return a.compareTo(b);
      });
    final sortedGcms = gcmOrder.keys.toList()
      ..sort((a, b) => gcmOrder[a]!.compareTo(gcmOrder[b]!));

    // Group headers: blank + one group per period (span=2)
    final groupHeaders = <RtHeaderGroup>[
      const RtHeaderGroup('', 1),
      ...sortedPeriods.map((p) => RtHeaderGroup(_periodLabel(p), 2)),
    ];

    final headers = <RtCell>[
      const RtCell('GCM', bold: true),
      ...sortedPeriods.expand((_) => [
            const RtCell('평균', bold: true),
            const RtCell('표준편차', bold: true),
          ]),
    ];

    final rows = sortedGcms.map((gcm) {
      final isEnsemble = gcm == 'Ensemble';
      final isSelected = selectedGcms.contains(gcm);
      final color = isSelected ? const Color(0xFF1565C0) : null;
      final displayName = isEnsemble ? '앙상블' : gcm;
      return <RtCell>[
        RtCell(displayName, bold: isEnsemble, textColor: color),
        ...sortedPeriods.expand((p) {
          final d = pivot[gcm]?[p];
          return [
            RtCell(_fmt(d?['mean']), bold: isEnsemble, textColor: color),
            RtCell(_fmt(d?['sd']), bold: isEnsemble, textColor: color),
          ];
        }),
      ];
    }).toList();

    return ResultTableSet.single(
        ResultTableModel(groupHeaders: groupHeaders, headers: headers, rows: rows));
  }

  // ─── Future Scenario: AP (PM2.5 / O3) ───────────────────────────────────

  static ResultTableSet _scenarioAP({
    required Map<String, dynamic> request,
    required FutureExposureResponse data,
    required String mode,
  }) {
    final targetPeriod = (request['target_period'])?.toString() ?? '전체';
    final changeApRaw = request['change_ap_'] ?? request['change_ap'];
    final changeAp = (changeApRaw is num) ? changeApRaw.toInt() : 0;
    final isDefault = targetPeriod == '전체' && changeAp == 0;
    final unitLabel = _unitLabel(mode);

    // Baseline from selected_scenario
    final baseline = data.selectedScenario.firstWhere(
      (e) => e['period']?.toString().contains('Baseline') == true,
      orElse: () => {},
    );
    final baseVal = baseline['proj_val'];

    if (isDefault) {
      return _scenarioAPDefault(data, unitLabel, baseVal);
    } else {
      return _scenarioAPSelected(data, request, unitLabel, baseVal, changeAp);
    }
  }

  static ResultTableSet _scenarioAPDefault(
    FutureExposureResponse data,
    String unitLabel,
    dynamic baseVal,
  ) {
    // Table 1: Baseline value
    final table1 = ResultTableModel(
      headers: [
        const RtCell('', bold: true),
        RtCell(unitLabel, bold: true),
      ],
      rows: [
        [
          const RtCell('기준 기간(2015-2019)', bold: true),
          RtCell(_fmt(baseVal is num ? baseVal.toDouble() : null)),
        ]
      ],
    );

    // Table 2: increase/decrease matrix from full_summary using first period
    if (data.fullSummary.isEmpty) return ResultTableSet([table1]);

    final firstPeriod = data.fullSummary
        .firstWhere((e) => !(e['period']?.toString().contains('Baseline') == true),
            orElse: () => data.fullSummary.first)['period']
        ?.toString();

    final Map<int, Map<String, double?>> changePivot = {};
    for (final e in data.fullSummary) {
      if (e['period']?.toString() != firstPeriod) continue;
      final ca = (e['change_ap'] as num?)?.toInt() ?? 0;
      if (ca == 0) continue;
      final absVal = ca.abs();
      changePivot[absVal] ??= {};
      final proj = (e['proj_val'] as num?)?.toDouble();
      if (ca > 0) {
        changePivot[absVal]!['pos'] = proj;
      } else {
        changePivot[absVal]!['neg'] = proj;
      }
    }

    final sortedAbs = changePivot.keys.toList()..sort();
    final periodLabel = firstPeriod != null ? _periodLabel(firstPeriod) : '';

    final table2 = ResultTableModel(
      headers: [
        RtCell(periodLabel, bold: true),
        const RtCell('농도 증가', bold: true),
        const RtCell('농도 감소', bold: true),
      ],
      rows: sortedAbs.map((abs) {
        return <RtCell>[
          RtCell('$abs%', bold: true),
          RtCell(_fmt(changePivot[abs]?['pos'])),
          RtCell(_fmt(changePivot[abs]?['neg'])),
        ];
      }).toList(),
    );

    return ResultTableSet([table1, table2]);
  }

  static ResultTableSet _scenarioAPSelected(
    FutureExposureResponse data,
    Map<String, dynamic> request,
    String unitLabel,
    dynamic baseVal,
    int changeAp,
  ) {
    final selected = data.selectedScenario.firstWhere(
      (e) => !(e['period']?.toString().contains('Baseline') == true),
      orElse: () => {},
    );
    final changeLabel = _changeApLabel(changeAp);

    final table = ResultTableModel(
      headers: [
        const RtCell('', bold: true),
        RtCell(unitLabel, bold: true),
        RtCell(changeLabel, bold: true),
      ],
      rows: [
        [
          const RtCell('기준 기간(2015-2019)', bold: true),
          RtCell(_fmt(baseVal is num ? baseVal.toDouble() : null)),
          RtCell(_fmt(
              selected['proj_val'] is num
                  ? (selected['proj_val'] as num).toDouble()
                  : null)),
        ]
      ],
    );

    return ResultTableSet.single(table);
  }

  // ─── Future Projection: Temp / Infectious ────────────────────────────────

  static ResultTableSet _projectionTempOrInfectious({
    required Map<String, dynamic> request,
    required FutureProjectionResponse data,
  }) {
    if (data.summaryData.isEmpty) return ResultTableSet([]);
    final selectedGcms = _parseSelectedGcms(request['gcm_'] ?? request['gcm']);

    final Map<String, Map<String, double?>> pivot = {};
    final Map<String, int> periodOrder = {};
    final Map<String, int> gcmOrder = {};

    for (final p in data.summaryData) {
      final gcm = p.gcm ?? 'Ensemble';
      if (!periodOrder.containsKey(p.period)) {
        periodOrder[p.period] = periodOrder.length;
      }
      if (!gcmOrder.containsKey(gcm)) gcmOrder[gcm] = gcmOrder.length;
      pivot[gcm] ??= {};
      pivot[gcm]![p.period] = p.anSum;
    }

    final sortedPeriods = periodOrder.keys.toList()..sort();
    final sortedGcms = gcmOrder.keys.toList()
      ..sort((a, b) => gcmOrder[a]!.compareTo(gcmOrder[b]!));

    final headers = <RtCell>[
      const RtCell('GCM', bold: true),
      ...sortedPeriods.map((p) => RtCell(_periodLabel(p), bold: true)),
    ];

    final rows = sortedGcms.map((gcm) {
      final isEnsemble = gcm == 'Ensemble';
      final isSelected = selectedGcms.contains(gcm);
      final color = isSelected ? const Color(0xFF1565C0) : null;
      final displayName = isEnsemble ? '앙상블' : gcm;
      return <RtCell>[
        RtCell(displayName, bold: isEnsemble, textColor: color),
        ...sortedPeriods.map((p) => RtCell(
              _fmtLarge(pivot[gcm]?[p]),
              bold: isEnsemble,
              textColor: color,
            )),
      ];
    }).toList();

    return ResultTableSet.single(ResultTableModel(headers: headers, rows: rows));
  }

  // ─── Future Projection: PM2.5 ────────────────────────────────────────────

  static ResultTableSet _projectionPM25({required FutureProjectionResponse data}) {
    if (data.summaryData.isEmpty) return ResultTableSet([]);

    final headers = <RtCell>[
      const RtCell('기간', bold: true),
      const RtCell('정책', bold: true),
      const RtCell('농도 변화율', bold: true),
      const RtCell('초과 사망자 수', bold: true),
    ];

    final rows = data.summaryData.map((p) {
      return <RtCell>[
        RtCell(_periodLabel(p.period), bold: true),
        RtCell(_policyLabel(p.policy)),
        RtCell(_changeApLabel(p.changeAp)),
        RtCell(_fmtLarge(p.anSum)),
      ];
    }).toList();

    return ResultTableSet.single(ResultTableModel(headers: headers, rows: rows));
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  static String _fmt(double? v) => v == null ? '-' : v.toStringAsFixed(1);

  static String _fmtLarge(double? v) => v == null ? '-' : _largeFmt.format(v);

  static String _unitLabel(String mode) {
    switch (mode) {
      case '연중 온도':
      case '여름철 온도':
        return '평균 온도(℃)';
      case 'PM2.5':
        return '평균 농도(㎍/㎥)';
      case 'O3':
        return '평균 농도(ppb)';
      default:
        return '평균값';
    }
  }

  static String _periodLabel(String period) {
    if (period.contains('Baseline')) return '기준 기간';
    if (period.contains('2031-2040')) return '근미래(2031-2040)';
    if (period.contains('2041-2060')) return '중미래(2041-2060)';
    if (period.contains('2081-2100')) return '먼미래(2081-2100)';
    return period;
  }

  static String _changeApLabel(int? v) {
    if (v == null) return '-';
    if (v == 0) return '변화 없음';
    if (v < 0) return '${v.abs()}% 감소';
    return '$v% 증가';
  }

  static String _policyLabel(String? policy) {
    switch (policy) {
      case 'none':
      case null:
        return '정책 없음';
      case 'reduction':
        return '저감 정책';
      case 'greenness':
        return '녹지';
      case 'shelter':
        return '그늘막쉼터';
      default:
        return policy;
    }
  }

  static (int?, int?) _parseYearMonth(String period) {
    final y = RegExp(r'(\d{4})년').firstMatch(period);
    final m = RegExp(r'(\d{1,2})월').firstMatch(period);
    return (
      y != null ? int.tryParse(y.group(1)!) : null,
      m != null ? int.tryParse(m.group(1)!) : null,
    );
  }

  static int? _parseYear(String period) {
    final m = RegExp(r'(\d{4})년').firstMatch(period);
    return m != null ? int.tryParse(m.group(1)!) : null;
  }

  static String _parseYearlyLabel(String period) {
    final m = RegExp(r'\d{4}년\s*(.+)').firstMatch(period);
    return m?.group(1)?.trim() ?? '연평균';
  }

  // Returns non-Ensemble GCMs that were explicitly requested (get blue text)
  static List<String> _parseSelectedGcms(dynamic raw) {
    if (raw == null || (raw is Map && raw.isEmpty)) return [];
    if (raw is String) return raw == 'Ensemble' ? [] : [raw];
    if (raw is List) {
      return raw.cast<String>().where((g) => g != 'Ensemble').toList();
    }
    return [];
  }
}
