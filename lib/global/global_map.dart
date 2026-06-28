import 'dart:convert';
import 'package:boilerplate/common/common.dart';
import '../common/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// ──────────────────────────────────────────────────────────────────
//  GeoJSON 캐시 (앱 수명 동안 한 번만 로드)
// ──────────────────────────────────────────────────────────────────

class _GeoCache {
  static List<dynamic>? _features;

  static Future<List<dynamic>> load() async {
    if (_features != null) return _features!;
    final raw =
        await rootBundle.loadString('assets/geojson/korea_sigungu.geojson');
    final parsed = jsonDecode(raw) as Map<String, dynamic>;
    _features = parsed['features'] as List<dynamic>;
    return _features!;
  }
}

// ──────────────────────────────────────────────────────────────────
//  색상 스케일 (Blue ─ White ─ Red 발산형)
// ──────────────────────────────────────────────────────────────────

class _ColorScale {
  const _ColorScale({required this.min, required this.max});
  final double min;
  final double max;

  static const Color _cold = Color(0xFF3B4CC0);
  static const Color _mid = Color(0xFFF7F7F7);
  static const Color _hot = Color(0xFFB40426);
  static const Color _noData = Color(0xFFE0E0E0);

  Color colorFor(double? value) {
    if (value == null) return _noData;
    if (max == min) return _mid;
    final t = ((value - min) / (max - min)).clamp(0.0, 1.0);
    if (t < 0.5) {
      return Color.lerp(_cold, _mid, t * 2)!;
    } else {
      return Color.lerp(_mid, _hot, (t - 0.5) * 2)!;
    }
  }

  /// 범례 색상 (0=cold, 1=hot)
  Color legendColor(double t) => colorFor(min + t * (max - min));
}

// ──────────────────────────────────────────────────────────────────
//  데이터 모델 (지도에 필요한 내부 구조)
// ──────────────────────────────────────────────────────────────────

class _PolygonFeature {
  final List<LatLng> outer;
  final List<List<LatLng>>? holes;
  final String sggCode;
  final String sggName;
  final double? value;

  const _PolygonFeature({
    required this.outer,
    this.holes,
    required this.sggCode,
    required this.sggName,
    this.value,
  });
}

// ──────────────────────────────────────────────────────────────────
//  KoreaMapWidget
// ──────────────────────────────────────────────────────────────────

class GlobalMap extends StatefulWidget {
  const GlobalMap({
    super.key,
    required this.mapData,
    this.label = '',
    this.title = '',
    this.unit = '',
    this.height = 638,
    this.onDistrictTapped,
  });

  /// API에서 받아온 지도 데이터 ({sgg_229, col})
  final List<MapDataEntry> mapData;

  /// 범례 라벨 (e.g. "여름철 온도")
  final String label;

  /// 제목
  final String title;

  /// 단위 (e.g. "°C", "μg/m³")
  final String unit;

  final double height;

  /// 시군구 탭 콜백 (이름, 값)
  final void Function(String name, double? value)? onDistrictTapped;

  @override
  State<GlobalMap> createState() => _KoreaMapWidgetState();
}

class _KoreaMapWidgetState extends State<GlobalMap> {
  List<_PolygonFeature>? _features;
  _ColorScale _scale = const _ColorScale(min: 0, max: 1);
  bool _loading = true;
  String? _error;

  _PolygonFeature? _hovered;

  @override
  void initState() {
    super.initState();
    _buildFeatures();
  }

  @override
  void didUpdateWidget(GlobalMap old) {
    super.didUpdateWidget(old);
    if (old.mapData != widget.mapData) {
      _buildFeatures();
    }
  }

  Future<void> _buildFeatures() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final geoFeatures = await _GeoCache.load();

      // 코드 → 값 맵
      final valueMap = <String, double>{
        for (final e in widget.mapData) e.sggCode: e.value,
      };

      // min/max 계산
      double minVal = double.infinity, maxVal = double.negativeInfinity;
      for (final v in valueMap.values) {
        if (v < minVal) minVal = v;
        if (v > maxVal) maxVal = v;
      }
      if (minVal == double.infinity) {
        minVal = 0;
        maxVal = 1;
      }
      _scale = _ColorScale(min: minVal, max: maxVal);
      // 피처 변환
      final features = <_PolygonFeature>[];

