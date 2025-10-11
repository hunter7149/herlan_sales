import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/web_viewer_screen_controller.dart';

class WebViewerScreenView extends GetView<WebViewerScreenController> {
  const WebViewerScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap Scaffold with PopScope to intercept system back button
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // Route already popped

        if (controller.webcontroller != null &&
            await controller.webcontroller!.canGoBack()) {
          // Go back inside webview
          await controller.webcontroller!.goBack();
        } else {
          // No web history — pop Flutter route
          // Get.back();
        }
      },
      child: Scaffold(
        // appBar: AppBar(title: const Text("Web Viewer")),
        body: SafeArea(
          child: Obx(
            () => Stack(
              children: [
                // WebView area
                Positioned.fill(
                  child: controller.webcontroller != null
                      ? WebViewWidget(controller: controller.webcontroller!)
                      : const Center(child: CircularProgressIndicator()),
                ),

                // Loading overlay
                if (controller.isWebLoading.value) const _LoadingOverlay(),

                // Error overlay
                if (controller.didErrorOccured.value)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 32,
                    child: _ErrorBanner(
                      message:
                          "Failed to load ${controller.lastVisitedUrl.value}",
                      onRetry: () {
                        if (controller.webcontroller != null) {
                          controller.webcontroller!.loadRequest(
                            Uri.parse(controller.webSiteLink.value),
                          );
                        } else {
                          unawaited(controller.setUpWebController());
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Loading overlay widget
class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          color: Colors.black.withOpacity(0.05),
          child: const Center(
            child: SizedBox(
              height: 110,
              width: 110,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: SpinKitFadingFour(
                      color: Colors.deepOrange,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Error banner with retry button
class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade300,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: const Text("Retry", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
