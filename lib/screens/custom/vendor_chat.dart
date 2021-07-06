import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show Store, User;
import '../../services/services.dart';
import '../chat/chat_arguments.dart';
import 'smartchat.dart';

class VendorChat extends StatefulWidget {
  final Store? store;
  final User? user;

  VendorChat({this.store, this.user});

  @override
  _VendorChatState createState() => _VendorChatState();
}

class _VendorChatState extends State<VendorChat> {
  Store? get store => widget.store;

  User? get user => widget.user;

  late bool canLaunchAppURL;

  late List<Map> options;

  bool get showAdminChat => store == null || store?.phone == null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      options = getSmartChatOptions();
    });
  }

  List<Map> getSmartChatOptions() {
    final _options = [];
    if (showAdminChat) return Configurations.smartChat;
    if (isNotBlank(store!.email) && isNotBlank(store!.name) && user != null) {
      _options.add({
        'app': 'store',
        'description': S.of(context).chatWithStoreOwner,
        'iconData': FontAwesomeIcons.google,
      });
    }
    if (store!.socials != null && store!.socials!['facebook'] != null) {
      _options.add({
        'app': store!.socials!['facebook']!.contains('http')
            ? store!.socials!['facebook']
            : 'https://tawk.to/chat/${store!.socials!["facebook"]}/default',
        'description': S.of(context).chatViaFacebook,
        'iconData': FontAwesomeIcons.facebookMessenger
      });
    }
    if (isNotBlank(store!.phone)) {
      _options.add({
        'app': 'https://wa.me/${store!.phone}',
        'description': '${S.of(context).chatViaWhatApp} ${store!.phone}',
        'iconData': FontAwesomeIcons.whatsapp,
      });
      _options.add({
        'app': 'tel:${store!.phone}',
        'description': '${S.of(context).callTo} ${store!.phone}',
        'iconData': FontAwesomeIcons.phoneAlt,
      });
      _options.add({
        'app': 'sms://${store!.phone}',
        'description': '${S.of(context).messageTo}${store!.phone}',
        'iconData': FontAwesomeIcons.sms,
      });
    }
    return List<Map>.from(_options);
  }

  List<CupertinoActionSheetAction> getListAction(BuildContext popupContext) {
    var listWidget = <CupertinoActionSheetAction>[];

    for (var i = 0; i < options.length; i++) {
      switch (options[i]['app']) {
        case 'store':
          if (Services().firebase.isEnabled) {
            listWidget.add(
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.of(popupContext).pop();
                  await Future.delayed(
                      const Duration(milliseconds: 300), () {});
                  await Navigator.of(context).pushNamed(
                    RouteList.vendorChat,
                    arguments: ChatArguments(
                      senderUser: user,
                      receiverEmail: store!.chatEmail,
                      receiverName: store!.name,
                    ),
                  );
                },
                child: buildItemAction(options[i]),
              ),
            );
          }
          break;
        default:
          listWidget.add(
            buildActionSheetItem(options[i], popupContext),
          );
      }
    }

    return listWidget;
  }

  CupertinoActionSheetAction buildActionSheetItem(
      Map option, BuildContext popupContext) {
    final appUrl = option['app'];
    return CupertinoActionSheetAction(
      onPressed: () async {
        Navigator.of(popupContext).pop();
        await Future.delayed(const Duration(milliseconds: 300), () {});
        if (await canLaunch(appUrl)) {
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
      child: buildItemAction(option),
    );
  }

  Widget buildItemAction(Map option) {
    final iconData = option['iconData'];
    final description = option['description'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: 24,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            description,
            style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
          ),
        ),
      ],
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
          hidden: true,
          initialChild: Container(child: kLoadingWidget(context)),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showAdminChat) {
      return SmartChat();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: Theme.of(context).backgroundColor,
        onPressed: showActionSheet,
        child: Icon(
          CupertinoIcons.conversation_bubble,
          color: Theme.of(context).primaryColor,
          size: 32,
        ),
      ),
    );
  }

  void showActionSheet() {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (popupContext) => CupertinoActionSheet(
        actions: getListAction(popupContext),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Navigator.of(popupContext).pop,
          isDestructiveAction: true,
          child: Text(S.of(context).cancel),
        ),
      ),
    );
  }
}
