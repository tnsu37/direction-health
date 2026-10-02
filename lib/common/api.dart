import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ════════════════════════════════════════════════════════════════════
//  ApiService — API_SPEC.md 계약 기준 (4개 분석 API + 공통 envelope)
//  모든 엔드포인트: POST / JSON / 파라미터명은 엑셀 그대로(끝의 `_` 포함)
// ════════════════════════════════════════════════════════════════════

class ApiService {
  /// ⚠️ 백엔드 배포 주소로 교체하세요.
  /// 빌드 시 `--dart-define=API_BASE_URL=https://...` 로도 주입 가능합니다.
  /// (기존 코드 값: https://team-motive.com)
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.direction-health.kr',
  );

  static const Duration _timeout = Duration(seconds: 120);

  // ── 공통 POST: envelope(Map) 반환, 에러면 ApiException throw ──
  Future<Map<String, dynamic>> _post(
      String path, Map<String, dynamic> body) async {
    final http.Response res;
    try {
      res = await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: const {'Content-Type': 'application/json'},
            body: json.encode(body),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw ApiException('R_TIMEOUT', '요청 시간이 초과되었습니다.');
    } catch (e) {
      throw ApiException('NETWORK_ERROR', '서버에 연결할 수 없습니다.', cause: e);
    }

    print('===== RAW RESPONSE =====');
    print(utf8.decode(res.bodyBytes));

    final dynamic decoded =
        res.body.isEmpty ? const {} : json.decode(utf8.decode(res.bodyBytes));
    final map = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};

    if (res.statusCode == 200 || res.statusCode == 201) {
      return map; // { status, message, request, data, files }
    }

    // 에러 응답(4xx/5xx): 안정 식별자 `code` 로 분기
    throw ApiException(
      (map['code'] ?? 'INTERNAL_ERROR').toString(),
      (map['message'] ?? 'HTTP ${res.statusCode}').toString(),
      httpStatus: res.statusCode,
      details: (map['details'] as List?) ?? const [],
    );
  }

  // ── success/empty envelope → ApiResult<T> 변환 ──
  ApiResult<T> _wrap<T>(
      Map<String, dynamic> env, T Function(Map<String, dynamic>) parse) {
    final status = (env['status'] ?? 'success').toString();
    final request =
        (env['request'] as Map?)?.cast<String, dynamic>() ?? const {};
    if (status == 'empty') {
      return ApiResult(
          status: 'empty',
          message: env['message']?.toString(),
          request: request);
    }
    return ApiResult(
      status: 'success',
      message: env['message']?.toString(),
      request: request,
      data: parse(env),
    );
  }

  // ──────────────────────────────────────────────────────────────────
  //  1. 과거 노출 — POST /api/past/exposure
  // ──────────────────────────────────────────────────────────────────
  Future<ApiResult<ExposureApiResponse>> pastExposure({
    required String mode,
    required String year_,
    required String month_,
    required String sido_,
    required String sgg_,
  }) async {
    final env = await _post('/api/past/exposure', {
      'mode': mode,
      'year_': year_,
      'month_': month_,
      'sido_': sido_,
      'sgg_': sgg_,
    });
    return _wrap(env, ExposureApiResponse.fromJson);
  }

  // ──────────────────────────────────────────────────────────────────
  //  2. 과거 건강영향 — POST /api/past/healthrisk
  // ──────────────────────────────────────────────────────────────────
  Future<ApiResult<PastHealthRiskResponse>> pastHealthRisk({
    required String mode,
    required String evalGroup,
    required String sido_,
    required String sgg_,
  }) async {
    final env = await _post('/api/past/healthrisk', {
      'mode': mode,
      'eval_group': evalGroup,
      'sido_': sido_,
      'sgg_': sgg_,
    });
    return _wrap(env, PastHealthRiskResponse.fromJson);
  }

  // ──────────────────────────────────────────────────────────────────
  //  3. 미래 노출 시나리오 — POST /api/future/exposure
  //  온도: ssp_/gcm_ 필수 · 대기오염(PM2.5/O3): change_ap_ 필수
  // ──────────────────────────────────────────────────────────────────
  Future<ApiResult<FutureExposureResponse>> futureExposure({
    required String mode,
    required String sido_,
    required String sgg_,
    required String targetPeriod,
    String? ssp_,
    List<String>? gcm_,
    int? changeAp_,
  }) async {
    final env = await _post('/api/future/exposure', {
      'mode': mode,
      'sido_': sido_,
      'sgg_': sgg_,
      'target_period': targetPeriod,
      if (ssp_ != null) 'ssp_': ssp_,
      if (gcm_ != null) 'gcm_': gcm_,
      if (changeAp_ != null) 'change_ap_': changeAp_,
    });
    return _wrap(env, FutureExposureResponse.fromJson);
  }

  // ──────────────────────────────────────────────────────────────────
  //  4. 미래 건강영향 추정 — POST /api/future/projection
  // ──────────────────────────────────────────────────────────────────
  Future<ApiResult<FutureProjectionResponse>> futureProjection({
    required String mode,
    required String evalGroup,
    required String sido_,
    required String sgg_,
    required String targetPeriod,
    String? ssp_,
    List<String>? gcm_,
    String? policy_,
    int? changeAp_,
  }) async {
    final env = await _post('/api/future/projection', {
      'mode': mode,
      'eval_group': evalGroup,
      'sido_': sido_,
      'sgg_': sgg_,
      'target_period': targetPeriod,
      if (ssp_ != null) 'ssp_': ssp_,
      if (gcm_ != null) 'gcm_': gcm_,
      if (policy_ != null) 'policy_': policy_,
      if (changeAp_ != null) 'change_ap_': changeAp_,
    });
    return _wrap(env, FutureProjectionResponse.fromJson);
  }
}

