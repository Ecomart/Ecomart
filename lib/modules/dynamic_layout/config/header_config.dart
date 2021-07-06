import 'package:inspireui/utils/colors.dart';

import '../helper/helper.dart';
import 'box_shadow_config.dart';

/// backgroundInput : false
/// fontSize : 13
/// padding : 19
/// text : 'Header'
/// radius : 30
/// textOpacity : 1
/// marginRight : 9
/// marginBottom : 0
/// boxShadow : {'blurRadius':10.0,'colorOpacity':0.1,'spreadRadius':10.0,'x':0,'y':0}
/// layout : 'header_search'
/// marginLeft : 5
/// showShadow : true
/// borderInput : false
/// marginTop : 6
/// shadow : 10
/// height : 85

class HeaderConfig {
  /// type bool
  bool? backgroundInput;
  bool hideHeader = false;
  bool isSafeArea = false;
  bool showSearch = true;
  bool? showShadow;
  bool? borderInput;

  /// type String
  String? text;
  String title = '';
  String? type;
  String? layout;

  /// type int
  int? fontWeight;

  /// type double
  double fontSize = 20.0;
  double? padding;
  double? radius;
  double textOpacity = 1.0;
  double? marginRight;
  double? marginBottom;
  double? marginLeft;
  double? marginTop;
  double? shadow;
  double? height;

  /// other type
  BoxShadowConfig? boxShadow;
  List<String>? rotate;
  HexColor? textColor;

  HeaderConfig(
      {this.backgroundInput,
      this.hideHeader = false,
      this.isSafeArea = false,
      this.showSearch = true,
      this.fontSize = 20.0,
      this.padding,
      this.fontWeight,
      this.type,
      this.textColor,
      this.text,
      this.title = '',
      this.radius,
      this.textOpacity = 1.0,
      this.marginRight,
      this.marginBottom,
      this.boxShadow,
      this.layout,
      this.marginLeft,
      this.showShadow,
      this.borderInput,
      this.marginTop,
      this.shadow,
      this.rotate,
      this.height});

  HeaderConfig.fromJson(dynamic json) {
    backgroundInput = json['backgroundInput'];
    hideHeader = json['hideHeader'] ?? false;
    showSearch = json['showSearch'] ?? true;
    isSafeArea = json['isSafeArea'] ?? false;
    text = json['text'];
    title = json['title'] ?? '';
    type = json['type'];
    rotate = List<String>.from(json['rotate'] ?? []);
    boxShadow = json['boxShadow'] != null
        ? BoxShadowConfig.fromJson(json['boxShadow'])
        : null;
    layout = json['layout'];
    showShadow = json['showShadow'];
    borderInput = json['borderInput'];

    if (json['textColor'] != null) {
      textColor = HexColor(json['textColor']);
    }

    fontWeight = Helper.formatInt(json['fontWeight'], 400);

    textOpacity = Helper.formatDouble(json['textOpacity']) ?? 1.0;
    fontSize = Helper.formatDouble(json['fontSize']) ?? 20.0;
    padding = Helper.formatDouble(json['padding']) ?? 20.0;
    height = Helper.formatDouble(json['height']) ?? 80.0;
    radius = Helper.formatDouble(json['radius']);
    marginRight = Helper.formatDouble(json['marginRight']) ?? 5.0;
    marginLeft = Helper.formatDouble(json['marginLeft']) ?? 15.0;
    marginTop = Helper.formatDouble(json['marginTop']) ?? 15.0;
    marginBottom = Helper.formatDouble(json['marginBottom']) ?? 15.0;
    shadow = Helper.formatDouble(json['shadow']);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['backgroundInput'] = backgroundInput;
    map['fontSize'] = fontSize;
    map['padding'] = padding;
    map['text'] = text;
    map['radius'] = radius;
    map['textOpacity'] = textOpacity;
    map['marginRight'] = marginRight;
    map['marginBottom'] = marginBottom;
    if (boxShadow != null) {
      map['boxShadow'] = boxShadow?.toJson();
    }
    map['layout'] = layout;
    map['marginLeft'] = marginLeft;
    map['showShadow'] = showShadow;
    map['borderInput'] = borderInput;
    map['marginTop'] = marginTop;
    map['shadow'] = shadow;
    map['height'] = height;
    return map;
  }
}
