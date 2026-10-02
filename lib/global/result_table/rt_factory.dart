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
      return ResultTableSet.single(_pastCase11(data, unitLabel, mode));
    } else if (!isAllYear && isAllMonth) {
      return ResultTableSet.single(_pastCase12(data, yearStr, unitLabel, mode));
    } else if (isAllYear && !isAllMonth) {
      return ResultTableSet.single(
          _pastCase13(data, monthStr, unitLabel, mode));
    } else {
      return ResultTableSet.single(
          _pastCase14(data, yearStr, monthStr, unitLabel, mode));
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

  static ResultTableSet fromPastHealthRisk({
    required Map<String, dynamic> request,
    required PastHealthRiskResponse data,
  }) {
    final mode = request['mode']?.toString() ?? '';
    final isDeath = mode == '여름철 온도' || mode == 'PM2.5' || mode == 'O3';
    final anLabel = isDeath ? '초과사망자수 (명)' : '초과발생건수 (건)';

    final headers = <RtCell>[
      const RtCell('시군구', bold: true),
      RtCell(anLabel, bold: true),
    ];

    final rows = data.riskData
        .map((r) => <RtCell>[
              RtCell(r.sggName),
              RtCell(r.anVal.toStringAsFixed(2)),
            ])
        .toList();

    if (rows.isEmpty) return ResultTableSet([]);

    return ResultTableSet.single(
        ResultTableModel(headers: headers, rows: rows));
  }

  // 특정 시군구 선택 시 요약표 (평균 노출값 + AN).
  // API는 시군구 필터 없이 시도 전체 exposure/risk data를 반환하므로(하이라이트용),
  // 선택된 시군구 1건만 골라 보여준다. AF/95%CI는 API 미제공(AN 결정으로 대체).
  static ResultTableSet fromHealthEffectsDetail({
    required Map<String, dynamic> request,
    required PastHealthRiskResponse data,
    required String unitLabel,
  }) {
    final sgg = request['sgg_']?.toString() ?? '전체';
    if (sgg == '전체' || sgg.isEmpty) return ResultTableSet([]);

    final mode = request['mode']?.toString() ?? '';
    final isDeath = mode == '여름철 온도' || mode == 'PM2.5' || mode == 'O3';
    final anLabel = isDeath ? '초과사망자수 (명)' : '초과발생건수 (건)';

    final exp =
        data.exposureData.where((e) => e.sggName.endsWith(sgg)).firstOrNull;
    final risk =
        data.riskData.where((r) => r.sggName.endsWith(sgg)).firstOrNull;
    if (exp == null && risk == null) return ResultTableSet([]);

    final headers = <RtCell>[
      const RtCell('시군구', bold: true),
      RtCell('평균 노출값($unitLabel)', bold: true),
      RtCell(anLabel, bold: true),
    ];

    final rows = <List<RtCell>>[
      [
        RtCell(risk?.sggName ?? exp?.sggName ?? sgg),
        RtCell(exp != null ? exp.expVal.toStringAsFixed(2) : '-'),
        RtCell(risk != null ? risk.anVal.toStringAsFixed(2) : '-'),
      ],
    ];

    return ResultTableSet.single(
        ResultTableModel(headers: headers, rows: rows));
  }

  static ResultTableSet fromFutureProjection({
    required Map<String, dynamic> request,
    required FutureProjectionResponse data,
  }) {
    final mode = request['mode']?.toString() ?? '';
    if (mode == 'PM2.5' || mode == 'O3') {
      return _projectionAP(request: request, data: data);
    } else {
      return _projectionTempOrInfectious(request: request, data: data);
    }
  }

  // ─── Past Exposure sub-cases ──────────────────────────────────────────────

  // 전체 연도 / 전체 월 → rows=월, cols=연도
  static ResultTableModel _pastCase11(
      ExposureApiResponse data, String unitLabel, String mode) {
    final Map<int, Map<int, double?>> monthly = {};
    for (final e in data.monthly) {
      final (y, m) = _parseYearMonth(e.period);
      if (y != null && m != null) {
        monthly.putIfAbsent(y, () => {});
        monthly[y]![m] = e.value;
      }
    }
    final Map<int, double?> yearly = {};
    //String yearlyLabel = '연평균';
    for (final e in data.yearly) {
      final y = _parseYear(e.period);
      if (y != null) {
        yearly[y] = e.value;
      }
    }

    final sortedYears = monthly.keys.toList()..sort();
    final months = <int>{};
    for (final m in monthly.values) {
      months.addAll(m.keys);
    }

    final sortedMonths = months.toList()..sort();

    final headers = <RtCell>[
      const RtCell('', bold: true),
      ...sortedYears.map((y) => RtCell('$y년', bold: true)),
    ];

    final rows = <List<RtCell>>[
      ...sortedMonths.map((m) {
        return <RtCell>[
          RtCell('$m월', bold: true),
          ...sortedYears.map((y) => RtCell(_fmtByMode(monthly[y]?[m], mode))),
        ];
      }),
      <RtCell>[
        RtCell(unitLabel, bold: true),
        ...sortedYears
            .map((y) => RtCell(_fmtByMode(yearly[y], mode), bold: true)),
      ],
    ];

    return ResultTableModel(headers: headers, rows: rows);
  }

  // 특정 연도 / 전체 월 → 1행: 월별값 + 연평균
  static ResultTableModel _pastCase12(
    ExposureApiResponse data,
    String yearStr,
    String unitLabel,
    String mode,
  ) {
    final selectedYear = int.tryParse(yearStr);

    final selectedMonthly = data.monthly.where((e) {
      final (y, _) = _parseYearMonth(e.period);
      return selectedYear == null || y == selectedYear;
    }).toList()
      ..sort((a, b) {
        final (_, ma) = _parseYearMonth(a.period);
        final (_, mb) = _parseYearMonth(b.period);
        return (ma ?? 0).compareTo(mb ?? 0);
      });

    final selectedYearly = data.yearly.where((e) {
      final y = _parseYear(e.period);
      return selectedYear == null || y == selectedYear;
    }).toList();

    final yearly = selectedYearly.isNotEmpty ? selectedYearly.first : null;

    final monthLabels = selectedMonthly.map((e) {
      final (_, m) = _parseYearMonth(e.period);
      return m != null ? '$m월' : e.period;
    }).toList();

    final avgLabel = _periodAverageLabel(
      selectedMonthly
          .map((e) => _parseYearMonth(e.period).$2)
          .whereType<int>()
          .toList(),
    );

    final headers = <RtCell>[
      RtCell('${selectedYear ?? yearStr}년', bold: true),
      ...monthLabels.map((l) => RtCell(l, bold: true)),
      RtCell(avgLabel, bold: true),
    ];

    final row = <RtCell>[
      RtCell(unitLabel, bold: true),
      ...selectedMonthly.map((e) => RtCell(_fmtByMode(e.value, mode))),
      RtCell(_fmtByMode(yearly?.value, mode)),
    ];

    return ResultTableModel(headers: headers, rows: [row]);
  }

  // 전체 연도 / 특정 월 → 1행: 연도별 해당 월 값
  static ResultTableModel _pastCase13(
    ExposureApiResponse data,
    String monthStr,
    String unitLabel,
    String mode,
  ) {
    final selectedMonth = int.tryParse(monthStr);

    final selectedMonthly = data.monthly.where((e) {
      final (_, m) = _parseYearMonth(e.period);
      return selectedMonth == null || m == selectedMonth;
    }).toList()
      ..sort((a, b) {
        final ya = _parseYear(a.period) ?? 0;
        final yb = _parseYear(b.period) ?? 0;
        return ya.compareTo(yb);
      });

    final headers = <RtCell>[
      const RtCell('', bold: true),
      ...selectedMonthly.map((e) {
        final y = _parseYear(e.period);
        return RtCell(y != null ? '$y년' : e.period, bold: true);
      }),
    ];

    final row = <RtCell>[
      RtCell(unitLabel, bold: true),
      ...selectedMonthly.map((e) => RtCell(_fmtByMode(e.value, mode))),
    ];

    return ResultTableModel(headers: headers, rows: [row]);
  }

  // 특정 연도 / 특정 월 → 단일 값
  static ResultTableModel _pastCase14(
    ExposureApiResponse data,
    String yearStr,
    String monthStr,
    String unitLabel,
    String mode,
  ) {
    final selectedYear = int.tryParse(yearStr);
    final selectedMonth = int.tryParse(monthStr);

    final item = data.monthly.where((e) {
      final (y, m) = _parseYearMonth(e.period);
      return (selectedYear == null || y == selectedYear) &&
          (selectedMonth == null || m == selectedMonth);
    }).firstOrNull;
    final value = item?.value;

    final headers = <RtCell>[
      const RtCell('', bold: true),
      RtCell('${selectedYear ?? yearStr}년-${selectedMonth ?? monthStr}월',
          bold: true),
    ];

    final row = <RtCell>[
      RtCell(unitLabel, bold: true),
      RtCell(_fmtByMode(value, mode)),
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

    final targetPeriod = request['target_period']?.toString() ?? '전체';

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

    // 기준 기간(Baseline) 열은 표에서 제외, 특정 기간을 선택한 경우 해당 기간만 표시
    final sortedPeriods = periodOrder.keys
        .where((p) => !p.contains('Baseline'))
        .where((p) => targetPeriod == '전체' || p.contains(targetPeriod))
        .toList()
      ..sort((a, b) => a.compareTo(b));

    // 관측치(Historical) 행은 표에서 제외, 앙상블은 항상 마지막 행
    final sortedGcms =
        gcmOrder.keys.where((g) => g != '관측치(Historical)').toList()
          ..sort((a, b) {
            if (a == 'Ensemble') return 1;
            if (b == 'Ensemble') return -1;
            return gcmOrder[a]!.compareTo(gcmOrder[b]!);
          });

    // Group headers: blank + one group per period (span=2)
    final groupHeaders = <RtHeaderGroup>[
      const RtHeaderGroup('', 1),
      ...sortedPeriods.map((p) => RtHeaderGroup(_periodLabelLine(p), 2)),
    ];

    final headers = <RtCell>[
      const RtCell('기후모형', bold: true),
      ...sortedPeriods.expand((_) => [
            const RtCell('평균', bold: true),
            const RtCell('표준편차', bold: true),
          ]),
    ];

    final rows = sortedGcms.map((gcm) {
      final isEnsemble = gcm == 'Ensemble';
      final displayName = isEnsemble ? '앙상블' : gcm;
      return <RtCell>[
        RtCell(displayName, bold: isEnsemble),
        ...sortedPeriods.expand((p) {
          final d = pivot[gcm]?[p];
          return [
            RtCell(_fmt(d?['mean']), bold: isEnsemble),
            RtCell(_fmt(d?['sd']), bold: isEnsemble),
          ];
        }),
      ];
    }).toList();

    return ResultTableSet.single(ResultTableModel(
        groupHeaders: groupHeaders, headers: headers, rows: rows));
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
      return _scenarioAPDefault(data, unitLabel, baseVal, mode);
    } else if (targetPeriod == '전체') {
      // 기간 전체 & 농도변화만 선택 → 기준기간 + 근/중/먼미래 4행
      return _scenarioAPAllPeriods(data, unitLabel, baseVal, mode);
    } else {
      return _scenarioAPSelected(
          data, request, unitLabel, baseVal, changeAp, mode);
    }
  }

  static ResultTableSet _scenarioAPAllPeriods(
    FutureExposureResponse data,
    String unitLabel,
    dynamic baseVal,
    String mode,
  ) {
    // 근/중/먼미래 3개 구간만 표시 (2061-2080 등 정의되지 않은 구간 제외)
    final periodEntries = data.selectedScenario
        .where((e) => _isForecastPeriod(e['period']?.toString() ?? ''))
        .toList()
      ..sort((a, b) => (a['period']?.toString() ?? '')
          .compareTo(b['period']?.toString() ?? ''));

    final rows = <List<RtCell>>[
      [
        const RtCell('기준 기간(2015-2019)', bold: true),
        RtCell(_fmtByMode(baseVal is num ? baseVal.toDouble() : null, mode)),
      ],
      ...periodEntries.map((e) {
        final proj = (e['proj_val'] as num?)?.toDouble();
        return <RtCell>[
          RtCell(_periodLabelLine(e['period']?.toString() ?? ''), bold: true),
          RtCell(_fmtByMode(proj, mode)),
        ];
      }),
    ];

    final table = ResultTableModel(
      headers: [
        const RtCell('', bold: true),
        RtCell(unitLabel, bold: true),
      ],
      rows: rows,
    );

    return ResultTableSet.single(table);
  }

  static ResultTableSet _scenarioAPDefault(
    FutureExposureResponse data,
    String unitLabel,
    dynamic baseVal,
    String mode,
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
          RtCell(_fmtByMode(baseVal is num ? baseVal.toDouble() : null, mode)),
        ]
      ],
    );

    // Table 2: 농도변화율(-30~30%, 5% 단위) x 근/중/먼미래 매트릭스
    if (data.fullSummary.isEmpty) return ResultTableSet([table1]);

    final forecastEntries = data.fullSummary
        .where((e) => _isForecastPeriod(e['period']?.toString() ?? ''))
        .toList();

    final sortedPeriods = forecastEntries
        .map((e) => e['period']!.toString())
        .toSet()
        .toList()
      ..sort();

    final Map<int, Map<String, double?>> changePivot = {};
    for (final e in forecastEntries) {
      final period = e['period']!.toString();
      final ca = (e['change_ap'] as num?)?.toInt() ?? 0;
      final proj = (e['proj_val'] as num?)?.toDouble();
      changePivot[ca] ??= {};
      changePivot[ca]![period] = proj;
    }

    final sortedChangeAps = changePivot.keys.toList()..sort();

    final table2 = ResultTableModel(
      headers: [
        const RtCell('농도변화율', bold: true),
        ...sortedPeriods.map((p) => RtCell(_periodLabelShort(p), bold: true)),
      ],
      rows: sortedChangeAps.map((ca) {
        final sign = ca > 0 ? '+' : '';
        final isBaseline = ca == 0;
        return <RtCell>[
          RtCell('$sign$ca%', bold: true),
          ...sortedPeriods.map((p) =>
              RtCell(_fmtByMode(changePivot[ca]?[p], mode), bold: isBaseline)),
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
    String mode,
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
          RtCell(_fmtByMode(baseVal is num ? baseVal.toDouble() : null, mode)),
          RtCell(_fmtByMode(
              selected['proj_val'] is num
                  ? (selected['proj_val'] as num).toDouble()
                  : null,
              mode)),
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
    // 앙상블은 항상 마지막 행
    final sortedGcms = gcmOrder.keys.toList()
      ..sort((a, b) {
        if (a == 'Ensemble') return 1;
        if (b == 'Ensemble') return -1;
        return gcmOrder[a]!.compareTo(gcmOrder[b]!);
      });

    final headers = <RtCell>[
      const RtCell('기후모형', bold: true),
      ...sortedPeriods.map((p) => RtCell(_periodLabel(p), bold: true)),
    ];

    final rows = sortedGcms.map((gcm) {
      final isEnsemble = gcm == 'Ensemble';
      final displayName = isEnsemble ? '앙상블' : gcm;
      return <RtCell>[
        RtCell(displayName, bold: isEnsemble),
        ...sortedPeriods.map((p) => RtCell(
              _fmtLarge(pivot[gcm]?[p]),
              bold: isEnsemble,
            )),
      ];
    }).toList();

    return ResultTableSet.single(
        ResultTableModel(headers: headers, rows: rows));
  }

  // ─── Future Projection: 대기오염(PM2.5 / O3) ─────────────────────────────
  // 여름철 온도 표와 동일한 형태: 기간이 열, 농도변화율이 행 (정책 열은 제외)

  static ResultTableSet _projectionAP({
    required Map<String, dynamic> request,
    required FutureProjectionResponse data,
  }) {
    if (data.summaryData.isEmpty) return ResultTableSet([]);

    final selectedChangeApRaw = request['change_ap_'] ?? request['change_ap'];
    final selectedChangeAp =
        (selectedChangeApRaw is num) ? selectedChangeApRaw.toInt() : 0;

    // Pivot: change_ap → period → an_sum
    final Map<int, Map<String, double?>> pivot = {};
    final Map<String, int> periodOrder = {};
    final Map<int, int> changeApOrder = {};

    for (final p in data.summaryData) {
      final ca = p.changeAp ?? 0;
      if (!periodOrder.containsKey(p.period)) {
        periodOrder[p.period] = periodOrder.length;
      }
      if (!changeApOrder.containsKey(ca)) {
        changeApOrder[ca] = changeApOrder.length;
      }
      pivot[ca] ??= {};
      pivot[ca]![p.period] = p.anSum;
    }

    final sortedPeriods = periodOrder.keys.toList()..sort();
    final sortedChangeAps = changeApOrder.keys.toList()..sort();

    final headers = <RtCell>[
      const RtCell('농도변화율', bold: true),
      ...sortedPeriods.map((p) => RtCell(_periodLabel(p), bold: true)),
    ];

    final rows = sortedChangeAps.map((ca) {
      final isSelected = ca == selectedChangeAp;
      return <RtCell>[
        RtCell(_changeApLabel(ca), bold: isSelected),
        ...sortedPeriods
            .map((p) => RtCell(_fmtLarge(pivot[ca]?[p]), bold: isSelected)),
      ];
    }).toList();

    return ResultTableSet.single(
        ResultTableModel(headers: headers, rows: rows));
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  static String _fmt(double? v) => v == null ? '-' : v.toStringAsFixed(1);

  // 오존(O3)은 소수점 두자리, 그 외 물질은 소수점 한자리로 통일
  static String _fmtByMode(double? v, String mode) =>
      v == null ? '-' : v.toStringAsFixed(mode == 'O3' ? 2 : 1);

  static String _fmtLarge(double? v) => v == null ? '-' : _largeFmt.format(v);

  static String _unitLabel(String mode) {
    switch (mode) {
      case '연중 온도':
      case '여름철 온도':
        return '평균 온도(℃)';
      case 'PM2.5':
        return '평균 농도(㎍/㎥)';
      case 'O3':
        return '평균 농도(ppm)';
      default:
        return 'AN';
    }
  }

  static String _periodAverageLabel(List<int> months) {
    if (months.isEmpty) return '평균';

    final sorted = months.toSet().toList()..sort();
    if (sorted.length == 1) {
      return '${sorted.first}월 평균';
    }

    return '평균';
  }

  static String _periodLabel(String period) {
    if (period.contains('2031-2040')) return '근미래\n2031-2040';
    if (period.contains('2041-2060')) return '중미래\n2041-2060';
    if (period.contains('2081-2100')) return '먼미래\n2081-2100';
    return period;
  }

  static String _periodLabelLine(String period) {
    if (period.contains('2031-2040')) return '근미래(2031-2040)';
    if (period.contains('2041-2060')) return '중미래(2041-2060)';
    if (period.contains('2081-2100')) return '먼미래(2081-2100)';
    return period;
  }

  static String _periodLabelShort(String period) {
    if (period.contains('2031-2040')) return '근미래';
    if (period.contains('2041-2060')) return '중미래';
    if (period.contains('2081-2100')) return '먼미래';
    return period;
  }

  // 근/중/먼미래로 정의된 3개 구간인지 여부 (2061-2080 등은 미정의 구간으로 제외)
  static bool _isForecastPeriod(String period) =>
      period.contains('2031-2040') ||
      period.contains('2041-2060') ||
      period.contains('2081-2100');

  static String _changeApLabel(int? v) {
    if (v == null) return '-';
    if (v == 0) return '변화 없음';
    if (v < 0) return '${v.abs()}% 감소';
    return '$v% 증가';
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
}
