import 'package:inspireui/utils/colors.dart';

import '../helper/helper.dart';
import 'box_shadow_config.dart';

/// position : 0
/// radius : 0.0
/// color : ''
/// marginTop : 0.0
/// marginBottom : 0.0
/// marginLeft : 0.0
/// marginRight : 0.0
/// boxShadow : {'blurRadius':10.0,'colorOpacity':0.1,'spreadRadius':10.0,'x':0,'y':0}

class TabBarFloatingConfig {
  int? position;
  bool? isDiamond;

  HexColor? color;
  HexColor? tintColor;

  double? radius;
  double? marginTop;
  double? marginBottom;
  double? marginLeft;
  double? marginRight;
  double? elevation;

  double? width;
  double? height;

  BoxShadowConfig? boxShadow;

  TabBarFloatingConfig(
      {this.position,
      this.radius,
      this.isDiamond,
      this.color,
      this.tintColor,
      this.width,
      this.height,
      this.elevation,
      this.marginTop,
      this.marginBottom,
      this.marginLeft,
      this.marginRight,
      this.boxShadow});

  TabBarFloatingConfig.fromJson(dynamic json) {
    if (json['position'] != null) {
      position = Helper.formatInt(json['position'], 0);
    }

    if (json['color'] != null) {
      color = HexColor(json['color']);
    }

    if (json['tintColor'] != null) {
      color = HexColor(json['tintColor']);
    }

    isDiamond = json['isDiamond'] ?? false;
    radius = Helper.formatDouble(json['radius'], 50.0);
    width = Helper.formatDouble(json['width'], 50.0);
    height = Helper.formatDouble(json['height'], 50.0);
    elevation = Helper.formatDouble(json['elevation'], 2.0);
    marginTop = Helper.formatDouble(json['marginTop'], 0.0);
    marginBottom = Helper.formatDouble(json['marginBottom'], 0.0);
    marginLeft = Helper.formatDouble(json['marginLeft'], 0.0);
    marginRight = Helper.formatDouble(json['marginRight'], 0.0);

    boxShadow = json['boxShadow'] != null
        ? BoxShadowConfig.fromJson(json['boxShadow'])
        : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['position'] = position;
    map['radius'] = radius;
    map['color'] = color;
    map['marginTop'] = marginTop;
    map['marginBottom'] = marginBottom;
    map['marginLeft'] = marginLeft;
    map['marginRight'] = marginRight;
    if (boxShadow != null) {
      map['boxShadow'] = boxShadow?.toJson();
    }
    return map;
  }
}
