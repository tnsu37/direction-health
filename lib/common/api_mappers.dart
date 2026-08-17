// ════════════════════════════════════════════════════════════════════
//  UI 라벨 → API enum 값 변환
//  common.dart 의 드롭다운 라벨과 API_SPEC.md 의 유효값이 다르므로,
//  요청을 보내기 직전 이 헬퍼들로 변환한다.
// ════════════════════════════════════════════════════════════════════

class ApiMap {
  ApiMap._();

  /// selectedSubId(네비게이션 leaf id) → API `mode`
  /// 과거노출/시나리오는 pm25·o3·annualTemp·summerTemp,
  /// 건강영향/미래추정은 death_*·*_annual 형태.
  static String mode(String subId) {
    switch (subId) {
      case 'annualTemp':
        return '연중 온도';
      case 'summerTemp':
      case 'death_summer':
        return '여름철 온도';
      case 'pm25':
      case 'death_pm25':
        return 'PM2.5';
      case 'o3':
      case 'death_o3':
        return 'O3';
      case 'scrub_annual':
        return '쯔쯔가무시';
      case 'malaria_annual':
        return '말라리아';
      case 'waterborne_annual':
        return '수인성 감염병';
      default:
        return subId;
    }
  }

  /// '2018년' → '2018', '전체' → '전체'
  static String year(String v) => v == '전체' ? '전체' : v.replaceAll('년', '').trim();

  /// '7월' → '7', '전체' → '전체'
  static String month(String v) => v == '전체' ? '전체' : v.replaceAll('월', '').trim();

  /// '근미래(2031-2040)' → '2031-2040', '전체' → '전체'
  static String period(String v) {
    if (v == '전체') return '전체';
    final m = RegExp(r'\(([^)]+)\)').firstMatch(v);
    return m != null ? m.group(1)! : v;
  }

  /// 'SSP5-8.5' → 'SSP585'
  static String ssp(String v) {
    const table = {
      'SSP1-2.6': 'SSP126',
      'SSP2-4.5': 'SSP245',
      'SSP3-7.0': 'SSP370',
      'SSP5-8.5': 'SSP585',
    };
    return table[v] ?? v; // 이미 SSP585 형태면 그대로
  }

  /// ['앙상블', 'WRF'] → ['Ensemble', 'WRF']
  static List<String> gcm(List<String> models) =>
      models.map((m) => m == '앙상블' ? 'Ensemble' : m).toList();

  /// '심혈관계사망' → '심혈관계', '호흡기계사망' → '호흡기계', 그 외 그대로
  static String evalGroup(String v) {
    switch (v) {
      case '심혈관계사망':
        return '심혈관계';
      case '호흡기계사망':
        return '호흡기계';
      default:
        return v; // 전체 / 남성 / 여성 / 65세 미만 / 65세 이상
    }
  }

  /// 적응정책 라벨 → policy_
  /// PM2.5·O3·감염병은 항상 "none" 고정(온도만 녹지/그늘막쉼터 선택 가능)
  static String policy(String v) {
    switch (v) {
      case '녹지':
        return 'greenness';
      case '그늘막쉼터':
        return 'shelter';
      case '없음':
      default:
        return 'none';
    }
  }
}
