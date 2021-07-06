import 'package:flutter/material.dart';

const kColorTeal400 = Color(0xFF26A69A);
const kColorGrey900 = Color(0xFF263238);
const kColorGrey600 = Color(0xFF546E7A);

class HexColor extends Color {
  static int _getColorFromHex(String? hexColor) {
    hexColor = hexColor != null
        ? hexColor.toUpperCase().replaceAll('#', '')
        : 'FFFFFF';
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String? hexColor) : super(_getColorFromHex(hexColor));

  // ignore: prefer_constructors_over_static_methods
  static HexColor? fromJson(String json) {
    // ignore: unnecessary_null_comparison
    return json != null ? HexColor(json) : null;
  }

  static List<HexColor> fromListJson(List listJson) =>
      // ignore: avoid_as
      listJson.map((e) => HexColor.fromJson(e as String)) as List<HexColor>;

  String toJson() => super.value.toRadixString(16);
}
