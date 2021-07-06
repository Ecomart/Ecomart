import 'package:inspireui/utils/colors.dart';

import '../helper/helper.dart';
import 'box_shadow_config.dart';
import 'tab_bar_floating_config.dart';
import 'tab_bar_indicator_config.dart';

/// isSafeArea : true
/// color : ''
/// radiusTopLeft : 0.0
/// radiusTopRight : 0.0
/// radiusBottomLeft : 0.0
/// radiusBottomRight : 0.0
/// paddingLeft : 0.0
/// paddingRight : 0.0
/// paddingBottom : 0.0
/// paddingTop : 0.0
/// marginTop : 0.0
/// marginBottom : 0.0
/// marginLeft : 0.0
/// marginRight : 0.0
/// boxShadow : {'blurRadius':10.0,'colorOpacity':0.1,'spreadRadius':10.0,'x':0,'y':0}
/// TabBarIndicator : {'indicatorSize':'label','indicatorColor':'','unselectedLabelColor':''}
/// TabBarCenter : {'position':0,'radius':0.0,'color':'','marginTop':0.0,'marginBottom':0.0,'marginLeft':0.0,'marginRight':0.0,'boxShadow':{'blurRadius':10.0,'colorOpacity':0.1,'spreadRadius':10.0,'x':0,'y':0}}

class TabBarConfig {
  bool isSafeArea = true;
  bool showFloating = false;
  bool showFloatingClip = true;

  double radiusTopLeft = 0.0;
  double radiusTopRight = 0.0;
  double radiusBottomLeft = 0.0;
  double radiusBottomRight = 0.0;
  double paddingLeft = 0.0;
  double paddingRight = 0.0;
  double paddingBottom = 0.0;
  double paddingTop = 0.0;
  double marginTop = 0.0;
  double marginBottom = 0.0;
  double marginLeft = 0.0;
  double marginRight = 0.0;
  double iconSize = 22.0;

  TabBarIndicatorConfig tabBarIndicator = TabBarIndicatorConfig();
  TabBarFloatingConfig tabBarFloating = TabBarFloatingConfig();
  String? indicatorStyle;
  BoxShadowConfig? boxShadow;

  /// Color icon
  HexColor? color;
  HexColor? colorCart;
  HexColor? colorIcon;
  HexColor? colorActiveIcon;

  TabBarConfig({
    this.isSafeArea = true,
    this.showFloating = false,
    this.showFloatingClip = true,
    this.color,
    this.colorCart,
    this.colorIcon,
    this.colorActiveIcon,
    this.iconSize = 22.0,
    this.radiusTopLeft = 0.0,
    this.radiusTopRight = 0.0,
    this.radiusBottomLeft = 0.0,
    this.radiusBottomRight = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.paddingBottom = 0.0,
    this.paddingTop = 0.0,
    this.marginTop = 0.0,
    this.marginBottom = 0.0,
    this.marginLeft = 0.0,
    this.marginRight = 0.0,
    this.boxShadow,
    this.indicatorStyle,
    required this.tabBarFloating,
    required this.tabBarIndicator,
  });

  TabBarConfig.fromJson(dynamic json) {
    isSafeArea = json['isSafeArea'] ?? true;
    showFloating = json['showFloating'] ?? false;
    showFloating = json['showFloatingClip'] ?? true;

    isSafeArea = json['indicatorStyle'] ?? true;
    if (json['color'] != null) {
      color = HexColor(json['color']);
    }

    if (json['colorCart'] != null) {
      colorCart = HexColor(json['colorCart']);
    }

    if (json['colorIcon'] != null) {
      colorIcon = HexColor(json['colorIcon']);
    }

    if (json['colorActiveIcon'] != null) {
      colorActiveIcon = HexColor(json['colorActiveIcon']);
    }

    iconSize = Helper.formatDouble(json['iconSize']) ?? 22.0;
    radiusTopLeft = Helper.formatDouble(json['radiusTopLeft']) ?? 0.0;
    radiusTopRight = Helper.formatDouble(json['radiusTopRight']) ?? 0.0;
    radiusBottomLeft = Helper.formatDouble(json['radiusBottomLeft']) ?? 0.0;
    radiusBottomRight = Helper.formatDouble(json['radiusBottomRight']) ?? 0.0;

    paddingLeft = Helper.formatDouble(json['paddingLeft']) ?? 0.0;
    paddingRight = Helper.formatDouble(json['paddingRight']) ?? 0.0;
    paddingBottom = Helper.formatDouble(json['paddingBottom']) ?? 0.0;
    paddingTop = Helper.formatDouble(json['paddingTop']) ?? 0.0;

    marginTop = Helper.formatDouble(json['marginTop']) ?? 0.0;
    marginBottom = Helper.formatDouble(json['marginBottom']) ?? 0.0;
    marginLeft = Helper.formatDouble(json['marginLeft']) ?? 0.0;
    marginRight = Helper.formatDouble(json['marginRight']) ?? 0.0;

    boxShadow = json['boxShadow'] != null
        ? BoxShadowConfig.fromJson(json['boxShadow'])
        : null;

    if (json['TabBarIndicator'] != null) {
      tabBarIndicator = TabBarIndicatorConfig.fromJson(json['TabBarIndicator']);
    }

    tabBarFloating = TabBarFloatingConfig.fromJson(json['TabBarCenter']);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['isSafeArea'] = isSafeArea;
    map['color'] = color;

    map['radiusTopLeft'] = radiusTopLeft;
    map['radiusTopRight'] = radiusTopRight;
    map['radiusBottomLeft'] = radiusBottomLeft;
    map['radiusBottomRight'] = radiusBottomRight;
    map['paddingLeft'] = paddingLeft;
    map['paddingRight'] = paddingRight;
    map['paddingBottom'] = paddingBottom;
    map['paddingTop'] = paddingTop;
    map['marginTop'] = marginTop;
    map['marginBottom'] = marginBottom;
    map['marginLeft'] = marginLeft;
    map['marginRight'] = marginRight;
    if (boxShadow != null) {
      map['boxShadow'] = boxShadow?.toJson();
    }
    map['TabBarIndicator'] = tabBarIndicator.toJson();
    map['TabBarFloating'] = tabBarFloating.toJson();
    return map;
  }

  @override
  String toString() {
    return '♻️ TabBarConfig:: '
        'isSafeArea:$isSafeArea, '
        'color:$color, '
        'radiusTopLeft:$radiusTopLeft, '
        'radiusTopRight:$radiusTopRight, '
        'radiusBottomLeft:$radiusBottomLeft, '
        'radiusBottomLeft:$radiusBottomLeft, '
        'paddingLeft:$paddingLeft, '
        'paddingRight:$paddingRight, '
        'paddingBottom:$paddingBottom, '
        'paddingTop:$paddingTop, '
        'marginTop:$marginTop, '
        'marginBottom:$marginBottom, '
        'marginLeft:$marginLeft, '
        'marginRight:$marginRight, '
        'boxShadow:$boxShadow, '
        'indicatorStyle:$indicatorStyle, '
        'tabBarFloating:$tabBarFloating, '
        'tabBarFloating:$tabBarFloating, '
        'showFloating:$showFloating';
  }
}
