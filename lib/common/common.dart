import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import '../pages/main/controller/main_controller.dart';

class CommonColor {
  static Color mainColor = const Color(0xff002677);
  static Color hintColor = const Color(0xffA1A1A9);
  static Color greyColor = const Color(0xffaaaaaa);
  static Color font3C4856 = const Color(0xff3C4856);
  static Color font5D6978 = const Color(0xff5D6978);
  static Color fontA5B2C2 = const Color(0xffA5B2C2);
  static Color font585858 = const Color(0xff585858);
  static Color fontBlack = const Color(0xff231F20);
  static Color font7D7D7D = const Color(0xff7D7D7D);
  static Color fontAAAAAA = const Color(0xffAAAAAA);
}

class CommonStyle {
  static TextStyle textStyle24500 =
      const TextStyle(fontSize: 24, fontWeight: FontWeight.w500);
  static TextStyle textStyle22400 =
      const TextStyle(fontSize: 22, fontWeight: FontWeight.w400);
  static TextStyle textStyle20500 =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  static TextStyle textStyle18400 =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
  static TextStyle textStyle16500 =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static TextStyle textStyle13600 =
      const TextStyle(fontSize: 13, fontWeight: FontWeight.w600);
  static TextStyle textStyle11600 =
      const TextStyle(fontSize: 11, fontWeight: FontWeight.w600);

  ///---------------------------font7D7D7D------------------------------
  static TextStyle textStyle7D24700 = TextStyle(
      fontSize: 24, fontWeight: FontWeight.w700, color: CommonColor.font7D7D7D);
  static TextStyle textStyle7D13700 = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w700, color: CommonColor.font7D7D7D);

  ///---------------------------fontAAAAAA------------------------------
  static TextStyle textStyleAA30700 = TextStyle(
      fontSize: 30, fontWeight: FontWeight.w700, color: CommonColor.fontAAAAAA);
  static TextStyle textStyleAA20400 = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w400, color: CommonColor.fontAAAAAA);
  static TextStyle textStyleAA16400 = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, color: CommonColor.fontAAAAAA);

  ///---------------------------font3C4856------------------------------
  static TextStyle textStyleFontTitle55400 = TextStyle(
      fontSize: 55, fontWeight: FontWeight.w400, color: CommonColor.font3C4856);

  ///---------------------------font585858------------------------------
  static TextStyle textStyleFont5835300 = TextStyle(
      fontSize: 35, fontWeight: FontWeight.w300, color: CommonColor.font585858);
  static TextStyle textStyleFont5824500 = TextStyle(
      fontSize: 24, fontWeight: FontWeight.w500, color: CommonColor.font585858);
  static TextStyle textStyleFont5820500 = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w500, color: CommonColor.font585858);

  ///---------------------------white------------------------------
  static TextStyle textStyleWhite75600 = const TextStyle(
      fontSize: 75, fontWeight: FontWeight.w600, color: Colors.white);
  static TextStyle textStyleWhite32600 = const TextStyle(
      fontSize: 32, fontWeight: FontWeight.w600, color: Colors.white);
  static TextStyle textStyleWhite25600 = const TextStyle(
      fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white);
  static TextStyle textStyleWhite23400 = const TextStyle(
      fontSize: 23, fontWeight: FontWeight.w400, color: Colors.white);
  static TextStyle textStyleWhite20700 = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle textStyleWhite20600 = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white);
  static TextStyle textStyleWhite20500 = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white);
  static TextStyle textStyleWhite20400 = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white);
  static TextStyle textStyleWhite18400 = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white);
  static TextStyle textStyleWhite16600 = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);
  static TextStyle textStyleWhite15500 = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white);

  ///-----------------------------main--------------------------------
  static TextStyle textStyleMain27400 = TextStyle(
      fontSize: 27, fontWeight: FontWeight.w400, color: CommonColor.mainColor);
  static TextStyle textStyleMain24500 = TextStyle(
      fontSize: 24, fontWeight: FontWeight.w500, color: CommonColor.mainColor);
  static TextStyle textStyleMain20500 = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w500, color: CommonColor.mainColor);
  static TextStyle textStyleMain20400 = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w400, color: CommonColor.mainColor);
  static TextStyle textStyleMain16500 = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w500, color: CommonColor.mainColor);
  static TextStyle textStyleMain14400 = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w400, color: CommonColor.mainColor);

  ///-----------------------------fontBaclk--------------------------------
  static TextStyle textStyleFontBlack27400 = TextStyle(
      fontSize: 27, fontWeight: FontWeight.w400, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack20400 = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w400, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack18400 = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w400, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack18600 = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w600, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack14600 = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w600, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack14500 = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack16400 = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack24700 = TextStyle(
      fontSize: 24, fontWeight: FontWeight.w700, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack24500 = TextStyle(
      fontSize: 24, fontWeight: FontWeight.w500, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack32300 = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w300,
      color: CommonColor.fontBlack,
      height: 1);
  static TextStyle textStyleFontBlack27300 = TextStyle(
      fontSize: 27, fontWeight: FontWeight.w300, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack30500 = TextStyle(
      fontSize: 30, fontWeight: FontWeight.w500, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack30700 = TextStyle(
      fontSize: 30, fontWeight: FontWeight.w700, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack40300 = TextStyle(
      fontSize: 40, fontWeight: FontWeight.w300, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack40700 = TextStyle(
      fontSize: 40, fontWeight: FontWeight.w700, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack25300 = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w300,
      color: CommonColor.fontBlack,
      height: 1);
  static TextStyle textStyleFontBlack20300 = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w300,
      color: CommonColor.fontBlack,
      height: 1);
  static TextStyle textStyleFontBlack17300 = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w300,
      color: CommonColor.fontBlack,
      height: 1);
  static TextStyle textStyleFontBlack13400 = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w400, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack13300 = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w300, color: CommonColor.fontBlack);
  static TextStyle textStyleFontBlack12300 = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w300, color: CommonColor.fontBlack);

  ///-----------------------------grey--------------------------------
  static TextStyle textStyleGret22400 = TextStyle(
      fontSize: 22, fontWeight: FontWeight.w400, color: CommonColor.greyColor);
  static TextStyle textStyleGret18400 = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w400, color: CommonColor.greyColor);

  ///-----------------------------hint--------------------------------
  static TextStyle textStyleHint28300 = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w300,
      color: CommonColor.hintColor,
      height: 1);
  static TextStyle textStyleHint22300 = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w300,
      color: CommonColor.hintColor,
      height: 1);
}