// ════════════════════════════════════════════════════════════════════
//  공통 응답 래퍼 / 에러
// ════════════════════════════════════════════════════════════════════

/// status = `success` | `empty` 인 정상 응답 래퍼.
/// `empty` 면 [data] 는 null.
class ApiResult<T> {
  final String status;
  final String? message;
  final Map<String, dynamic> request;
  final T? data;

  const ApiResult({
    required this.status,
    this.message,
    this.request = const {},
    this.data,
  });

  bool get isSuccess => status == 'success';
  bool get isEmpty => status == 'empty';
}

/// 에러 응답(HTTP 4xx/5xx) 또는 네트워크/타임아웃.
/// `code` 로 분기: VALIDATION_ERROR / R_EXECUTION_ERROR / R_TIMEOUT /
/// BODY_TOO_LARGE / NOT_FOUND / INTERNAL_ERROR / NETWORK_ERROR.
class ApiException implements Exception {
  final String code;
  final String message;
  final int? httpStatus;
  final List<dynamic> details;
  final Object? cause;

  ApiException(
    this.code,
    this.message, {
    this.httpStatus,
    this.details = const [],
    this.cause,
  });

  /// details[] 안의 사람이 읽을 메시지들 (검증 실패 시).
  String get detailText =>
      details.map((d) => (d is Map ? d['msg'] : d).toString()).join('\n');

  @override
  String toString() => 'ApiException($code, http=$httpStatus): $message';
}

// ════════════════════════════════════════════════════════════════════
//  1. 과거 노출 응답 모델
// ════════════════════════════════════════════════════════════════════

class MapDataEntry {
  final String sggCode; // sgg_229 코드
  final double value; // col 값

  const MapDataEntry({required this.sggCode, required this.value});

  factory MapDataEntry.fromJson(Map<String, dynamic> json) => MapDataEntry(
        sggCode: json['sgg_229'].toString(),
        value: (json['col'] as num).toDouble(),
      );
}

class TimeSeriesEntry {
  final String period;
  final double value;
  final int year;
  final int month;

  const TimeSeriesEntry({
    required this.period,
    required this.value,
    required this.year,
    required this.month,
  });

