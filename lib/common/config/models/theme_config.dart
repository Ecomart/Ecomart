import '../../constants.dart';

class ThemeConfig {
  late String? mainColor;
  late String logo;

  ThemeConfig.fromJson(Map config) {
    logo = config['logo'] ?? kLogo;
    mainColor = config['MainColor'];
  }

  Map? toJson() {
    return {'MainColor': mainColor, 'logo': logo};
  }
}
