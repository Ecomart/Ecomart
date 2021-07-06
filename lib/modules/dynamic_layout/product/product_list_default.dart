import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/index.dart' show AppModel;
import '../../../services/index.dart';
import '../helper/custom_physic.dart';
import '../helper/helper.dart';

class ProductListDefault extends StatelessWidget {
  final width;
  final height;
  final products;
  final bool isSnapping;
  final String layout;

  const ProductListDefault({
    required Key key,
    this.width,
    this.height,
    this.products,
    this.isSnapping = false,
    required this.layout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products == null) return Container();
    var _ratioProductImage =
        Provider.of<AppModel>(context, listen: false).ratioProductImage;

    return Container(
      color: Theme.of(context).backgroundColor,
      constraints: BoxConstraints(
        minHeight: Helper.buildProductHeight(
          layout: layout,
          defaultHeight: width,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: isSnapping
            ? CustomScrollPhysic(
                width: Helper.buildProductWidth(
                        screenWidth: width, layout: layout) +
                    10)
            : const ScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(width: 12.0),
            for (var i = 0; i < products.length; i++)
              Services().widget.renderProductCardView(
                    item: products[i],
                    width: Helper.buildProductWidth(
                      screenWidth: width,
                      layout: layout,
                    ),
                    maxWidth: Helper.buildProductMaxWidth(layout: layout),
                    height: Helper.buildProductHeight(
                      layout: layout,
                      defaultHeight: width,
                    ),
                    showProgressBar: layout == Layout.saleOff,
                    ratioProductImage: _ratioProductImage,
                  )
          ],
        ),
      ),
    );
  }
}
