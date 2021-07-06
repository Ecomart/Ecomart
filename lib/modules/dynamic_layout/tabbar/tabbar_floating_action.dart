import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show FluxImage, iconPicker;

import '../config/tab_bar_floating_config.dart';
import 'tab_indicator/diamond_border.dart';

class IconFloatingAction extends StatelessWidget {
  final TabBarFloatingConfig config;
  final Function? onTap;
  final Map item;

  const IconFloatingAction({
    Key? key,
    required this.onTap,
    required this.item,
    required this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget icon = Builder(
      builder: (_context) {
        var iconColor = Colors.white;
        var isImage = item['icon'].contains('/');
        return isImage
            ? FluxImage(imageUrl: item['icon'], color: iconColor, width: 24)
            : Icon(iconPicker(item['icon'], item['fontFamily']),
                color: iconColor, size: 22);
      },
    );

    return RawMaterialButton(
      elevation: config.elevation ?? 4.0,
      shape: config.isDiamond ?? false
          ? const DiamondBorder()
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(config.radius ?? 50.0),
            ),
      fillColor: config.color ?? Theme.of(context).primaryColor,
      onPressed: () => onTap!(),
      constraints: BoxConstraints.tightFor(
        width: config.width ?? 50.0,
        height: config.height ?? 50.0,
      ),
      child: icon,
    );
  }
}
