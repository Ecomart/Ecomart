import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:inspireui/inspireui.dart'
    show EventDrawerSettings, EventNavigatorTabbar, eventBus, printLog;
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../app.dart';
import '../common/constants.dart';
import '../common/tools.dart';
import '../generated/l10n.dart';
import '../models/app_model.dart';
import '../models/index.dart';
import '../modules/dynamic_layout/index.dart';
import '../routes/route.dart';
import '../screens/index.dart' show NotificationScreen;
import '../widgets/overlay/custom_overlay_state.dart';
import 'main_layout.dart';
import 'maintab_delegate.dart';
import 'sidebar.dart';

const int turnsToRotateRight = 1;
const int turnsToRotateLeft = 3;

/// Include the setting fore main TabBar menu and Side menu
class MainTabs extends StatefulWidget {
  MainTabs({Key? key}) : super(key: key);

  @override
  MainTabsState createState() => MainTabsState();
}

class MainTabsState extends CustomOverlayState<MainTabs>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  /// check Desktop screen and app Setting variable
  bool get isDesktopDisplay => isDisplayDesktop(context);
  AppSetting get appSetting =>
      Provider.of<AppModel>(context, listen: true).appConfig!.settings;

  /// Navigation variable
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey(debugLabel: 'Dashboard');
  final navigators = <int, GlobalKey<NavigatorState>>{};

  /// TabBar variable
  late TabController tabController;
  final List<Widget> _tabView = [];
  Map saveIndexTab = {};
  int currentTabIndex = 0;
  List<TabBarMenuConfig> get tabData =>
      Provider.of<AppModel>(context, listen: false).appConfig!.tabBar;

  /// Drawer variable
  bool isShowCustomDrawer = false;
  StreamSubscription? _subOpenNativeDrawer;
  StreamSubscription? _subCloseNativeDrawer;
  StreamSubscription? _subOpenCustomDrawer;
  StreamSubscription? _subCloseCustomDrawer;

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    _initListenEvent();
    _initTabDelegate();
    _initTabData(context);
  }

  /// init the Event Bus listening
  void _initListenEvent() {
    _subOpenNativeDrawer = eventBus.on<EventOpenNativeDrawer>().listen((event) {
      if (!_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.openDrawer();
      }
    });
    eventBus.on<EventDrawerSettings>().listen((event) {
      if (!_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.openDrawer();
      }
    });
    _subCloseNativeDrawer =
        eventBus.on<EventCloseNativeDrawer>().listen((event) {
      if (_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.openEndDrawer();
      }
    });
    _subOpenCustomDrawer = eventBus.on<EventOpenCustomDrawer>().listen((event) {
      setState(() {
        isShowCustomDrawer = true;
      });
    });
    _subCloseCustomDrawer =
        eventBus.on<EventCloseCustomDrawer>().listen((event) {
      setState(() {
        isShowCustomDrawer = false;
      });
    });
  }

  /// Check pop navigator on the Current tab, and show Confirm Exit App
  Future<bool> _handleWillPopScopeRoot() {
    final currentNavigator = navigators[tabController.index]!;
    if (currentNavigator.currentState!.canPop()) {
      currentNavigator.currentState!.pop();
      return Future.value(false);
    }

    /// Check pop root navigator
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return Future.value(false);
    }

    if (tabController.index != 0) {
      tabController.animateTo(0);
      return Future.value(false);
    } else {
      return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(S.of(context).areYouSure),
              content: Text(S.of(context).doYouWantToExitApp),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(S.of(context).no),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(S.of(context).yes),
                ),
              ],
            ),
          ) as Future<bool>? ??
          false as Future<bool>;
    }
  }

  @override
  void didChangeDependencies() {
    isShowCustomDrawer = isDesktopDisplay;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tabController.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    _subOpenNativeDrawer?.cancel();
    _subCloseNativeDrawer?.cancel();
    _subOpenCustomDrawer?.cancel();
    _subCloseCustomDrawer?.cancel();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Handle the DeepLink notification
    if (state == AppLifecycleState.paused) {
      // went to Background
    }
    if (state == AppLifecycleState.resumed) {
      // came back to Foreground
      final appModel = Provider.of<AppModel>(context, listen: false);
      if (appModel.deeplink?.isNotEmpty ?? false) {
        if (appModel.deeplink!['screen'] == 'NotificationScreen') {
          appModel.deeplink = null;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationScreen()),
          );
        }
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    //customTabBar();
    final media = MediaQuery.of(context);
    final showFloating = appSetting.tabBarConfig.showFloating;
    final isClip = appSetting.tabBarConfig.showFloatingClip;

    printLog('[TabBar] ============== tabbar.dart ==============');
    printLog('[ScreenSize]: ${media.size.width} x ${media.size.height}');

    if (_tabView.isEmpty) {
      return Container(
        color: Colors.white,
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        key: _scaffoldKey,
        // Disable opening the drawer with a swipe gesture.
        drawerEnableOpenDragGesture: false,
        resizeToAvoidBottomInset: false,
        backgroundColor:
            showFloating ? null : Theme.of(context).backgroundColor,
        body: CupertinoTheme(
          data: CupertinoThemeData(
            primaryColor: Theme.of(context).accentColor,
            barBackgroundColor: Theme.of(context).backgroundColor,
            textTheme: CupertinoTextThemeData(
              navTitleTextStyle: Theme.of(context).textTheme.headline5,
              navLargeTitleTextStyle:
                  Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
            ),
          ),
          child: WillPopScope(
            onWillPop: _handleWillPopScopeRoot,
            child: MainLayout(
              menu: SideBarMenu(),
              content: MediaQuery(
                data: isDesktopDisplay
                    ? media.copyWith(
                        size: Size(
                        media.size.width - kSizeLeftMenu,
                        media.size.height,
                      ))
                    : media,
                child: ChangeNotifierProvider.value(
                  value: tabController,
                  child: Consumer<TabController>(
                      builder: (context, controller, child) {
                    /// use for responsive web/mobile
                    return Stack(
                      fit: StackFit.expand,
                      children: List.generate(
                        _tabView.length,
                        (index) {
                          final active = controller.index == index;
                          return Offstage(
                            offstage: !active,
                            child: TickerMode(
                              enabled: active,
                              child: _tabView[index],
                            ),
                          );
                        },
                      ).toList(),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
        drawer: isDesktopDisplay ? null : Drawer(child: SideBarMenu()),
        bottomNavigationBar: showFloating
            ? BottomAppBar(
                shape: isClip ? const CircularNotchedRectangle() : null,
                child: TabBarMenu(),
              )
            : TabBarMenu(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: showFloating ? TabBarMenuAction() : null,
      ),
    );
  }
}

extension TabBarMenuExtention on MainTabsState {
  /// on change tabBar name
  void _onChangeTab(String? nameTab) {
    if (saveIndexTab[nameTab] != null) {
      tabController.animateTo(saveIndexTab[nameTab]);
    } else {
      Navigator.of(App.fluxStoreNavigatorKey.currentContext!)
          .pushNamed('$nameTab');
    }
  }

  /// init Tab Delegate to use for SmartChat & Ads feature
  void _initTabDelegate() {
    var tabDelegate = MainTabControlDelegate.getInstance();
    tabDelegate.changeTab = _onChangeTab;
    tabDelegate.tabKey = () => navigators[tabController.index];
    tabDelegate.currentTabName = () => saveIndexTab.entries
        .firstWhereOrNull((element) => element.value == currentTabIndex)!
        .key;
    tabDelegate.tabAnimateTo = (int index) {
      tabController.animateTo(index);
    };
    WidgetsBinding.instance!.addObserver(this);
  }

  /// init the tabView data and tabController
  void _initTabData(context) {
    for (var i = 0; i < tabData.length; i++) {
      var _dataOfTab = tabData[i];
      saveIndexTab[_dataOfTab.layout] = i;
      navigators[i] = GlobalKey<NavigatorState>();
      final initialRoute = _dataOfTab.layout;
      _tabView.add(
        Navigator(
          key: navigators[i],
          initialRoute: initialRoute,
          observers: [
            MyRouteObserver(
              action: (screenName) =>
                  OverlayControlDelegate().emitTab?.call(screenName),
            ),
          ],
          onGenerateRoute: (RouteSettings settings) {
            if (settings.name == initialRoute) {
              return Routes.getRouteGenerate(RouteSettings(
                name: initialRoute,
                arguments: _dataOfTab,
              ));
            }
            return Routes.getRouteGenerate(settings);
          },
        ),
      );
    }
    // ignore: invalid_use_of_protected_member
    setState(() {
      tabController = TabController(length: _tabView.length, vsync: this);
    });
    if (MainTabControlDelegate.getInstance().index != null) {
      tabController.animateTo(MainTabControlDelegate.getInstance().index!);
    } else {
      MainTabControlDelegate.getInstance().index = 0;
    }

    /// Load the Design from FluxBuilder
    tabController.addListener(() {
      if (tabController.index == currentTabIndex) {
        eventBus.fire(EventNavigatorTabbar(tabController.index));
        MainTabControlDelegate.getInstance().index = tabController.index;
      }
    });
  }

  /// on tap on the TabBar icon
  void _onTapTabBar(index) {
    if (currentTabIndex == index) {
      navigators[tabController.index]!.currentState!.popUntil((r) => r.isFirst);
    }
    currentTabIndex = index;

    OverlayControlDelegate()
        .emitTab
        ?.call(MainTabControlDelegate.getInstance().currentTabName());

    Future.delayed(
      const Duration(milliseconds: 200),
      () => Tools.changeStatusBarColor(
          Provider.of<AppModel>(context, listen: false).themeMode),
    );

    if (!kIsWeb && !isDesktop) {
      if ('cart' == tabData[index].layout) {
        FlutterWebviewPlugin().show();
      } else {
        FlutterWebviewPlugin().hide();
      }
    }
  }

  /// return the tabBar widget
  Widget TabBarMenu() {
    final labelSize = tabData.any((element) => element.label != null) ? 8 : 0;
    var maxHeight = kBottomNavigationBarHeight -
        getValueForScreenType(
          context: context,
          mobile: 15,
          tablet: 5,
          desktop: 0,
        ) +
        labelSize;

    return TabBarCustom(
      onTap: _onTapTabBar,
      tabData: tabData,
      tabController: tabController,
      config: appSetting,
      maxHeight: maxHeight,
      isShowDrawer: isShowCustomDrawer,
      totalCart:
          Provider.of<CartModel>(context, listen: true).totalCartQuantity,
    );
  }

  /// Return the Tabbar Floating
  Widget TabBarMenuAction() {
    var itemIndex = (tabData.length / 2).floor();

    return IconFloatingAction(
      config: appSetting.tabBarConfig.tabBarFloating,
      item: tabData[itemIndex].jsonData,
      onTap: () {
        tabController.animateTo(itemIndex);
        _onTapTabBar(itemIndex);
      },
    );
  }

  void customTabBar() {
    /// Design TabBar style
    appSetting.tabBarConfig
      ..colorIcon = HexColor('7A7B7F')
      ..colorActiveIcon = HexColor('FF672D')
      ..indicatorStyle = 'None'
      ..showFloating = true
      ..showFloatingClip = false
      ..tabBarFloating = TabBarFloatingConfig(
        color: HexColor('FF672D'),
        // width: 65,
        // height: 40,
      );
  }

  /// custom the TabBar Style
  void customTabBar3() {
    /// Design TabBar style
    appSetting.tabBarConfig
      ..colorIcon = HexColor('7A7B7F')
      ..colorActiveIcon = HexColor('FF672D')
      ..indicatorStyle = 'None'
      ..showFloating = true
      ..showFloatingClip = false
      ..tabBarFloating = TabBarFloatingConfig(
        color: HexColor('FF672D'),
        width: 70,
        height: 70,
        elevation: 10.0,
        isDiamond: true,
        // width: 65,
        // height: 40,
      );
  }

  void customTabBar2() {
    /// Design TabBar style
    appSetting.tabBarConfig
      ..colorCart = HexColor('FE2060')
      ..colorIcon = HexColor('7A7B7F')
      ..colorActiveIcon = HexColor('1D34C5')
      ..indicatorStyle = 'Material'
      ..showFloating = true
      ..showFloatingClip = true
      ..tabBarFloating = TabBarFloatingConfig(
        color: HexColor('1D34C5'),
        elevation: 2.0,
      )
      ..tabBarIndicator = TabBarIndicatorConfig(
        color: HexColor('1D34C5'),
        verticalPadding: 10,
        tabPosition: TabPosition.top,
        topLeftRadius: 0,
        topRightRadius: 0,
        bottomLeftRadius: 10,
        bottomRightRadius: 10,
      );
  }

  void customTabBar1() {
    /// Design TabBar style 1
    appSetting.tabBarConfig
      ..color = HexColor('1C1D21')
      ..colorCart = HexColor('FE2060')
      ..isSafeArea = false
      ..marginBottom = 15.0
      ..marginLeft = 15.0
      ..marginRight = 15.0
      ..paddingTop = 12.0
      ..paddingBottom = 12.0
      ..radiusTopRight = 15.0
      ..radiusTopLeft = 15.0
      ..radiusBottomRight = 15.0
      ..radiusBottomLeft = 15.0
      ..paddingRight = 10.0
      ..indicatorStyle = 'Rectangular'
      ..tabBarIndicator = TabBarIndicatorConfig(
        color: HexColor('22262C'),
        topRightRadius: 9.0,
        topLeftRadius: 9.0,
        bottomLeftRadius: 9.0,
        bottomRightRadius: 9.0,
        distanceFromCenter: 10.0,
        horizontalPadding: 10.0,
      );
  }
}