class Common {
  static RxBool isLoading = false.obs;
  static RxBool bigSize = true.obs;

  static const Map<MainMenu, List<NavSubItem>> navTree = {
    MainMenu.exposure: [
      NavSubItem(id: 'annualTemp', label: '연중 온도'),
      NavSubItem(id: 'summerTemp', label: '여름철 온도'),
      NavSubItem(id: 'pm25', label: 'PM₂.₅'),
      NavSubItem(id: 'o3', label: 'O₃'),
    ],
    MainMenu.healthImpact: [
      NavSubItem(id: 'death', label: '사망', children: [
        NavSubItem(id: 'death_summer', label: '여름철 온도'),
        NavSubItem(id: 'death_pm25', label: 'PM₂.₅'),
        NavSubItem(id: 'death_o3', label: 'O₃'),
      ]),
      NavSubItem(id: 'scrubTyphus', label: '쯔쯔가무시병', children: [
        NavSubItem(id: 'scrub_annual', label: '연중 온도'),
      ]),
      NavSubItem(id: 'malaria', label: '말라리아', children: [
        NavSubItem(id: 'malaria_annual', label: '연중 온도'),
      ]),
      NavSubItem(id: 'waterborne', label: '수인성 감염병', children: [
        NavSubItem(id: 'waterborne_annual', label: '연중 온도'),
      ]),
    ],
    MainMenu.climateScenario: [
      NavSubItem(id: 'annualTemp', label: '연중 온도'),
      NavSubItem(id: 'summerTemp', label: '여름철 온도'),
      NavSubItem(id: 'pm25', label: 'PM₂.₅'),
      NavSubItem(id: 'o3', label: 'O₃'),
    ],
    MainMenu.futureHealth: [
      NavSubItem(id: 'death', label: '사망', children: [
        NavSubItem(id: 'death_summer', label: '여름철 온도'),
        NavSubItem(id: 'death_pm25', label: 'PM₂.₅'),
        NavSubItem(id: 'death_o3', label: 'O₃'),
      ]),
      NavSubItem(id: 'scrubTyphus', label: '쯔쯔가무시병', children: [
        NavSubItem(id: 'scrub_annual', label: '연중 온도'),
      ]),
      NavSubItem(id: 'malaria', label: '말라리아', children: [
        NavSubItem(id: 'malaria_annual', label: '연중 온도'),
      ]),
      NavSubItem(id: 'waterborne', label: '수인성 감염병', children: [
        NavSubItem(id: 'waterborne_annual', label: '연중 온도'),
      ]),
    ],
  };

