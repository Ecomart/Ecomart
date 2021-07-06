import 'package:flutter/material.dart';
import 'package:inspireui/widgets/flux_image.dart';

import '../config/box_shadow_config.dart';
import '../config/category_item_config.dart';

class CategoryIconItem extends StatelessWidget {
  final double? iconSize;
  final String? name;
  final bool? originalColor;
  final double? borderWidth;
  final double? radius;
  final bool? noBackground;
  final BoxShadowConfig? boxShadow;
  final Function? onTap;
  final CategoryItemConfig? itemConfig;

  const CategoryIconItem({
    this.iconSize,
    this.name,
    this.originalColor,
    this.borderWidth,
    this.radius,
    this.noBackground,
    this.onTap,
    this.itemConfig,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final disableBackground =
        ((noBackground ?? false) || (originalColor ?? false));

    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        constraints: BoxConstraints(maxWidth: iconSize! * 1.2),
        decoration: borderWidth != null && borderWidth != 0
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: borderWidth!,
                    color: Colors.black.withOpacity(0.05),
                  ),
                  right: BorderSide(
                    width: borderWidth!,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (itemConfig!.image != null)
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: !disableBackground
                      ? itemConfig!.getBackgroundColor
                      : null,
                  gradient:
                      !disableBackground ? itemConfig!.getGradientColor : null,
                  boxShadow: [
                    if (boxShadow != null)
                      BoxShadow(
                        blurRadius: radius!,
                        color: Theme.of(context).accentColor.withOpacity(0.5),
                        offset: Offset(boxShadow!.x, boxShadow!.y),
                      )
                  ],
                  borderRadius: BorderRadius.circular(radius!),
                ),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: FluxImage(
                    imageUrl: itemConfig!.image!,
                    color: (itemConfig!.originalColor ?? true) ||
                            (originalColor ?? true)
                        ? null
                        : itemConfig!.colors!.first,
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
              ),
            if (name?.isNotEmpty ?? false) ...[
              const SizedBox(height: 6),
              Text(
                name!,
                style: Theme.of(context).textTheme.subtitle2,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
