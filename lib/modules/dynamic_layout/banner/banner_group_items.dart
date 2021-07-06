import 'package:flutter/material.dart';

import '../config/banner_config.dart';
import '../header/header_text.dart';
import '../helper/helper.dart';
import 'banner_items.dart';

/// The Banner Group type to display the image as multi columns
class BannerGroupItems extends StatelessWidget {
  final BannerConfig config;
  final onTap;

  const BannerGroupItems({required this.config, required this.onTap, Key? key})
      : super(key: key);

  double? bannerPercent(context, width) {
    final screenSize = MediaQuery.of(context).size;
    return Helper.formatDouble(
        config.height ?? 0.5 / (screenSize.height / width));
  }

  @override
  Widget build(BuildContext context) {
    List items = config.items;
    final screenSize = MediaQuery.of(context).size;

    final boxFit = config.fit;
    var headerHeight = 0.0;
    // var headerHeight = config.title != null
    //     ? config.title['height']  +
    //         (config['title']['marginTop'] ?? 0) +
    //         (config['title']['marginBottom'] ?? 0) +
    //         30
    //     : 0.0;

    return LayoutBuilder(builder: (context, constraint) {
      var _bannerPercent = bannerPercent(context, constraint.maxWidth)!;
      var height = screenSize.height * _bannerPercent;
      return Container(
        color: Theme.of(context).backgroundColor,
        height: height + headerHeight,
        margin: EdgeInsets.only(
          left: config.marginLeft,
          right: config.marginRight,
          top: config.marginTop,
          bottom: config.marginBottom,
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              if (config.title != null) HeaderText(config: config.title!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  for (int i = 0; i < items.length; i++)
                    Expanded(
                      child: BannerImageItem(
                        config: items[i],
                        boxFit: boxFit,
                        height: height,
                        onTap: onTap,
                        padding: config.padding,
                        radius: config.radius,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