  static const List<String> years = [
    '전체',
    '2011년',
    '2012년',
    '2013년',
    '2014년',
    '2015년',
    '2016년',
    '2017년',
    '2018년',
    '2019년',
  ];

  static const List<String> years2 = [
    '전체',
    '2015년',
    '2016년',
    '2017년',
    '2018년',
    '2019년',
  ];

  static const List<String> months = [
    '전체',
    '1월',
    '2월',
    '3월',
    '4월',
    '5월',
    '6월',
    '7월',
    '8월',
    '9월',
    '10월',
    '11월',
    '12월',
  ];

  static const List<String> summer = ['전체', '6월', '7월', '8월', '9월'];

  ///[시도] 전체 시도
  static const List<String> sido1 = [
    '전체',
    '서울특별시',
    '부산광역시',
    '대구광역시',
    '인천광역시',
    '광주광역시',
    '대전광역시',
    '울산광역시',
    '세종특별자치시',
    '경기도',
    '강원도',
    '충청북도',
    '충청남도',
    '전라북도',
    '전라남도',
    '경상북도',
    '경상남도',
    '제주특별자치도',
  ];

  ///[시도] 전체 시도(제주 제외) > 대기오염
  static const List<String> sido2 = [
    '전체',
    '서울특별시',
    '부산광역시',
    '대구광역시',
    '인천광역시',
    '광주광역시',
    '대전광역시',
    '울산광역시',
    '세종특별자치시',
    '경기도',
    '강원도',
    '충청북도',
    '충청남도',
    '전라북도',
    '전라남도',
    '경상북도',
    '경상남도',
  ];

  ///[시도] -  말라리아
  static const List<String> sido3 = ['전체', '서울특별시', '인천광역시', '경기도', '강원도'];

  static const List<String> periods = [
    '전체',
    '근미래(2031-2040)',
    '중미래(2041-2060)',
    '먼미래(2081-2100)',
  ];

  ///[평가그룹] 사망
  static const List<String> evalGroups1 = [
    '전체',
    '남성',
    '여성',
    '65세 미만',
    '65세 이상',
    '심혈관계사망',
    '호흡기계사망'
  ];

  ///[평가그룹] 감염병 - 쯔쯔가무시병&말라리아
  static const List<String> evalGroups2 = ['전체'];

  ///[평가그룹] 감염병 - 수인성감염병
  static const List<String> evalGroups3 = ['전체', '65세 미만', '65세 이상'];

  static const List<String> scenarios = [
    'SSP1-2.6',
    'SSP2-4.5',
    'SSP3-7.0',
    'SSP5-8.5',
  ];

  static const List<String> climateModels = [
    '앙상블',
    'WRF',
    'CCLM',
    'GRIMs',
    'HadGEM3-RA',
    'RegCM',
  ];

  ///[적응정책] 여름철온도
  static const List<String> adaptations1 = ['없음', '녹지', '그늘막쉼터'];

  static String unit(String subId) {
    final id = subId.toLowerCase();

    if (id.contains('pm25')) {
      return 'μg/m³';
    }
    if (id.contains('o3')) {
      return 'ppm';
    }
    return '°C';
  }

