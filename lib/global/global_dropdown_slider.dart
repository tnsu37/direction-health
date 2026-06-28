import 'package:flutter/material.dart';
import 'package:boilerplate/common/common.dart';

class GlobalDropdownSlider extends StatefulWidget {
  const GlobalDropdownSlider({
    super.key,
    this.initial = 0,
    this.onChanged,
  });

  final int initial;
  final ValueChanged<int>? onChanged;

  @override
  State<GlobalDropdownSlider> createState() => _GlobalDropdownSliderState();
}

class _GlobalDropdownSliderState extends State<GlobalDropdownSlider> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initial;
  }

  String get display => _value == 0 ? '변화 없음' : '농도 $_value%';

  void _open() {
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _close,
            ),
          ),
          CompositedTransformFollower(
            link: _link,
            offset: const Offset(0, 42),
            child: Material(
              color: Colors.transparent,
              child: _SliderPopup(
                value: _value,
                onChanged: (v) {
                  setState(() => _value = v);
                  widget.onChanged?.call(v);
                  _entry?.markNeedsBuild();
                },
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_entry!);
  }

  void _close() {
    _entry?.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final big = Common.bigSize.value;

    return CompositedTransformTarget(
      link: _link,
      child: InkWell(
        onTap: _open,
        child: Container(
          height: big ? 44 : 37,
          padding: const EdgeInsets.only(left: 15, right: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xffdcdfe6)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  display,
                  overflow: TextOverflow.ellipsis,
                  style: big
                      ? CommonStyle.textStyleFontBlack20300
                      : CommonStyle.textStyleFontBlack13300,
                ),
              ),
              Icon(
                Icons.expand_more,
                size: big ? 20 : 15,
                color: CommonColor.hintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliderPopup extends StatelessWidget {
  const _SliderPopup({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Common.bigSize.value ? 170 : 135,
      height: Common.bigSize.value ? 82 : 72,
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
              color: const Color(0xff101828).withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 2),
        ],
      ),
      child: Slider(
        min: -30,
        max: 30,
        divisions: 12,
        value: value.toDouble(),
        label: value == 0 ? '변화 없음' : '농도 $value%',
        activeColor: CommonColor.mainColor,
        inactiveColor: CommonColor.greyColor,
        onChanged: (v) {
          onChanged((v / 5).round() * 5);
        },
      ),
    );
  }
}
