part of '../config.dart';

/// Supported language
/// Download from https://github.com/hjnilsson/country-flags/tree/master/png100px
/// https://api.flutter.dev/flutter/flutter_localizations/GlobalMaterialLocalizations-class.html
List<Map<String, dynamic>> getLanguages([context]) {
  List listLang = List<Map<String, dynamic>>.from(Configurations.languagesInfo);
  if (context != null) {
    listLang.forEach((element) {
      return element.update(
          'name', (String nameLang) => getLanguageByContext(context, element['code']));
    });
  }
  return listLang as List<Map<String, dynamic>>;
}

/// For Vendor Admin
List<String> unsupportedLanguages = ['ku'];

String getLanguageByContext(BuildContext context, String code) {
  switch (code) {
    case 'en':
      return S.of(context).english;
    case 'zh':
      return S.of(context).chinese;
    case 'hi':
      return S.of(context).India;
    case 'es':
      return S.of(context).spanish;
    case 'fr':
      return S.of(context).french;
    case 'ar':
      return S.of(context).arabic;
    case 'ru':
      return S.of(context).russian;
    case 'id':
      return S.of(context).indonesian;
    case 'ja':
      return S.of(context).japanese;
    case 'kr':
      return S.of(context).Korean;
    case 'vi':
      return S.of(context).vietnamese;
    case 'ro':
      return S.of(context).romanian;
    case 'tr':
      return S.of(context).turkish;
    case 'it':
      return S.of(context).italian;
    case 'de':
      return S.of(context).german;
    case 'pt':
      return S.of(context).brazil;
    case 'hu':
      return S.of(context).hungary;
    case 'he':
      return S.of(context).hebrew;
    case 'th':
      return S.of(context).thailand;
    case 'nl':
      return S.of(context).Dutch;
    case 'sr':
      return S.of(context).serbian;
    case 'pl':
      return S.of(context).Polish;
    case 'fa':
      return S.of(context).persian;

    /// Stop support Kudish language due to some build issue and un-support from Flutter
    /// please refer to https://pub.dev/packages/kurdish_localization
    case 'ku':
      return S.of(context).kurdish;

    case 'bn':
      return S.of(context).bengali;
    case 'uk':
      return S.of(context).ukrainian;
    default:
      return code;
  }
}
