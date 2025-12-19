import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../providers/api_provider.dart';
import '../../../../providers/preferences_provider.dart';

class WebView extends StatefulWidget {
  const WebView({super.key, required this.contentId});
  final String contentId;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final apisProvider = Provider.of<ApiProvider>(context);
      final prefsProvider = Provider.of<PreferencesProvider>(context);
      await apisProvider.getAppContent(
          prefsProvider.accessToken ?? '', widget.contentId);
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(NavigationDelegate())
        ..loadRequest(Uri.parse(apisProvider.contentInfo?.content ?? ''));
    });
  }

  late WebViewController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(10),
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
