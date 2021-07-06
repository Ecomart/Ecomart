import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../models/index.dart' show Category;

class CategoryItem extends StatelessWidget {
  final Category category;
  final bool isParent;
  final bool isSelected;
  final bool? hasChild;
  final Function? onTap;
  final int level;

  CategoryItem(
    this.category, {
    this.isParent = false,
    this.isSelected = true,
    this.hasChild = false,
    this.onTap,
    this.level = 1,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hasChild!
          ? null
          : () {
              onTap!(category.id);
            },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.check,
              color:
                  isSelected && !isParent ? Colors.white : Colors.transparent,
              size: 20,
            ),
            SizedBox(width: 10.0 * level),
            Expanded(
              child: Text(
                '${isParent ? S.of(context).seeAll : category.name}  '
                '${category.totalProduct != null && !isParent ? '(${category.totalProduct})' : ''}',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            if (hasChild!)
              const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
                size: 20,
              ),
            const SizedBox(width: 20)
          ],
        ),
      ),
    );
  }
}
