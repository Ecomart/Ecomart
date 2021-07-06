import 'package:flutter/material.dart';

import '../../../models/index.dart' show Product;
import '../../../widgets/product/product_item_tile.dart';

class ProductListTitle extends StatelessWidget {
  final List<Product>? products;

  const ProductListTitle(this.products);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxWidth + 180,
          child: PageView(
            children: <Widget>[
              for (var i = 0; i < products!.length; i = i + 3)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: ProductItemTileView(item: products![i])),
                    i + 1 < products!.length
                        ? Expanded(
                            child: ProductItemTileView(item: products![i + 1]),
                          )
                        : const SizedBox(),
                    i + 2 < products!.length
                        ? Expanded(
                            child: ProductItemTileView(item: products![i + 2]),
                          )
                        : const SizedBox(),
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}