  factory TimeSeriesEntry.fromJson(Map<String, dynamic> json) =>
      TimeSeriesEntry(
        period: json['period'].toString(),
        value: (json['col'] as num).toDouble(),
        year: (json['year'] as num).toInt(),
        month: (json['month'] as num).toInt(),
      );
}

class TableEntry {
  final String period;
  final double value;

  const TableEntry({required this.period, required this.value});

  factory TableEntry.fromJson(Map<String, dynamic> json) => TableEntry(
        period: json['기간'].toString(),
        value: (json['평균값'] as num).toDouble(),
      );
}

class ExposureApiResponse {
  final Map<String, dynamic> request;
  final List<MapDataEntry> mapData;
  final List<TimeSeriesEntry> timeseriesData;
  final List<TableEntry> monthly;
  final List<TableEntry> yearly;

  const ExposureApiResponse({
    this.request = const {},
    required this.mapData,
    required this.timeseriesData,
    required this.monthly,
    required this.yearly,
  });

  factory ExposureApiResponse.fromJson(Map<String, dynamic> json) {
    final request =
        (json['request'] as Map?)?.cast<String, dynamic>() ?? const {};
    final data = (json['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    final tableData =
        (data['table_data'] as Map?)?.cast<String, dynamic>() ?? const {};
    return ExposureApiResponse(
      request: request,
      mapData: _list(data['map_data'], MapDataEntry.fromJson),
      timeseriesData: _list(data['timeseries_data'], TimeSeriesEntry.fromJson),
      monthly: _list(tableData['monthly'], TableEntry.fromJson),
      yearly: _list(tableData['yearly'], TableEntry.fromJson),
    );
  }

  static ExposureApiResponse get empty => const ExposureApiResponse(
        request: {},
        mapData: [],
        timeseriesData: [],
        monthly: [],
        yearly: [],
      );
}

// ════════════════════════════════════════════════════════════════════
//  2. 과거 건강영향 응답 모델
// ════════════════════════════════════════════════════════════════════

class ExposurePoint {
  final String sggCode; // sgg_229
  final String sggName; // sgg_kr
  final double expVal; // exp_val

  const ExposurePoint(
      {required this.sggCode, required this.sggName, required this.expVal});

  factory ExposurePoint.fromJson(Map<String, dynamic> json) => ExposurePoint(
        sggCode: json['sgg_229'].toString(),
        sggName: json['sgg_kr']?.toString() ?? '',
        expVal: (json['exp_val'] as num).toDouble(),
      );
}

class RiskPoint {
  final String sggCode; // sgg_229
  final String sggName; // sgg_kr
  final double anVal; // an_val

  const RiskPoint(
      {required this.sggCode, required this.sggName, required this.anVal});

  factory RiskPoint.fromJson(Map<String, dynamic> json) => RiskPoint(
        sggCode: json['sgg_229'].toString(),
        sggName: json['sgg_kr']?.toString() ?? '',
        anVal: (json['an_val'] as num).toDouble(),
      );
}

class PastHealthRiskResponse {
  final List<ExposurePoint> exposureData;
  final List<RiskPoint> riskData;

  const PastHealthRiskResponse(
      {required this.exposureData, required this.riskData});

  factory PastHealthRiskResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    return PastHealthRiskResponse(
      exposureData: _list(data['exposure_data'], ExposurePoint.fromJson),
      riskData: _list(data['risk_data'], RiskPoint.fromJson),
    );
  }

  static PastHealthRiskResponse get empty =>
      const PastHealthRiskResponse(exposureData: [], riskData: []);
}

// ════════════════════════════════════════════════════════════════════
//  3. 미래 노출 시나리오 응답 모델
//  온도: yearly_trend[], period_summary[]
//  대기오염: full_summary[], selected_scenario[] (필드 미확정 → raw 유지)
// ════════════════════════════════════════════════════════════════════

class YearlyTrendPoint {
  final int year;
  final String gcm; // GCM
  final double meanVal; // mean_val

