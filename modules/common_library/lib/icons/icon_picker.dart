import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

IconData? iconPicker(String name, String fontFamily) {
  IconPack iconPack;
  switch (fontFamily) {
    case 'CupertinoIcons':
      iconPack = IconPack.cupertino;
      break;
    case 'FontAwesomeBrands':
      iconPack = IconPack.fontAwesomeIcons;
      break;
    case 'LineAwesomeIcons':
      iconPack = IconPack.lineAwesomeIcons;
      break;
    default:
      iconPack = IconPack.material;
  }

  return IconManager.getSelectedPack(iconPack)[name];
}

String iconPickerName(IconData icon) {
  IconPack iconPack;
  switch (icon.fontFamily) {
    case 'CupertinoIcons':
      iconPack = IconPack.cupertino;
      break;
    case 'FontAwesomeBrands':
      iconPack = IconPack.fontAwesomeIcons;
      break;
    case 'LineAwesomeIcons':
      iconPack = IconPack.lineAwesomeIcons;
      break;
    default:
      iconPack = IconPack.material;
  }
  final icons = IconManager.getSelectedPack(iconPack);
  for (final item in icons.keys.toList()) {
    if (icons[item]!.codePoint == icon.codePoint) {
      return item;
    }
  }
  return icons.keys.first;
}
