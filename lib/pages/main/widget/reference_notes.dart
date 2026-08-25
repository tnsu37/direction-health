import 'package:boilerplate/common/common.dart';
import 'package:flutter/material.dart';
import '../controller/main_controller.dart';

class _RefSection {
  const _RefSection(this.title, [this.lines = const []]);
  final String title;
  final List<String> lines;
}

// 메뉴별 참고사항 박스. 내용 출처: 디렉션 웹 기획_표 부분_v5.xlsx (각 시트 '참고사항 박스')
class ReferenceNotes extends StatelessWidget {
  const ReferenceNotes({super.key, required this.menu});
  final MainMenu menu;

  static const List<_RefSection> _exposure = [
    _RefSection(
        '■ 과거노출 파트는 과거 특정 기간 동안 우리 지역의 기상 및 대기오염 수준이 어느 정도였는지 확인하는 메뉴입니다.'),
    _RefSection('■ 각 자료별 산출기간', [
      '연중 온도: 2011-2019년 1-12월 / 여름철 온도: 2011-2019년 6-9월 / 초미세먼지(PM2.5): 2015-2019년 1-12월 / 오존(O3): 2015-2019년 6-9월',
    ]),
    _RefSection('■ 자료 출처', [
      '온도 자료: 기상청 / 대기오염 자료: AirKorea',
    ]),
    _RefSection('■ 단위', [
      '온도: °C / PM2.5: ㎍/㎥ / O3: ppm',
    ]),
  ];

  static const List<_RefSection> _healthImpact = [
    _RefSection(
        '■ 과거 건강영향 파트는 온도 또는 대기오염으로 인해 발생한 추가적인 건강 피해(사망 및 감염병 발생)를 보여주는 메뉴입니다.'),
    _RefSection('■ 결과지표 설명', [
      '기여사망자수 / 기여환자수 (AN, Attributable Number): 폭염이나 미세먼지 등 해당 환경위험 요인이 없었다면 발생하지 않았을 추가적인 사망자(또는 환자) 수',
    ]),
    _RefSection('■ 각 자료별 분석기간', [
      '여름철 온도: 2011-2019년 6-9월 / 초미세먼지(PM2.5): 2015-2019년 1-12월 / 오존(O3): 2015-2019년 6-9월, 분석 시 온도와 교호작용 효과 반영 / 감염병: 2011-2019년 1-12월',
    ]),
    _RefSection('■ 자료 출처', [
      '사망: 국가사망원인통계자료 / 감염병: 질병관리청 감염병 발생 자료',
    ]),
    _RefSection('■ 단위', [
      '온도: °C / PM2.5: ㎍/㎥ / O3: ppm / 기여사망자수: 명 / 기여환자수: 건',
    ]),
  ];

  static const List<_RefSection> _climateScenario = [
    _RefSection(
        '■ 기후변화 시나리오 파트는 미래 기후변화 경로에 따른 지역별 예측 온도를 제공하고, 대기오염 증감 수준에 따른 예상 대기질 결과를 제공하는 메뉴입니다.'),
    _RefSection('■ 핵심용어', [
      '기준연도 (Baseline): 미래 변화량을 비교하기 위한 과거의 기준기간 (온도: 2011~2019년 / 대기오염: 2015~2019년)',
      'SSP 시나리오: IPCC(기후변화에 관한 정부간 협의체)에서 발표한 미래 온실가스 배출 시나리오',
      "- SSP126: 화석연료 사용을 최소화하여 탄소중립을 달성하는 '가장 긍정적인(친환경)' 시나리오",
      "- SSP585: 현재 수준으로 화석연료를 무분별하게 계속 사용하는 '가장 최악의(고탄소)' 시나리오",
      "기후모델 (GCM): 미래 기후를 시뮬레이션하는 프로그램. 하나의 특정 모델 결과만 보면 오차가 있을 수 있으므로 여러 모델을 합쳐 평균을 낸 '앙상블(Ensemble)' 결과를 참고하는 것이 가장 안정적",
    ]),
    _RefSection('■ 참고', [
      '대기오염의 경우 장기 미래 예측의 불확실성이 매우 높아 현 시점 대비 증감 수준별 결과를 제공함',
    ]),
    _RefSection('■ 단위 및 기간', [
      '온도: °C / PM2.5: ㎍/㎥ / O3: ppm',
      '근미래: 2031-2040 / 중미래: 2041-2060 / 먼미래: 2081-2100'
    ]),
  ];

  static const List<_RefSection> _futureHealth = [
    _RefSection(
        '■ 건강영향 미래 추정 파트는 미래 온도 또는 대기오염으로 인해 발생하게 될 추가적인 건강 피해(사망 및 감염병 발생)를 보여주는 메뉴입니다.'),
    _RefSection('■ 핵심용어', [
      '기준연도 (Baseline): 미래 변화량을 비교하기 위한 과거의 기준기간 (온도: 2011~2019년 / 대기오염: 2015~2019년)',
      'SSP 시나리오: IPCC(기후변화에 관한 정부간 협의체)에서 발표한 미래 온실가스 배출 시나리오',
      "- SSP126: 화석연료 사용을 최소화하여 탄소중립을 달성하는 '가장 긍정적인(친환경)' 시나리오",
      "- SSP585: 현재 수준으로 화석연료를 무분별하게 계속 사용하는 '가장 최악의(고탄소)' 시나리오",
      "기후모델 (GCM): 미래 기후를 시뮬레이션하는 프로그램. 하나의 특정 모델 결과만 보면 오차가 있을 수 있으므로 여러 모델을 합쳐 평균을 낸 '앙상블(Ensemble)' 결과를 참고하는 것이 가장 안정적",
    ]),
    _RefSection('■ 결과지표 설명', [
      '기여사망자수 / 기여환자수 (AN, Attributable Number): 폭염이나 미세먼지 등 해당 환경위험 요인이 없었다면 발생하지 않았을 추가적인 사망자(또는 환자) 수',
    ]),
    _RefSection('■ 적응정책 시나리오 설명', [
      '그늘막 쉼터 (Shelter) / 녹지 면적 확대 (Greenness): 여름철 폭염에 대응하기 위해 지자체가 물리적인 인프라를 확충했을 때의 시나리오',
      '대기오염 저감 (-X%): 미세먼지나 오존의 농도를 과거 기준연도 대비 일정 비율(-5% ~ -30%)만큼 감축시키는 정책을 달성했을 때를 가정',
    ]),
    _RefSection('■ 참고', [
      '오존(O3)의 경우 온도와 밀접한 관계가 있는 것으로 알려져 있으므로, 건강영향 미래 추정 분석 시 온도와의 교호작용 효과를 반영함',
    ]),
    _RefSection('■ 단위', [
      '온도: °C / PM2.5: ㎍/㎥ / O3: ppm / 기여사망자수: 명 / 기여환자수: 건',
    ]),
  ];

  List<_RefSection> get _sections {
    switch (menu) {
      case MainMenu.exposure:
        return _exposure;
      case MainMenu.healthImpact:
        return _healthImpact;
      case MainMenu.climateScenario:
        return _climateScenario;
      case MainMenu.futureHealth:
        return _futureHealth;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = _sections;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < sections.length; i++) ...[
          if (i > 0) const SizedBox(height: 15),
          Text(sections[i].title, style: CommonStyle.textStyleFontBlack14600),
          for (final line in sections[i].lines) ...[
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(left: line.startsWith('-') ? 12 : 0),
              child: Text(line, style: CommonStyle.textStyleFontBlack13400),
            ),
          ],
        ],
      ],
    );
  }
}
