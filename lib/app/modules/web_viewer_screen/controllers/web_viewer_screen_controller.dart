import 'dart:async';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:herlan_sales/app/data/prefrences.dart';

class WebViewerScreenController extends GetxController {
  final RxString webSiteLink =
      "https://attendancev2.herlan.store/admin/login".obs;
  final RxBool isWebLoading = true.obs;
  final RxBool didErrorOccured = false.obs;
  final RxString lastVisitedUrl = "".obs;

  WebViewController? webcontroller;
  Timer? _progressDebounce;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 150), () {
      unawaited(setUpWebController());
    });
  }

  Future<void> setUpWebController({String? token}) async {
    webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            _progressDebounce?.cancel();
            _progressDebounce = Timer(const Duration(milliseconds: 100), () {
              isWebLoading.value = progress < 100;
            });
          },
          onPageStarted: (url) {
            didErrorOccured.value = false;
            isWebLoading.value = true;
            lastVisitedUrl.value = url;
          },
          onPageFinished: (url) {
            isWebLoading.value = false;
            lastVisitedUrl.value = url;
          },
          onWebResourceError: (error) {
            didErrorOccured.value = true;
            lastVisitedUrl.value = error.url ?? lastVisitedUrl.value;
            isWebLoading.value = false;
          },
        ),
      );

    if (token != null) {
      try {
        await webcontroller!.runJavaScript(
            "document.cookie = 'session_token=$token; path=/;';");
      } catch (_) {}
    }

    try {
      await webcontroller!.loadRequest(Uri.parse(webSiteLink.value));
    } catch (_) {
      didErrorOccured.value = true;
      isWebLoading.value = false;
    }
  }

  Future<bool> canGoBack() async {
    if (webcontroller == null) return false;
    try {
      return await webcontroller!.canGoBack();
    } catch (_) {
      return false;
    }
  }

  Future<void> goBack() async {
    if (webcontroller == null) return;
    if (await webcontroller!.canGoBack()) {
      await webcontroller!.goBack();
    }
  }

  @override
  void onClose() {
    _progressDebounce?.cancel();
    super.onClose();
  }
}
