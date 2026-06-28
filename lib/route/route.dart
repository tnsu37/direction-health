import 'package:get/get.dart';

import '../pages/splash/bindings/splash_binding.dart';
import '../pages/splash/view/splash_view_page.dart';
import '../pages/onboarding/bindings/onboarding_binding.dart';
import '../pages/onboarding/view/onboarding_view_page.dart';
import '../pages/main/bindings/main_binding.dart';
import '../pages/main/view/main_view_page.dart';
import '../pages/exposure/bindings/exposure_binding.dart';
import '../pages/health_effects/bindings/health_effects_binding.dart';
import '../pages/scenario/bindings/scenario_binding.dart';
import '../pages/health_projection/bindings/health_projection_binding.dart';

class GetXRouter {
  static final route = [
    GetPage(
        name: '/',
        page: () => const SplashViewPage(),
        binding: SplashBinding(),
        popGesture: true),
    GetPage(
        name: '/onboarding',
        page: () => const OnboardingViewPage(),
        binding: OnboardingBinding(),
        popGesture: true),
    GetPage(
        name: '/main',
        page: () => const MainViewPage(),
        bindings: [
          MainBinding(),
          ExposureBinding(),
          HealthEffectsBinding(),
          ScenarioBinding(),
          HealthProjectionBinding()
        ],
        popGesture: true),
  ];
}
