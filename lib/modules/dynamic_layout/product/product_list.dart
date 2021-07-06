import 'package:flutter/material.dart';
import 'package:inspireui/widgets/flux_image.dart';

import '../../../common/config.dart';
import '../../../models/index.dart' show Product, ProductModel;
import '../config/product_config.dart';
import '../helper/header_view.dart';
import '../helper/helper.dart';
import 'future_builder.dart';
import 'product_list_default.dart';
import 'product_list_tile.dart';
import 'product_staggered.dart';

class ProductList extends StatelessWidget {
  final ProductConfig config;

  const ProductList({
    required this.config,
    Key? key,
  }) : super(key: key);

  bool isShowCountDown() {
    final _isSaleOffLayout = config.layout == Layout.saleOff;
    return (config.showCountDown ?? kSaleOffProduct['ShowCountDown']) &&
        _isSaleOffLayout;
  }

  int getCountDownDuration(List<Product>? data,
      [bool isSaleOffLayout = false]) {
    if (isShowCountDown() && data!.isNotEmpty) {
      return (DateTime.tryParse(data.first.dateOnSaleTo ?? '')
                  ?.millisecondsSinceEpoch ??
              0) -
          (DateTime.now().millisecondsSinceEpoch);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final _isRecentLayout = config.layout == Layout.recentView;
    final _isListTileLayout = config.layout == Layout.listTile;
    final _isStagLayout = config.layout == Layout.staggered;
    final _isSaleOffLayout = config.layout == Layout.saleOff;

    return ProductFutureBuilder(
      config: config,
      child: ({maxWidth, products}) {
        final _durationInMilliSeconds =
            getCountDownDuration(products, _isSaleOffLayout);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (config.image != null && config.image != '')
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: FluxImage(
                  imageUrl: config.image!,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
            HeaderView(
              headerText: config.name ?? '',
              showSeeAll: _isRecentLayout ? false : true,
              margin: config.image != null ? 6.0 : 10.0,
              callback: () => ProductModel.showList(
                context: context,
                config: config.jsonData,
                products: products,
                showCountdown: isShowCountDown() && _durationInMilliSeconds > 0,
                countdownDuration:
                    Duration(milliseconds: _durationInMilliSeconds),
              ),
              showCountdown: isShowCountDown() && _durationInMilliSeconds > 0,
              countdownDuration:
                  Duration(milliseconds: _durationInMilliSeconds),
            ),
            _isStagLayout
                ? ProductStaggered(
                    key: UniqueKey(),
                    products: products,
                    width: maxWidth,
                  )
                : _isListTileLayout
                    ? ProductListTitle(products)
                    : ProductListDefault(
                        key: UniqueKey(),
                        layout: config.layout ?? Layout.threeColumn,
                        height: config.height,
                        width: maxWidth,
                        products: products,
                        isSnapping: config.isSnapping ?? false,
                      )
            // : ProductListWidgets(context, products, maxWidth),
          ],
        );
      },
    );
  }
}
