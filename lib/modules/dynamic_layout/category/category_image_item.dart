import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/category_model.dart';
import '../../../models/product_model.dart';
import '../config/category_item_config.dart';

/// The category icon circle list
class CategoryImageItem extends StatelessWidget {
  final CategoryItemConfig config;
  final products;
  final width;
  final height;

  const CategoryImageItem(
      {required this.config, this.products, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final itemWidth = (width ?? screenSize.width) / 3;
    final categoryList = Provider.of<CategoryModel>(context).categoryList;
    final id = config.category.toString();
    final name = categoryList[id] != null ? categoryList[id]!.name : '';
    final image = categoryList[id] != null ? categoryList[id]!.image : '';
    final total =
        categoryList[id] != null ? categoryList[id]!.totalProduct : '';

    final imageWidget = config.image != null
        ? config.image.toString().contains('http')
            ? Image.network(config.image!, fit: BoxFit.fitWidth)
            : Image.asset(
                config.image!,
                fit: BoxFit.fitWidth,
              )
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 5.0),
      child: GestureDetector(
        onTap: () =>
            ProductModel.showList(config: config.toJson(), context: context),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: HexColor(
                '5F' + kNameToHex['grey']!,
              ),
              width: 0.5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          ),
          width: itemWidth,
          height: height ?? 140.0,
          margin: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  width: itemWidth,
                  height: itemWidth * 0.45,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0)),
                  ),
                  child: imageWidget ??
                      ImageTools.image(
                        url: image,
                        fit: BoxFit.cover,
                        isResize: true,
                        size: kSize.small,
                      ),
                ),
              ),
              if (config.showText == true) const SizedBox(height: 6),
              if (config.showText == true)
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 2),
                        Text(
                          config.name ?? name!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          config.description ??
                              S.of(context).totalProducts('$total'),
                          style: const TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
