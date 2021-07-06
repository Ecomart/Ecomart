import '../helper/helper.dart';

/// category : '57'
/// name : 'Woman Collections'
/// layout : 'threeColumn'
/// isSnapping : true

class ProductConfig {
  String? category;
  String? image;
  String? name;
  String? layout;
  bool? isSnapping;
  bool? showCountDown;
  bool onSale = false;
  double? height;
  double? imageWidth;
  dynamic jsonData;

  ProductConfig({
    this.category,
    this.image,
    this.name,
    this.layout,
    this.isSnapping,
    this.onSale = false,
    this.height,
    this.imageWidth,
    this.showCountDown,
    this.jsonData,
  });

  ProductConfig.fromJson(dynamic json) {
    category = json['category'].toString();
    image = json['image'];
    name = json['name'];
    layout = json['layout'];
    isSnapping = json['isSnapping'];
    onSale = json['onSale'] ?? false;
    showCountDown = json['showCountDown'];
    // ignore: prefer_initializing_formals
    jsonData = json;

    height = Helper.formatDouble(json['height']);
    imageWidth = Helper.formatDouble(json['imageWidth']);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['category'] = category;
    map['name'] = name;
    map['layout'] = layout;
    map['isSnapping'] = isSnapping;
    return map;
  }
}
