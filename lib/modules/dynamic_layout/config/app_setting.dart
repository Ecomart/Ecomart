import 'tab_bar_config.dart';
import 'tab_bar_floating_config.dart';
import 'tab_bar_indicator_config.dart';

var DefaultTabBar = TabBarConfig(
  tabBarIndicator: TabBarIndicatorConfig(),
  tabBarFloating: TabBarFloatingConfig(),
);

class AppSetting {
  late String mainColor;
  late String fontFamily;
  late String productListLayout;
  late bool stickyHeader;
  late bool showChat;
  TabBarConfig tabBarConfig = DefaultTabBar;
  double? ratioProductImage;
  late String? productDetail;

  AppSetting({
    this.mainColor = '#3FC1BE',
    this.fontFamily = 'Roboto',
    this.productListLayout = 'list',
    this.stickyHeader = false,
    this.showChat = true,
    this.ratioProductImage,
    this.productDetail,
    required this.tabBarConfig,
  });

  AppSetting.fromJson(Map config) {
    mainColor = config['MainColor'] ?? '#3FC1BE';
    fontFamily = config['FontFamily'] ?? 'Roboto';
    productListLayout = config['ProductListLayout'] ?? 'list';
    stickyHeader = config['StickyHeader'] ?? false;
    showChat = config['ShowChat'] ?? true;
    ratioProductImage = config['ratioProductImage'];
    productDetail = config['ProductDetail'];
    if (config['TabBarConfig'] != null) {
      tabBarConfig = TabBarConfig.fromJson(config['TabBarConfig']);
    }
  }

  AppSetting copyWith({
    String? mainColor,
    String? fontFamily,
    String? productListLayout,
    bool? stickyHeader,
    bool? showChat,
    double? ratioProductImage,
    String? productDetail,
    TabBarConfig? tabBarConfig,
  }) {
    return AppSetting(
      mainColor: mainColor ?? this.mainColor,
      fontFamily: fontFamily ?? this.fontFamily,
      productListLayout: productListLayout ?? this.productListLayout,
      stickyHeader: stickyHeader ?? this.stickyHeader,
      showChat: showChat ?? this.showChat,
      ratioProductImage: ratioProductImage ?? this.ratioProductImage,
      productDetail: productDetail ?? this.productDetail,
      tabBarConfig: tabBarConfig ?? this.tabBarConfig,
    );
  }
}