      for (final gf in geoFeatures) {
        final props = gf['properties'] as Map<String, dynamic>;

        final sggCode = props['sgg_229']?.toString() ?? '';
        final sggName = props['sgg_kr']?.toString() ??
            props['SIGUNGU_NM']?.toString() ??
            '';

        final value = valueMap[sggCode];

        final geom = gf['geometry'] as Map<String, dynamic>;
        final geomType = geom['type'].toString().trim();

        if (geomType == 'MultiPolygon') {
          final coords = geom['coordinates'] as List;

          for (final polygonCoords in coords) {
            final rings = polygonCoords as List;
            if (rings.isEmpty) continue;

            final outer = _toLatLngs(rings[0] as List);
            // ^^
            if (outer.length < 3) continue;

            final holes = rings.length > 1
                ? rings.sublist(1).map((r) => _toLatLngs(r as List)).toList()
                : null;

            features.add(_PolygonFeature(
              outer: outer,
              holes: holes,
              sggCode: sggCode,
              sggName: sggName,
              value: value,
            ));
          }
        } else if (geomType == 'Polygon') {
          final rings = geom['coordinates'] as List;
          if (rings.isEmpty) continue;

          final outer = _toLatLngs(rings[0] as List);

          final holes = rings.length > 1
              ? rings.sublist(1).map((r) => _toLatLngs(r as List)).toList()
              : null;

          features.add(_PolygonFeature(
            outer: outer,
            holes: holes,
            sggCode: sggCode,
            sggName: sggName,
            value: value,
          ));
        } else {
          print('Unsupported geometry type: $geomType');
        }
      }

      print('polygon features count: ${features.length}');

