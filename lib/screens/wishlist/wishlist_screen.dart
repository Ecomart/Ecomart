import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../menu/index.dart' show MainTabControlDelegate;
import '../../models/index.dart' show CartModel, WishListModel;
import '../../widgets/product/product_bottom_sheet.dart';
import 'empty_wishlist.dart';

class WishListScreen extends StatefulWidget {
  WishListScreen();

  @override
  State<StatefulWidget> createState() {
    return WishListState();
  }
}

class WishListState extends State<WishListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _hideController;

  @override
  void initState() {
    super.initState();
    _hideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
              brightness: Theme.of(context).brightness,
              elevation: 0.5,
              title: Text(
                S.of(context).myWishList,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              backgroundColor: Theme.of(context).backgroundColor),
          body: ListenableProvider.value(
            value: Provider.of<WishListModel>(context, listen: false),
            child: Consumer<WishListModel>(
              builder: (context, model, child) {
                if (model.products.isEmpty) {
                  return EmptyWishlist(
                    onShowHome: () {
                      MainTabControlDelegate.getInstance().changeTab('home');
                    },
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Text(
                            '${model.products.length} ' + S.of(context).items,
                            style:
                                const TextStyle(fontSize: 14, color: kGrey400)),
                      ),
                      const Divider(height: 1, color: kGrey200),
                      const SizedBox(height: 15),
                      Expanded(
                        child: ListView.builder(
                          itemCount: model.products.length,
                          itemBuilder: (context, index) {
                            return WishlistItem(
                              product: model.products[index],
                              onRemove: () {
                                Provider.of<WishListModel>(context,
                                        listen: false)
                                    .removeToWishlist(model.products[index]);
                              },
                              onAddToCart: () {
                                if (model.products[index].isPurchased &&
                                    model.products[index].isDownloadable!) {
                                  Share.share(model.products[index].files![0]!);
                                  return;
                                }
                                var msg = Provider.of<CartModel>(context,
                                        listen: false)
                                    .addProductToCart(
                                  context: context,
                                  product: model.products[index],
                                  quantity: 1,
                                );
                                if (msg.isEmpty) {
                                  msg =
                                      '${model.products[index].name} ${S.of(context).addToCartSucessfully}';
                                }
                                Tools.showSnackBar(Scaffold.of(context), msg);
                              },
                            );
                          },
                        ),
                      )
                    ],
                  );
                }
              },
            ),
          ),
        ),
        if (kAdvanceConfig['EnableShoppingCart'])
          Align(
            alignment: Alignment.bottomRight,
            child: ExpandingBottomSheet(
              hideController: _hideController,
            ),
          ),
      ],
    );
  }
}
