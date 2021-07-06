import 'package:flutter/material.dart';

import '../../../models/index.dart' show Product, ProductModel;
import '../config/product_config.dart';
import '../helper/header_view.dart';
import '../vertical/vertical_simple_list.dart';
import 'future_builder.dart';

class SimpleVerticalProductList extends StatelessWidget {
  final ProductConfig config;

  SimpleVerticalProductList({required this.config, Key? key}) : super(key: key);

  Widget renderProductListWidgets(List<Product> products) {
    return Column(
      children: [
        const SizedBox(width: 10.0),
        for (var item in products)
          SimpleListView(
            item: item,
            type: SimpleListType.PriceOnTheRight,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProductFutureBuilder(
      config: config,
      waiting: Column(
        children: <Widget>[
          HeaderView(
            headerText: config.name ?? '',
            showSeeAll: true,
            callback: () =>
                ProductModel.showList(context: context, config: config),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                for (var i = 0; i < 3; i++)
                  SimpleListView(
                    item: Product.empty(i.toString()),
                    type: SimpleListType.PriceOnTheRight,
                  ),
              ],
            ),
          )
        ],
      ),
      child: ({maxWidth, products}) => Column(
        children: <Widget>[
          HeaderView(
            headerText: config.name ?? '',
            showSeeAll: true,
            callback: () => ProductModel.showList(
              context: context,
              config: config.jsonData,
              products: products,
            ),
          ),
          renderProductListWidgets(products)
        ],
      ),
    );
  }
}
