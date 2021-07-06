import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../models/app_model.dart';
import '../../../screens/index.dart';
import '../../../services/index.dart' show Config;

mixin SmartChatMixin<T extends StatefulWidget> on State<T> {
  late List<String> _showOnScreens;
  final _hideOnScreens = <String>[];

  late bool _showChat;

  bool get _useVendorChat => Config().isVendorType();

  bool get _enableChat =>
      (kConfigChat['EnableSmartChat'] ?? false) &&
      kConfigChat['showOnScreens'] != null;

  @override
  void initState() {
    super.initState();
    if (_enableChat) {
      _showOnScreens = List<String>.from(kConfigChat['showOnScreens']);
      if (_useVendorChat) {
        _hideOnScreens.addAll([
          RouteList.productDetail,
          RouteList.storeDetail,
        ]);
      }
    }
    _showChat = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildSmartChatWidget() {
    return IgnorePointer(
      ignoring: !_showChat,
      child: AnimatedOpacity(
        opacity: _showChat ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: SmartChat(
          margin: EdgeInsets.only(
            right:
                Provider.of<AppModel>(context, listen: false).langCode == 'ar'
                    ? 32.0
                    : 16.0,
          ),
        ),
      ),
    );
  }

  void handleSmartChat(String? screenName) {
    /// routeName is a route emitted by RouteObservable
    /// Which can be modify by [FluxNavigate] to support Web
    ///
    /// screenName is define in env.dart file
    /// Which can not modify and the same in [RouteList]

    if (screenName == null) return;
    if (!_enableChat) return;

    if (_hideOnScreens.contains(screenName)) {
      _showChat = false;
      return;
    }

    if (!_showOnScreens.contains(screenName)) {
      _showChat = false;
      return;
    }

    _showChat = true;
  }
}
