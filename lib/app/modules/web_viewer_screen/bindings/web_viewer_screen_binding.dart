import 'package:get/get.dart';

import '../controllers/web_viewer_screen_controller.dart';

class WebViewerScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebViewerScreenController>(
      () => WebViewerScreenController(),
    );
  }
}
