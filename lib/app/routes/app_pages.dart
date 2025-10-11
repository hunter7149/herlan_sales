import 'package:get/get.dart';

import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';

import '../modules/web_viewer_screen/bindings/web_viewer_screen_binding.dart';
import '../modules/web_viewer_screen/views/web_viewer_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHSCREEN;

  static final routes = [

    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => const SplashscreenView(),
      binding: SplashscreenBinding(),
    ),

    GetPage(
      name: _Paths.WEB_VIEWER_SCREEN,
      page: () => const WebViewerScreenView(),
      binding: WebViewerScreenBinding(),
    ),
  ];
}
