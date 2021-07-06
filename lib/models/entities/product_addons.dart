class ProductAddons {
  String? name;
  String? description;
  String? type;
  String? price;
  int? position;
  List<AddonsOption>? options;
  bool? required;
  Map<String, AddonsOption> defaultOptions = {};

  ProductAddons({
    this.name,
    this.description,
    this.type,
    this.position,
    this.options,
    this.required = false,
  });

  bool get isHeadingType => type == 'heading';

  bool get isRadioButtonType => type == 'multiple_choice';

  bool get isCheckboxType => type == 'checkbox';

  bool get isTextType => isLongTextType || isShortTextType;

  bool get isShortTextType => type == 'custom_text';

  bool get isLongTextType => type == 'custom_textarea';

  bool get isFileUploadType => type == 'file_upload';

  ProductAddons.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    type = json['type'];
    price = json['price'];
    position = json['position'];
    required = json['required'] == 1;
    if (json['options'] != null) {
      final List<dynamic> values = json['options'] ?? [];
      options = List<AddonsOption>.generate(
        values.length,
        (index) {
          final option = AddonsOption.fromJson(values[index]);
          option.parent = name;
          option.type = type;
          if ((option.isDefault ?? false) && option.label != null) {
            defaultOptions[option.label!] = option;
          }
          return option;
        },
      );
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['type'] = type;
    data['price'] = price;
    data['position'] = position;
    data['required'] = (required ?? false) ? 1 : 0;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddonsOption {
  String? parent;
  String? label;
  String? price;
  String? priceType;
  bool? isDefault;
  String? type;

  bool get isFileUploadType => type == 'file_upload';

  bool get isFlatFee => priceType == 'flat_fee';

  bool get isQuantityBased => priceType == 'quantity_based';

  AddonsOption({
    this.parent,
    this.type,
    this.label,
    this.price,
    this.priceType,
    this.isDefault = false,
  });

  AddonsOption.fromJson(Map<String, dynamic> json) {
    parent = json['parent'];
    label = json['label'];
    priceType = json['price_type'];
    price = json['price'];
    type = json['type'];
    isDefault = json['default'] == '1';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['parent'] = parent;
    data['label'] = label;
    data['price'] = price;
    data['price_type'] = priceType;
    data['type'] = type;
    data['default'] = (isDefault ?? false) ? '1' : '0';
    return data;
  }
}
