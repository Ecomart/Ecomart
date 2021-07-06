import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show AppModel, Category, CategoryModel;
import '../../widgets/cardlist/index.dart';
import 'layouts/card.dart';
import 'layouts/column.dart';
import 'layouts/grid.dart';
import 'layouts/side_menu.dart';
import 'layouts/side_menu_with_sub.dart';
import 'layouts/sub.dart';

class CategoriesScreen extends StatefulWidget {
  final bool showSearch;

  CategoriesScreen({
    Key? key,
    this.showSearch = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CategoriesScreenState();
  }
}

class CategoriesScreenState extends State<CategoriesScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late FocusNode _focus;
  bool isVisibleSearch = false;
  String? searchText;
  var textController = TextEditingController();

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween<double>(begin: 0, end: 60).animate(controller);
    animation.addListener(() {
      setState(() {});
    });

    _focus = FocusNode();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focus.hasFocus && animation.value == 0) {
      controller.forward();
      setState(() {
        isVisibleSearch = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final category = Provider.of<CategoryModel>(context);
    final appModel = Provider.of<AppModel>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListenableProvider.value(
        value: category,
        child: Consumer<CategoryModel>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return kLoadingWidget(context);
            }

            if (value.categories == null) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: Text(S.of(context).dataEmpty),
              );
            }

            var categories = value.categories;

            return SafeArea(
              bottom: false,
              child: [
                GridCategory.type,
                ColumnCategories.type,
                SideMenuCategories.type,
                SubCategories.type,
                SideMenuSubCategories.type
              ].contains(appModel.categoryLayout)
                  ? Column(
                      children: <Widget>[
                        renderHeader(),
                        Expanded(
                          child: renderCategories(categories, appModel.categoryLayout),
                        )
                      ],
                    )
                  : ListView(
                      children: <Widget>[
                        renderHeader(),
                        renderCategories(categories, appModel.categoryLayout)
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget renderHeader() {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Container(
          width:
              screenSize.width / (2 / (screenSize.height / screenSize.width)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, bottom: 20, right: 10),
                child: Text(
                  S.of(context).category,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (widget.showSearch)
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).accentColor.withOpacity(0.6),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteList.categorySearch);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderCategories(List<Category>? categories, String layout) {
    switch (layout) {
      case CardCategories.type:
        return CardCategories(categories);
      case ColumnCategories.type:
        return ColumnCategories(categories);
      case SubCategories.type:
        return SubCategories(categories);
      case SideMenuCategories.type:
        return SideMenuCategories(categories);
      case SideMenuSubCategories.type:
        return SideMenuSubCategories(categories);
      case HorizonMenu.type:
        return HorizonMenu(categories);
      case GridCategory.type:
        return GridCategory(categories);
      default:
        return HorizonMenu(categories);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
