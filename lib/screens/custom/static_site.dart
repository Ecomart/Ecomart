import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show PlatformError;
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/constants.dart';

class StaticSite extends StatelessWidget {
  final String? data;

  StaticSite({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isDesktop
          ? PlatformError()
          : WebView(
              onWebViewCreated: (controller) async {
                await controller.loadUrl('data:text/html;base64,$data');
              },
            ),
    );
  }
}