  static Map<String, List<String>> sgg1 = {
    '전체': ['전체'],
    '서울특별시': [
      '전체',
      '강남구',
      '강동구',
      '강북구',
      '강서구',
      '관악구',
      '광진구',
      '구로구',
      '금천구',
      '노원구',
      '도봉구',
      '동대문구',
      '동작구',
      '마포구',
      '서대문구',
      '서초구',
      '성동구',
      '성북구',
      '송파구',
      '양천구',
      '영등포구',
      '용산구',
      '은평구',
      '종로구',
      '중구',
      '중랑구'
    ],
    '부산광역시': [
      '전체',
      '강서구',
      '금정구',
      '기장군',
      '남구',
      '동구',
      '동래구',
      '부산진구',
      '북구',
      '사상구',
      '사하구',
      '서구',
      '수영구',
      '연제구',
      '영도구',
      '중구',
      '해운대구'
    ],
    '대구광역시': ['전체', '중구', '동구', '서구', '남구', '북구', '수성구', '달서구', '달성군', '군위군'],
    '인천광역시': [
      '전체',
      '강화군',
      '계양구',
      '남동구',
      '동구',
      '미추홀구',
      '부평구',
      '서구',
      '연수구',
      '옹진군',
      '중구'
    ],
    '광주광역시': ['전체', '광산구', '남구', '동구', '북구', '서구'],
    '대전광역시': ['전체', '대덕구', '동구', '서구', '유성구', '중구'],
    '울산광역시': ['전체', '남구', '동구', '북구', '울주군', '중구'],
    '세종특별자치시': ['전체', '세종시'],
    '경기도': [
      '전체',
      '가평군',
      '고양시',
      '과천시',
      '광명시',
      '광주시',
      '구리시',
      '군포시',
      '김포시',
      '남양주시',
      '동두천시',
      '부천시',
      '성남시',
      '수원시',
      '시흥시',
      '안산시',
      '안성시',
      '안양시',
      '양주시',
      '양평군',
      '여주시',
      '연천군',
      '오산시',
      '용인시',
      '의왕시',
      '의정부시',
      '이천시',
      '파주시',
      '평택시',
      '포천시',
      '하남시',
      '화성시'
    ],
    '강원도': [
      '전체',
      '강릉시',
      '고성군',
      '동해시',
      '삼척시',
      '속초시',
      '양구군',
      '양양군',
      '영월군',
      '원주시',
      '인제군',
      '정선군',
      '철원군',
      '춘천시',
      '태백시',
      '평창군',
      '홍천군',
      '화천군',
      '횡성군'
    ],
    '충청북도': [
      '전체',
      '괴산군',
      '단양군',
      '보은군',
      '영동군',
      '옥천군',
      '음성군',
      '제천시',
      '증평군',
      '진천군',
      '통합청주시',
      '충주시'
    ],
    '충청남도': [
      '전체',
      '계룡시',
      '공주시',
      '금산군',
      '논산시',
      '당진시',
      '보령시',
      '부여군',
      '서산시',
      '서천군',
      '아산시',
      '예산군',
      '천안시',
      '청양군',
      '태안군',
      '홍성군'
    ],
    '전라북도': [
      '전체',
      '고창군',
      '군산시',
      '김제시',
      '남원시',
      '무주군',
      '부안군',
      '순창군',
      '완주군',
      '익산시',
      '임실군',
      '장수군',
      '전주시',
      '정읍시',
      '진안군'
    ],
    '전라남도': [
      '전체',
      '강진군',
      '고흥군',
      '곡성군',
      '광양시',
      '구례군',
      '나주시',
      '담양군',
      '목포시',
      '무안군',
      '보성군',
      '순천시',
      '신안군',
      '여수시',
      '영광군',
      '영암군',
      '완도군',
      '장성군',
      '장흥군',
      '진도군',
      '함평군',
      '해남군',
      '화순군'
    ],
    '경상북도': [
      '전체',
      '경산시',
      '경주시',
      '고령군',
      '구미시',
      '김천시',
      '문경시',
      '봉화군',
      '상주시',
      '성주군',
      '안동시',
      '영덕군',
      '영양군',
      '영주시',
      '영천시',
      '예천군',
      '울릉군',
      '울진군',
      '의성군',
      '청도군',
      '청송군',
      '칠곡군',
      '포항시',
    ],
    '경상남도': [
      '전체',
      '거제시',
      '거창군',
      '고성군',
      '김해시',
      '남해군',
      '통합창원시',
      '밀양시',
      '사천시',
      '산청군',
      '양산시',
      '의령군',
      '진주시',
      '창녕군',
      '통영시',
      '하동군',
      '함안군',
      '함양군',
      '합천군'
    ],
    '제주특별자치도': ['전체', '서귀포시', '제주시']
  };

  static Map<String, List<String>> sgg2 = {
    '전체': ['전체'],
    '경기도': [
      '전체',
      '파주시',
      '양주시',
      '고양시',
      '김포시',
      '고양시',
      '연천군',
      '포천시',
      '부천시',
      '고양시',
      '성남시',
      '남양주시',
      '의정부시',
    ],
    '인천광역시': ['전체', '강화군', '서구', '계양구', '부평구', '남동구', '연수구', '미추홀구', '중구'],
    '강원도': ['전체', '철원군'],
    '서울특별시': ['전체', '강서구', '양천구', '관악구', '영등포구']
  };
}
