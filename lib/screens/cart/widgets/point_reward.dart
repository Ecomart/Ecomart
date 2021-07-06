import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show CartModel, PointModel, AppModel, Point;

class PointReward extends StatefulWidget {
  // final CartModel model;
  PointReward();

  @override
  _PointRewardState createState() => _PointRewardState();
}

class _PointRewardState extends State<PointReward> {
  int quantity = 1;
  bool applied = false;

  void applyPoints(Point? point) {
    if (!applied) {
      var total = quantity * point!.cartPriceRate! / point.cartPointsRate!;
      Provider.of<CartModel>(context, listen: false).setRewardTotal(total);
    } else {
      Provider.of<CartModel>(context, listen: false).setRewardTotal(0);
    }
    setState(() {
      applied = !applied;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppModel>(context).currency;
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    final pointModel = Provider.of<PointModel>(context);

    return ListenableProvider.value(
        value: pointModel,
        child: Consumer<PointModel>(builder: (context, model, child) {
          if (model.point == null || model.point!.points == 0) {
            return Container();
          }

          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).pointRewardMessage),
                const SizedBox(height: 5.0),
                Text(
                    '${PriceTools.getCurrencyFormatted(model.point!.cartPriceRate, currencyRate, currency: currency)} = ${model.point!.cartPointsRate} Points'),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    PointSelection(
                      enabled: !applied,
                      limit: model.point!.points,
                      value: quantity,
                      onChanged: (val) {
                        setState(() {
                          quantity = val;
                        });
                      },
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        primary: Colors.transparent,
                        onPrimary: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        if(quantity <= model.point!.points!){
                          applyPoints(model.point);
                        }
                      },
                      child: Text(!applied
                          ? S.of(context).apply
                          : S.of(context).remove),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Text(S.of(context).availablePoints(model.point!.points!)),
              ],
            ),
          );
        }));
  }
}

class PointSelection extends StatefulWidget {
  final int? limit;
  final int value;
  final bool? enabled;
  final Function? onChanged;

  PointSelection(
      {required this.value, this.limit = 100, this.onChanged, this.enabled});

  @override
  _PointSelectionState createState() => _PointSelectionState();
}

class _PointSelectionState extends State<PointSelection> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller!.text = '${widget.value}';
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 44,
      decoration: BoxDecoration(
        color: !widget.enabled!
            ? Colors.black.withOpacity(0.05)
            : Colors.transparent,
        border: Border.all(width: 1.0, color: kGrey200),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextField(
          enabled: widget.enabled,
          controller: _controller,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (text) {
            widget.onChanged!(int.parse(text));
          },
        ),
      ),
    );
  }
}