  const YearlyTrendPoint(
      {required this.year, required this.gcm, required this.meanVal});

  factory YearlyTrendPoint.fromJson(Map<String, dynamic> json) =>
      YearlyTrendPoint(
        year: (json['year'] as num).toInt(),
        gcm: json['GCM']?.toString() ?? '',
        meanVal: (json['mean_val'] as num).toDouble(),
      );
}

class PeriodSummaryPoint {
  final String period;
  final String gcm; // GCM
  final double meanVal; // mean_val
  final double? sdVal; // sd_val

  const PeriodSummaryPoint({
    required this.period,
    required this.gcm,
    required this.meanVal,
    this.sdVal,
  });

  factory PeriodSummaryPoint.fromJson(Map<String, dynamic> json) =>
      PeriodSummaryPoint(
        period: json['period'].toString(),
        gcm: json['GCM']?.toString() ?? '',
        meanVal: (json['mean_val'] as num).toDouble(),
        sdVal: (json['sd_val'] as num?)?.toDouble(),
      );
}

class FutureExposureResponse {
  final List<YearlyTrendPoint> yearlyTrend; // 온도
  final List<PeriodSummaryPoint> periodSummary; // 온도
  final List<Map<String, dynamic>> fullSummary; // 대기오염 (raw)
  final List<Map<String, dynamic>> selectedScenario; // 대기오염 (raw)

  const FutureExposureResponse({
    required this.yearlyTrend,
    required this.periodSummary,
    required this.fullSummary,
    required this.selectedScenario,
  });

  factory FutureExposureResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    return FutureExposureResponse(
      yearlyTrend: _list(data['yearly_trend'], YearlyTrendPoint.fromJson),
      periodSummary: _list(data['period_summary'], PeriodSummaryPoint.fromJson),
      fullSummary: _rawList(data['full_summary']),
      selectedScenario: _rawList(data['selected_scenario']),
    );
  }

  static FutureExposureResponse get empty => const FutureExposureResponse(
      yearlyTrend: [],
      periodSummary: [],
      fullSummary: [],
      selectedScenario: []);
}

// ════════════════════════════════════════════════════════════════════
//  4. 미래 건강영향 추정 응답 모델
//  온도/감염병: {period, GCM, an_sum} · 대기오염: {period, change_ap, policy, an_sum}
// ════════════════════════════════════════════════════════════════════

class SummaryPoint {
  final String period;
  final String? gcm; // GCM (온도/감염병)
  final double anSum; // an_sum
  final int? changeAp; // change_ap (대기오염)
  final String? policy; // policy (대기오염)

  const SummaryPoint({
    required this.period,
    required this.anSum,
    this.gcm,
    this.changeAp,
    this.policy,
  });

  factory SummaryPoint.fromJson(Map<String, dynamic> json) => SummaryPoint(
        period: json['period'].toString(),
        gcm: json['GCM']?.toString(),
        anSum: (json['an_sum'] as num).toDouble(),
        changeAp: (json['change_ap'] as num?)?.toInt(),
        policy: json['policy']?.toString(),
      );
}

class FutureProjectionResponse {
  final List<SummaryPoint> summaryData;

  const FutureProjectionResponse({required this.summaryData});

  factory FutureProjectionResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    return FutureProjectionResponse(
      summaryData: _list(data['summary_data'], SummaryPoint.fromJson),
    );
  }

  static FutureProjectionResponse get empty =>
      const FutureProjectionResponse(summaryData: []);
}

// ── helpers ──
List<T> _list<T>(dynamic raw, T Function(Map<String, dynamic>) fromJson) =>
    (raw as List?)
        ?.map((e) => fromJson((e as Map).cast<String, dynamic>()))
        .toList() ??
    <T>[];

List<Map<String, dynamic>> _rawList(dynamic raw) =>
    (raw as List?)?.map((e) => (e as Map).cast<String, dynamic>()).toList() ??
    <Map<String, dynamic>>[];
