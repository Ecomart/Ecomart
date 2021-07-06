import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/header_config.dart';
import '../helper/helper.dart';

class HeaderSearch extends StatelessWidget {
  final HeaderConfig config;
  final Function? onSearch;

  const HeaderSearch({required this.config, this.onSearch, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = config.text ?? '';
    var showShadow = config.showShadow ?? false;

    return Container(
      padding: EdgeInsets.all(Helper.formatDouble(config.padding ?? 20.0)!),
      margin: EdgeInsets.only(
        top: Helper.formatDouble(config.marginTop ?? 10.0)!,
        left: Helper.formatDouble(config.marginLeft ?? 10.0)!,
        right: Helper.formatDouble(config.marginRight ?? 10.0)!,
        bottom: Helper.formatDouble(config.marginBottom ?? 10.0)!,
      ),
      height: Helper.formatDouble(config.height ?? 85.0),
      child: SafeArea(
        bottom: false,
        top: config.isSafeArea == true,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            Helper.formatDouble(config.radius ?? 30.0)!,
          ),
          onTap: () => onSearch!(),
          child: Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            decoration: BoxDecoration(
              color: config.backgroundInput ?? true
                  ? Theme.of(context).backgroundColor
                  : Theme.of(context).primaryColorLight,
              boxShadow: [
                /// New BoxShadow config via Flutter
                if (config.boxShadow != null && showShadow)
                  BoxShadow(
                    blurRadius: config.boxShadow!.blurRadius,
                    color: Theme.of(context)
                        .accentColor
                        .withOpacity(config.boxShadow!.colorOpacity),
                    spreadRadius:
                        Helper.formatDouble(config.boxShadow!.spreadRadius)!,
                    offset: Offset(
                      Helper.formatDouble(config.boxShadow!.x)!,
                      Helper.formatDouble(config.boxShadow!.y)!,
                    ),
                  )
              ],
              borderRadius: BorderRadius.circular(
                Helper.formatDouble(config.radius ?? 30.0)!,
              ),
              border: Border.all(
                width: 1.0,
                color: config.borderInput ?? true
                    ? Colors.black.withOpacity(0.05)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: <Widget>[
                const Icon(CupertinoIcons.search, size: 24),
                const SizedBox(
                  width: 12.0,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: Helper.formatDouble(config.fontSize),
                    color: Theme.of(context)
                        .accentColor
                        .withOpacity(Helper.formatDouble(config.textOpacity)!),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
