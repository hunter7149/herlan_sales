// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-warm the webview engine (reduces first-load jank)
  // Note: This simply ensures the platform is initialized; different webview versions
  // may offer explicit pre-warm APIs.
  try {
    // Accessing WebViewPlatform ensures platform-specific engines are loaded earlier.
    final _ = WebViewController;
  } catch (_) {}

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
  title: 'Herlan',
  initialRoute: Routes.SPLASHSCREEN, // Make sure this page exists
  getPages: AppPages.routes,
  debugShowCheckedModeBanner: false,
  // Optional: disable restoration for now if it causes null errors

);

  }
}
