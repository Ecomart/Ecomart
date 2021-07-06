import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/config.dart' as config;
import '../../generated/l10n.dart';
import '../../services/services.dart';
import '../../widgets/common/fab_circle_menu.dart';
import '../chat/chat_screen.dart';

class SmartChat extends StatefulWidget {
  final EdgeInsets? margin;
  final List<Map>? options;

  SmartChat({this.margin, this.options});

  @override
  _SmartChatState createState() => _SmartChatState();
}

class _SmartChatState extends State<SmartChat> with WidgetsBindingObserver {
  List<Map> get options => widget.options ?? config.smartChat;
  late bool canLaunchAppURL;

  @override
  void initState() {
    super.initState();
    // With this, we will be able to check if the permission is granted or not
    // when returning to the application
    WidgetsBinding.instance!.addObserver(this);
  }

  IconButton getIconButton(
      IconData? iconData, double iconSize, Color iconColor, String? appUrl) {
    return IconButton(
      icon: Icon(
        iconData,
        size: iconSize,
        color: iconColor,
      ),
      onPressed: () async {
        if (await canLaunch(appUrl!)) {
          if (appUrl.contains('http') && !appUrl.contains('wa.me')) {
            _openChat(appUrl);
          } else {
            await launch(appUrl);
          }
          setState(() {
            setState(() {
              canLaunchAppURL = true;
            });
          });
        } else {
          setState(() {
            canLaunchAppURL = false;
          });
        }
        if (!canLaunchAppURL) {
          final snackBar = SnackBar(
            content: Text(
              S.of(context).canNotLaunch,
            ),
            action: SnackBarAction(
              label: S.of(context).undo,
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

  void _openChat(String? url) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => WebviewScaffold(
          withJavascript: true,
          appCacheEnabled: true,
          resizeToAvoidBottomInset: true,
          url: url!,
          appBar: AppBar(
            title: Text(S.of(context).message),
            centerTitle: true,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            elevation: 0.0,
          ),
          withZoom: true,
          withLocalStorage: true,
          // hidden: true causes WebView stuck at kLoadingWidget
          hidden: false,
          initialChild: Container(child: config.kLoadingWidget(context)),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  List<Widget> getFabIconButton() {
    var listWidget = <Widget>[];

    for (var i = 0; i < options.length; i++) {
      switch (options[i]['app']) {
        case 'firebase':
          if (Services().firebase.isEnabled) {
            listWidget.add(
              IconButton(
                  icon: Icon(
                    options[i]['iconData'],
                    size: 35,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatScreen()));
                  }),
            );
          }

          continue;
        default:
          listWidget.add(
            getIconButton(
              options[i]['iconData'],
              35,
              Theme.of(context).primaryColorLight,
              options[i]['app'],
            ),
          );
      }
    }

    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var list = getFabIconButton();
    if (list.isEmpty) return Container();

    return Container(
      width: screenSize.width,
      height: screenSize.height,
      child: FabCircularMenu(
        fabOpenIcon: const Icon(Icons.chat, color: Colors.white),
        ringColor: Theme.of(context).primaryColor,
        ringWidth: 100.0,
        ringDiameter: 250.0,
        fabMargin: widget.margin ?? const EdgeInsets.only(bottom: 0),
        options: list,
        child: Container(),
      ),
    );
  }
}
