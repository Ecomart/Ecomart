import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:inspireui/inspireui.dart' show PlatformError;

import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';

class WebViewScreen extends StatefulWidget {
  final String? title;
  final String? url;

  WebViewScreen({
    this.title,
    required this.url,
  });

  @override
  _StateWebViewScreen createState() => _StateWebViewScreen();
}

class _StateWebViewScreen extends State<WebViewScreen> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    if (isDesktop) return PlatformError();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () async {
                if (await _controller.canGoBack()) {
                  await _controller.goBack();
                } else {
                  Tools.showSnackBar(Scaffold.of(context),
                      Text(S.of(context).noBackHistoryItem));
                  return;
                }
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () async {
                if (await _controller.canGoForward()) {
                  await _controller.goForward();
                } else {
                  Tools.showSnackBar(
                      Scaffold.of(context), S.of(context).noForwardHistoryItem);
                  return;
                }
              },
              child: const Icon(Icons.arrow_forward_ios),
            ),
          )
        ],
      ),
      body: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
              onWebViewCreated: (WebViewController controller) {
                _controller = controller;
              },
            ),
    );
  }
}
