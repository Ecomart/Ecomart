import 'package:flutter/material.dart';

import '../config/header_config.dart';
import '../helper/helper.dart';
import 'header_type.dart';

class HeaderText extends StatelessWidget {
  final HeaderConfig config;
  final Function? onSearch;

  const HeaderText({required this.config, this.onSearch, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hideHeader = config.hideHeader;
    final screenSize = MediaQuery.of(context).size;
    var height = config.height ?? 0.3;

    /// using percent if the height above 1, otherwise using pixel
    height = height < 1 ? height * screenSize.height : height;

    if (!hideHeader) {
      return Container(
        height: height,
        margin: EdgeInsets.only(
          top: Helper.formatDouble(config.marginTop ?? 20.0)!,
          left: Helper.formatDouble(config.marginLeft ?? 20.0)!,
          right: Helper.formatDouble(config.marginRight ?? 15.0)!,
          bottom: Helper.formatDouble(config.marginBottom ?? 10.0)!,
        ),
        child: SafeArea(
          bottom: false,
          top: config.isSafeArea,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: HeaderType(config: config),
              ),
              if (config.showSearch == true)
                IconButton(
                  icon: const Icon(Icons.search),
                  iconSize: 24.0,
                  onPressed: () => onSearch!(),
                )
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