      if (mounted)
        setState(() {
          _features = features;
          _loading = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _error = e.toString();
          _loading = false;
        });
    }
  }

  List<LatLng> _toLatLngs(List coords) => coords
      .map<LatLng>((c) => LatLng(
            (c[1] as num).toDouble(),
            (c[0] as num).toDouble(),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return SizedBox(
        height: widget.height,
        child: Center(child: Text('지도 로드 오류: $_error')),
      );
    }

    return SizedBox(
      height: widget.height,
      child: Column(
        children: [
          if (widget.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(widget.title,
                  style: CommonStyle.textStyleFontBlack18500),
            ),
          SizedBox(
            height: 590,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── 지도 영역 ──
                Expanded(
                  child: ClipRect(
                    child: _buildMap(),
                  ),
                ),
                const SizedBox(width: 8),
                // ── 범례 ──
                _LegendBar(
                  scale: _scale,
                  label: widget.label,
                  unit: widget.unit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    final features = _features!;
    final scale = _scale;

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: const LatLng(36.5, 127.8),
            initialZoom: 6.8,
            minZoom: 5.5,
            maxZoom: 12.0,
            backgroundColor: Colors.white,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.drag |
                  InteractiveFlag.pinchZoom |
                  InteractiveFlag.scrollWheelZoom,
            ),
            onTap: (tapPos, latLng) => _onMapTap(latLng, features),
          ),
          children: [
            PolygonLayer(
              polygonCulling: false,
              polygons: features.map((f) {
                final isHovered = _hovered == f;
                final fillColor = scale.colorFor(f.value);

                return Polygon(
                  points: f.outer,
                  holePointsList: f.holes,
                  color: fillColor.withOpacity(0.85),
                  borderColor: Colors.black.withOpacity(0.4),
                  borderStrokeWidth: 0.5,
                  isFilled: true,
                );
              }).toList(),
            ),
          ],
        ),
        // ── 호버 정보 팝업 ──
        if (_hovered != null)
          Positioned(
            left: 12,
            bottom: 12,
            child: _InfoChip(feature: _hovered!, unit: widget.unit),
          ),
        // ── 조작 힌트 ──
        Positioned(
          right: 8,
          bottom: 8,
          child: Text(
            '스크롤: 확대/축소  |  드래그: 이동',
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }

  // 탭한 위치가 어느 시군구 폴리곤 안인지 판별 (Point-in-Polygon)
  void _onMapTap(LatLng latLng, List<_PolygonFeature> features) {
    _PolygonFeature? tapped;
    for (final f in features.reversed) {
      if (_pointInPolygon(latLng, f.outer)) {
        tapped = f;
        break;
      }
    }
    setState(() => _hovered = tapped);
    if (tapped != null) {
      widget.onDistrictTapped?.call(tapped.sggName, tapped.value);
    }
  }

  /// Ray-casting 알고리즘으로 point-in-polygon 판별
  bool _pointInPolygon(LatLng point, List<LatLng> polygon) {
    final px = point.longitude, py = point.latitude;
    bool inside = false;
    int j = polygon.length - 1;
    for (int i = 0; i < polygon.length; i++) {
      final xi = polygon[i].longitude, yi = polygon[i].latitude;
      final xj = polygon[j].longitude, yj = polygon[j].latitude;
      if (((yi > py) != (yj > py)) &&
          (px < (xj - xi) * (py - yi) / (yj - yi) + xi)) {
        inside = !inside;
      }
      j = i;
    }
    return inside;
  }
}

// ──────────────────────────────────────────────────────────────────
//  선택된 지역 정보 칩
// ──────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.feature, required this.unit});
  final _PolygonFeature feature;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final valStr = feature.value != null
        ? '${feature.value!.toStringAsFixed(2)} $unit'
        : '데이터 없음';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(color: Color(0x22000000), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            feature.sggName,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
              //fontFamily: 'Gothic',
            ),
          ),
          Text(
            valStr,
            style: TextStyle(
              fontSize: 11,
              // color: DirectionColors.primary,
              //fontFamily: 'Gothic',
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
//  색상 범례 바
// ──────────────────────────────────────────────────────────────────

class _LegendBar extends StatelessWidget {
  const _LegendBar({
    required this.scale,
    required this.label,
    required this.unit,
  });
  final _ColorScale scale;
  final String label;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final minLabel = scale.min.toStringAsFixed(1);
    final maxLabel = scale.max.toStringAsFixed(1);

    return SizedBox(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (label.isNotEmpty)
            Text(
              '$label${unit.isEmpty ? '' : ' ($unit)'}',
              style: const TextStyle(fontSize: 9, color: Color(0xFF666666)),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 6),
          // max 값
          Text(
            maxLabel,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF444444),
              fontFamily: 'Gothic',
            ),
          ),
          const SizedBox(height: 2),
          // 그라디언트 바
          SizedBox(
            width: 16,
            height: 140,
            child: CustomPaint(painter: _GradientBarPainter(scale: scale)),
          ),
          const SizedBox(height: 2),
          Text(
            minLabel,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF444444),
              fontFamily: 'Gothic',
            ),
          ),
          const SizedBox(height: 8),
          // 데이터 없음 범례
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 10, height: 10, color: _ColorScale._noData),
              const SizedBox(width: 3),
              const Text('N/A',
                  style: TextStyle(
                      fontSize: 8,
                      color: Color(0xFF888888),
                      fontFamily: 'Gothic')),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
//  그라디언트 바 CustomPainter
// ──────────────────────────────────────────────────────────────────

class _GradientBarPainter extends CustomPainter {
  const _GradientBarPainter({required this.scale});
  final _ColorScale scale;

  @override
  void paint(Canvas canvas, Size size) {
    const steps = 100;
    final paint = Paint();
    final h = size.height / steps;
    for (int i = 0; i < steps; i++) {
      final t = 1.0 - i / (steps - 1); // top = max (hot)
      paint.color = scale.legendColor(t);
      canvas.drawRect(Rect.fromLTWH(0, i * h, size.width, h + 0.5), paint);
    }
    // 테두리
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFFCCCCCC)
        ..strokeWidth = 0.5,
    );
  }

  @override
  bool shouldRepaint(_GradientBarPainter old) => old.scale != scale;
}
