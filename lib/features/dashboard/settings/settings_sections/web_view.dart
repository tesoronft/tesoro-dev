import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/enums/api_enums.dart';
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
      final apisProvider = Provider.of<ApiProvider>(context, listen: false);
      final prefsProvider =
          Provider.of<PreferencesProvider>(context, listen: false);
      final result = await apisProvider.getAppContent(
          prefsProvider.accessToken ?? '', widget.contentId);
      if (result == ApiEnums.success) {
        controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(NavigationDelegate(
            onPageStarted: (url) => 'Loading Html request',
          ))
          ..loadHtmlString(
            apisProvider.contentInfo?.content ?? '',
          );
      }
    });
  }

  WebViewController? controller;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: AppColors.light,
      isAppbarRequired: true,
      child: Consumer<ApiProvider>(
        builder: (context, api, child) => SafeArea(
          minimum: EdgeInsets.all(10),
          child: api.isLoading
              ? Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black38,
                    ),
                    child: SpinKitCircle(
                      color: AppColors.primary,
                    ),
                  ),
                )
              : WebViewWidget(controller: controller!),
        ),
      ),
    );
  }
}
