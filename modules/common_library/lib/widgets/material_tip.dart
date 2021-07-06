import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MaterialTip extends StatelessWidget {
  final String? message;
  final Widget? child;
  MaterialTip({this.message, this.child});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message!,
      padding: const EdgeInsets.all(10),
      showDuration: const Duration(seconds: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          color: Colors.white54,
          width: 1,
        ),
      ),
      textStyle:
          Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
      preferBelow: true,
      verticalOffset: 20,
      child: child,
    );
  }
}
