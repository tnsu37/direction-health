import 'package:boilerplate/common/common.dart';
import 'package:flutter/material.dart';
import './grey_text.dart';

class OnboardingBox extends StatelessWidget {
  const OnboardingBox({super.key, required this.index, required this.onTap});

  final int index;
  final Function(int) onTap;

  static const logos = [
    'assets/logo/earth_logo.png',
    'assets/logo/pm_logo.png',
    'assets/logo/sun_logo.png',
  ];
  static const colors = [
    Color(0xff76C1E1),
    Color(0xffA1A1A9),
    Color(0xffF8742A)
  ];

  @override
  Widget build(BuildContext context) {
    final hoverNotifier = ValueNotifier(false);
    return MouseRegion(
        onEnter: (_) => hoverNotifier.value = true,
        onExit: (_) => hoverNotifier.value = false,
        cursor: SystemMouseCursors.basic,
        child: ValueListenableBuilder<bool>(
            valueListenable: hoverNotifier,
            builder: (context, isHovered, _) {
              return GestureDetector(
                onTap: () {
                  onTap(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: Common.bigSize.value ? 550 : 300,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: isHovered
                          ? Border.all(color: colors[index], width: 10)
                          : Border.all(color: Colors.transparent, width: 10),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(80)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(4, 5),
                            blurRadius: 30,
                            spreadRadius: 10),
                      ]),
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    children: [
                      Image.asset(logos[index], width: 150),
                      SizedBox(height: Common.bigSize.value ? 50 : 35),
                      Text(
                          index == 0
                              ? '노출'
                              : index == 1
                                  ? '건강 영향'
                                  : '미래 예측',
                          style: Common.bigSize.value
                              ? CommonStyle.textStyleFontBlack40700
                              : CommonStyle.textStyleFontBlack30700),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Common.bigSize.value ? 40 : 25),
                        child: index == 2
                            ? const GreyText(category: '미래 예측')
                            : index == 1
                                ? const GreyText(category: '건강 영향')
                                : const GreyText(category: '노출'),
                      ),
                      Material(
                        color: OnboardingBox.colors[index],
                        borderRadius: BorderRadius.circular(40),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            onTap(index);
                          },
                          splashColor: Colors.white.withOpacity(0.25),
                          highlightColor: Colors.white.withOpacity(0.07),
                          child: SizedBox(
                            width: Common.bigSize.value ? 230 : 180,
                            height: Common.bigSize.value ? 75 : 50,
                            child: Center(
                              child: Text(
                                '바로가기',
                                style: Common.bigSize.value
                                    ? const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white)
                                    : CommonStyle.textStyleWhite20700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
