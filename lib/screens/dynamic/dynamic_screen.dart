import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/app_model.dart';
import '../../modules/dynamic_layout/background/background.dart';
import '../../widgets/home/index.dart';
import '../../widgets/home/preview_reload.dart';
import '../../widgets/home/wrap_status_bar.dart';
import '../base_screen.dart';

class DynamicScreen extends StatefulWidget {
  final String? previewKey;
  final configs;

  const DynamicScreen({this.configs, this.previewKey});

  @override
  State<StatefulWidget> createState() {
    return DynamicScreenState();
  }
}

class DynamicScreenState extends BaseScreen<DynamicScreen>
    with AutomaticKeepAliveClientMixin<DynamicScreen> {
  static BuildContext? homeContext;

  static late BuildContext loadingContext;

  @override
  bool get wantKeepAlive => true;

  StreamSubscription? _sub;
  int? itemId;

  @override
  void dispose() {
    printLog('[Home] dispose');
    _sub?.cancel();
    super.dispose();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    Future.delayed(
        const Duration(seconds: 1),
        () => Tools.changeStatusBarColor(
            Provider.of<AppModel>(context, listen: false).themeMode));

    homeContext = context;
  }

  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        loadingContext = context;
        return Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(5.0)),
            padding: const EdgeInsets.all(50.0),
            child: kLoadingWidget(context),
          ),
        );
      },
    );
  }

  static void hideLoading() {
    Navigator.of(loadingContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    printLog('[Dynamic Screen] build');
    return Consumer<AppModel>(
      builder: (context, value, child) {
        if (value.appConfig == null) {
          return kLoadingWidget(context);
        }

        return PreviewReload(
          isDynamic: true,
          previewKey: widget.previewKey,
          configs: widget.configs,
          builder: (configs) {
            var isStickyHeader = value.appConfig!.settings.stickyHeader;

            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: Stack(
                children: <Widget>[
                  if (configs['Background'] != null)
                    isStickyHeader
                        ? SafeArea(
                            child: HomeBackground(
                              config: configs['Background'],
                            ),
                          )
                        : HomeBackground(config: configs['Background']),
                  HomeLayout(
                    isPinAppBar: isStickyHeader,
                    isShowAppbar:
                        configs['HorizonLayout'][0]['layout'] == 'logo',
                    configs: configs,
                    key: Key(value.langCode!),
                  ),
                  const WrapStatusBar(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
