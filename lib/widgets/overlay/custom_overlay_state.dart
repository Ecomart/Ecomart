import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../menu/index.dart' show MainTabControlDelegate;
import '../../models/app_model.dart';
import '../../modules/advertisement/index.dart'
    show AdvertisementConfig, AdvertisementMixin;
import '../../screens/base_screen.dart';
import '../../services/index.dart';
import 'mixin/smart_chat_mixin.dart';

class OverlayControlDelegate {
  Function(String? nameRoute)? emitRoute;
  Function(String? nameRoute)? emitTab;
  static OverlayControlDelegate? _instance;

  factory OverlayControlDelegate() {
    return _instance ??= OverlayControlDelegate._();
  }

  OverlayControlDelegate._();
}

abstract class CustomOverlayState<T extends StatefulWidget>
    extends BaseScreen<T> with AdvertisementMixin, SmartChatMixin {
  double bottomBarHeight = kBottomNavigationBarHeight - 15;

  OverlayEntry? _overlayEntry;

  final _tag = 'custom-overlay';

  final overlayController = StreamController<bool>.broadcast()..add(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      EasyDebounce.debounce(_tag, const Duration(seconds: 2), () {
        OverlayControlDelegate().emitRoute = _handleBottomBarHeight;
        OverlayControlDelegate().emitTab =
            (tabName) => _handleBottomBarHeight(tabName, onBottomBar: true);
        _overlayEntry = _buildOverlayEntry();
        Overlay.of(context)?.insert(_overlayEntry!);
        overlayController.sink.add(true);
        _handleBottomBarHeight(
          MainTabControlDelegate.getInstance().currentTabName(),
          onBottomBar: true,
        );
      });
    });
  }

  @override
  void dispose() {
    EasyDebounce.cancel(_tag);
    // This will make the FluxBuilder App run without errors
    // Because OverlayEntry close after this State dispose
    // overlayController.close();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _handleBottomBarHeight(String? screenName, {bool onBottomBar = false}) {
    var routeName = screenName;
    if (screenName == RouteList.dashboard || onBottomBar) {
      bottomBarHeight = kBottomNavigationBarHeight - 15;
      if (screenName == RouteList.dashboard) {
        final currentTabName =
            MainTabControlDelegate.getInstance().currentTabName();
        routeName = currentTabName;
      }
    } else {
      bottomBarHeight = 20;
    }

    printLog('[ScreenName] $routeName');
    final uri = Uri.parse(routeName ?? '');
    handleAd(uri.path);
    handleSmartChat(uri.path);
    overlayController.sink.add(true);

    /// disable cause to cash 🔥🔥🔥
    // if (!Config().isBuilder) {
    // _overlayEntry!.markNeedsBuild();
    // }
  }

  OverlayEntry _buildOverlayEntry() {
    return OverlayEntry(
      builder: (_) {
        return StreamBuilder<bool>(
            stream: overlayController.stream,
            builder: (context, snapshot) {
              if (snapshot.data == false) return const SizedBox();
              return Positioned(
                bottom: bottomBarHeight + MediaQuery.of(_).padding.bottom,
                left: 0,
                right: 0,
                child: Material(
                  type: MaterialType.transparency,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildSmartChatWidget(),
                      if (!Config().isBuilder) buildListBannerAd(),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  @override
  AdvertisementConfig? get advertisement =>
      Provider.of<AppModel>(context, listen: false).advertisement;
}
