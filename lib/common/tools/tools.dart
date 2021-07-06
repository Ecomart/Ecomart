import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/index.dart' show Config;
import '../config.dart';
import '../constants.dart' show isMobile, kIsWeb, printLog;

class Tools {
  static double? formatDouble(num? value) => value == null ? null : value * 1.0;

  static String formatDateString(String date) {
    var timeFormat = DateTime.parse(date);
    final timeDif = DateTime.now().difference(timeFormat);
    return timeago.format(DateTime.now().subtract(timeDif),
        locale: kAdvanceConfig['DefaultLanguage']);
  }

  /// check tablet screen
  static bool isTablet(MediaQueryData query) {
    if (Config().isBuilder) {
      return false;
    }

    if (kIsWeb) {
      return true;
    }

    if (UniversalPlatform.isWindows || UniversalPlatform.isMacOS) {
      return false;
    }

    var size = query.size;
    var diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    var isTablet = diagonal > 1100.0;
    return isTablet;
  }

  static Future<List<dynamic>> loadStatesByCountry(String country) async {
    try {
      // load local config
      var path = 'lib/config/states/state_${country.toLowerCase()}.json';
      final appJson = await rootBundle.loadString(path);
      return List<dynamic>.from(jsonDecode(appJson));
    } catch (e) {
      return [];
    }
  }

  static dynamic getValueByKey(Map<String, dynamic>? json, String? key) {
    if (key == null) return null;
    try {
      List keys = key.split('.');
      Map<String, dynamic>? data = Map<String, dynamic>.from(json!);
      if (keys[0] == '_links') {
        var links = json['listing_data']['_links'] ?? [];
        for (var item in links) {
          if (item['network'] == keys[keys.length - 1]) return item['url'];
        }
      }
      for (var i = 0; i < keys.length - 1; i++) {
        if (data![keys[i]] is Map) {
          data = data[keys[i]];
        } else {
          return null;
        }
      }
      if (data![keys[keys.length - 1]].toString().isEmpty) return null;
      return data[keys[keys.length - 1]];
    } catch (e) {
      printLog(e.toString());
      return 'Error when mapping $key';
    }
  }

  // ignore: always_declare_return_types
  static showSnackBar(ScaffoldState scaffoldState, message) {
    // ignore: deprecated_member_use
    scaffoldState.showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<void> launchURL(String? url) async {
    if (await canLaunch(url ?? '')) {
      await launch(url!);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void changeStatusBarColor(ThemeMode? themeMode,
      [final Color color = Colors.transparent]) {
    if (UniversalPlatform.isAndroid) {
      try {
        if (themeMode == ThemeMode.light) {
          FlutterStatusbarcolor.setNavigationBarColor(
            Colors.white,
            animate: true,
          );
          FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
          FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        } else {
          FlutterStatusbarcolor.setNavigationBarColor(Colors.transparent,
              animate: true);
          FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
          FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    } else if (UniversalPlatform.isIOS) {
      try {
        FlutterStatusbarcolor.setStatusBarColor(color, animate: false);
        if (useWhiteForeground(color)) {
          if (themeMode == ThemeMode.light) {
            FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
          } else {
            FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
          }
        } else {
          FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  static Future<dynamic> parseJsonFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath).then(jsonDecode);
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void initStatusBarColor() {
    if (isMobile) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

      FlutterStatusbarcolor.setNavigationBarColor(Colors.transparent);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    }
  }
}
