import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show FluxImage, iconPicker;

import '../config/app_config.dart';
import '../config/tab_bar_config.dart';
import '../helper/helper.dart';

class TabBarIcon extends StatelessWidget {
  final TabBarMenuConfig item;
  final int totalCart;
  final bool isEmptySpace;
  final bool isActive;
  final TabBarConfig config;

  const TabBarIcon({
    required Key key,
    required this.item,
    required this.totalCart,
    required this.isEmptySpace,
    required this.isActive,
    required this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEmptySpace) {
      return Container(
        width: 60,
        height: 2,
      );
    }

    Widget icon = Builder(
      builder: (_context) {
        var iconColor = IconTheme.of(_context).color;
        var isImage = item.icon.contains('/');
        return isImage
            ? FluxImage(
                imageUrl: item.icon,
                color: iconColor,
                width: config.iconSize,
              )
            : Icon(
                iconPicker(item.icon, item.fontFamily),
                color: iconColor,
                size: config.iconSize,
              );
      },
    );

    if (item.layout == 'cart') {
      icon = IconCart(icon: icon, totalCart: totalCart, config: config);
    }

    return Tab(
      text: item.label,
      iconMargin: EdgeInsets.zero,
      icon: icon,
    );
  }
}

class IconCart extends StatelessWidget {
  const IconCart({
    Key? key,
    required this.icon,
    required this.totalCart,
    required this.config,
  }) : super(key: key);

  final Widget icon;
  final int totalCart;
  final TabBarConfig config;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 30,
          height: 25,
          padding: const EdgeInsets.only(top: 4),
          child: icon,
        ),
        if (totalCart > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: config.colorCart ?? Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                totalCart.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Layout.isDisplayDesktop(context) ? 14 : 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
      ],
    );
  }
}
