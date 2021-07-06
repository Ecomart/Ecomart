import 'package:flutter/material.dart';

import '../../../models/index.dart' show Product, ProductModel;
import '../../../widgets/product/product_card_view.dart';
import '../config/product_config.dart';
import '../helper/header_view.dart';
import '../helper/helper.dart';

class EmptyProductList extends StatelessWidget {
  final ProductConfig config;
  final double maxWidth;

  const EmptyProductList(
      {Key? key, required this.config, required this.maxWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultHeight =
        config.height != null ? config.height! + 40.0 : maxWidth * 1.4;

    return Column(
      children: <Widget>[
        HeaderView(
          headerText: config.name ?? '',
          showSeeAll: false,
          callback: () =>
              ProductModel.showList(context: context, config: config),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: Helper.buildProductHeight(
              layout: config.layout,
              defaultHeight: defaultHeight,
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10.0),
                for (var i = 0; i < 4; i++)
                  ProductCard(
                    item: Product.empty(i.toString()),
                    width: Helper.buildProductWidth(
                      layout: config.layout,
                      screenWidth: maxWidth,
                    ),
                    // tablet: constraint.maxWidth / MediaQuery.of(context).size.height > 1.2,
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class EmptyProductTile extends StatelessWidget {
  final double maxWidth;

  const EmptyProductTile({Key? key, required this.maxWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        for (var i = 0; i < 4; i++)
          Container(
            width: maxWidth,
            child: ListTile(
              leading: Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(bottom: 4.0),
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(0.2),
              ),
              title: Container(
                width: 70,
                height: 30,
                color: Colors.grey.withOpacity(0.1),
              ),
              dense: false,
            ),
          ),
      ],
    );
  }
}
