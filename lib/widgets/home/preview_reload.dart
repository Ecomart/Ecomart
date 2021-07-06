import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../services/index.dart';

class PreviewReload extends StatefulWidget {
  final bool isDynamic;
  final String? previewKey;
  final Map<String, dynamic>? configs;
  final builder;

  PreviewReload({
    this.configs,
    this.isDynamic = false,
    this.previewKey,
    required this.builder,
  }) : assert(builder != null);

  @override
  _PreviewReloadState createState() => _PreviewReloadState();
}

class _PreviewReloadState extends State<PreviewReload> {
  Map<String, dynamic>? configs;
  String? key;

  @override
  void initState() {
    /// init listener preview configs
    eventBus.on<EventReloadConfigs>().listen((event) {
      if (event.key != null) {
        if (event.key == widget.previewKey && widget.isDynamic) {
          setState(() {
            configs = event.configs;
          });
        }
      } else if (!widget.isDynamic) {
        setState(() {
          configs = event.configs;
        });
      }
    });
    configs = widget.configs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.builder(
        Config().isBuilder ? configs : widget.configs,
      ),
    );
  }
}
