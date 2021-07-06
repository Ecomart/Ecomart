/// layout : 'blog'
/// name : 'Blog'

class BlogConfig {
  String? layout;
  String? name;

  BlogConfig({this.layout, this.name});

  BlogConfig.fromJson(dynamic json) {
    layout = json['layout'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['layout'] = layout;
    map['name'] = name;
    return map;
  }
}
