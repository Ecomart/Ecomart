import 'package:flutter/foundation.dart';

import '../config.dart' show kAdType;
import '../constants.dart' show awesomeIcon, kBlogLayout;

class ConfigurationUtils {
  static Map loadAdConfig(Map data) {
    final dataAdConfig = List.from([data]);
    if (data.isNotEmpty) {
      kAdType.values.forEach((e) {
        if (describeEnum(e) == dataAdConfig[0]['type']) {
          dataAdConfig[0]['type'] = e;
        }
      });
      return dataAdConfig[0];
    }
    return data;
  }

  static List<Map> loadSmartChat(List<Map> data) {
    var dataSmartChat = List<Map<String, dynamic>>.from(data);
    for (var i = 0; i < dataSmartChat.length; i++) {
      var newData = Map<String, dynamic>.from(dataSmartChat[i]);
      newData['iconData'] = awesomeIcon[newData['iconData']];
      dataSmartChat[i] = Map<String, dynamic>.from(newData);
    }
    return dataSmartChat;
  }

  static Map loadAdvanceConfig(Map? data) {
    final dataAdvance = List.from([data]);
    dataAdvance[0].update(
      'DetailedBlogLayout',
      (value) => kBlogLayout.values.firstWhere(
          (element) => describeEnum(element) == value,
          orElse: () => kBlogLayout.simpleType),
    );

    return dataAdvance[0];
  }
}
