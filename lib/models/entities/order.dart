import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
// import '../../frameworks/strapi/services/strapi.dart';
import '../../generated/l10n.dart';
import '../../services/index.dart';
import '../cart/cart_model.dart';
import '../entities/address.dart';
import '../serializers/order.dart';
import '../serializers/product.dart';
import 'product.dart';
import 'product_variation.dart';

class Order {
  String? id;
  String? number;
  OrderStatus? status;
  DateTime? createdAt;
  DateTime? dateModified;
  double? total;
  double? totalTax;
  String? paymentMethodTitle;
  String? shippingMethodTitle;
  String? customerNote;
  List<ProductItem> lineItems = [];
  Address? billing;
  Address? shipping;
  String? statusUrl;
  double? subtotal;
  int quantity = 0;

  Order({this.id, this.number, this.status, this.createdAt, this.total});

  factory Order.fromJson(Map<String, dynamic>? parsedJson) {
    switch (Config().type) {
      case ConfigType.opencart:
        return Order._fromOpencartJson(parsedJson!);
      case ConfigType.magento:
        return Order._fromMagentoJson(parsedJson!);
      case ConfigType.shopify:
        return Order._fromShopify(parsedJson!);
      case ConfigType.presta:
        return Order._fromPrestashop(parsedJson!);
      case ConfigType.strapi:
        return Order._fromStrapiJson(parsedJson!);
      default:
        return Order._fromWooJson(parsedJson!);
    }
  }

  OrderStatus parseOrderStatus(String? status) {
    final newStatus = status?.toLowerCase();
    if (newStatus == 'on-hold') return OrderStatus.onHold;
    if (newStatus == 'complete') return OrderStatus.completed;
    return OrderStatus.values
        .firstWhere((element) => describeEnum(element) == newStatus);
  }

  Order._fromWooJson(Map<String, dynamic> parsedJson) {
    try {
      id = parsedJson['id'].toString();
      customerNote = parsedJson['customer_note'];
      number = parsedJson['number'];
      status = parseOrderStatus(parsedJson['status']);
      createdAt = parsedJson['date_created'] != null
          ? DateTime.parse(parsedJson['date_created'])
          : DateTime.now();
      dateModified = parsedJson['date_modified'] != null
          ? DateTime.parse(parsedJson['date_modified'])
          : DateTime.now();
      total =
          parsedJson['total'] != null ? double.parse(parsedJson['total']) : 0.0;
      totalTax = parsedJson['total_tax'] != null
          ? double.parse(parsedJson['total_tax'])
          : 0.0;
      paymentMethodTitle = parsedJson['payment_method_title'];

      parsedJson['line_items']?.forEach((item) {
        lineItems.add(ProductItem.fromJson(item));
        quantity += int.parse("${item["quantity"]}");
      });

      billing = Address.fromJson(parsedJson['billing']);
      shipping = Address.fromJson(parsedJson['shipping']);
      shippingMethodTitle = parsedJson['shipping_lines'] != null &&
              parsedJson['shipping_lines'].length > 0
          ? parsedJson['shipping_lines'][0]['method_title']
          : null;
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Order._fromOpencartJson(Map<String, dynamic> parsedJson) {
    try {
      id = parsedJson['order_id'].toString();
      number = parsedJson['order_id'];
      status = parseOrderStatus(parsedJson['order_status']);
      createdAt = parsedJson['date_added'] != null
          ? DateTime.parse(parsedJson['date_added'])
          : DateTime.now();
      dateModified = parsedJson['date_modified'] != null
          ? DateTime.parse(parsedJson['date_modified'])
          : DateTime.now();
      total =
          parsedJson['total'] != null ? double.parse(parsedJson['total']) : 0.0;
      totalTax = 0.0;
      paymentMethodTitle = parsedJson['payment_method'];
      shippingMethodTitle = parsedJson['shipping_method'];
      customerNote = parsedJson['comment'];
      parsedJson['line_items']?.forEach((item) {
        lineItems.add(ProductItem.fromOpencartJson(item));
      });
      billing = Address.fromOpencartOrderJson(parsedJson);
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Order._fromMagentoJson(Map<String, dynamic> parsedJson) {
    try {
      id = parsedJson['entity_id'].toString();
      number = "${parsedJson["increment_id"]}";
      status = parseOrderStatus(parsedJson['status']);
      createdAt = parsedJson['created_at'] != null
          ? DateTime.parse(parsedJson['created_at'])
          : DateTime.now();
      total = parsedJson['base_grand_total'] != null
          ? double.parse("${parsedJson["base_grand_total"]}")
          : 0.0;
      paymentMethodTitle = parsedJson['payment']['additional_information'][0];
      shippingMethodTitle = parsedJson['shipping_description'];
      totalTax = 0.0;
      parsedJson['items']?.forEach((item) {
        quantity += int.parse('${item['qty_ordered']}');
        lineItems.add(ProductItem.fromMagentoJson(item));
      });
      billing = Address.fromMagentoJson(parsedJson['billing_address']);
      shipping = billing;
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Order._fromShopify(Map<String, dynamic> parsedJson) {
    try {
      id = parsedJson['id'];
      number = "${parsedJson["orderNumber"]}";
//    status = parsedJson["statusUrl"];

      createdAt = DateTime.parse(parsedJson['processedAt']);
      total = double.parse(parsedJson['totalPrice']);
      paymentMethodTitle = '';
      shippingMethodTitle = '';
      statusUrl = parsedJson['statusUrl'];

      var totalTaxV2 = parsedJson['totalTaxV2']['amount'] ?? '0';
      totalTax = double.parse(totalTaxV2);
      var subtotalTaxV2 = parsedJson['subtotalPriceV2']['amount'] ?? '0';
      subtotal = double.parse(subtotalTaxV2);

      var items = parsedJson['lineItems']['edges'];
      items.forEach((item) {
        lineItems.add(ProductItem.fromShopifyJson(item['node']));
      });
      billing = Address.fromShopifyJson(parsedJson['shippingAddress']);
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Order._fromPrestashop(Map<String, dynamic> parsedJson) {
    try {
      id = parsedJson['id'].toString();
      number = "${parsedJson["id"]}";
      status = null;
      createdAt = DateTime.parse(parsedJson['date_add']);
      total = double.parse(parsedJson['total_paid']);
      paymentMethodTitle = parsedJson['payment'];
      shippingMethodTitle = '';
      statusUrl = null;

      totalTax = double.parse(parsedJson['total_shipping']);
      subtotal = 0;

      var items = parsedJson['associations']['order_rows'];
      items.forEach((item) {
        lineItems.add(ProductItem.fromPrestaJson(item));
      });
      billing = Address.fromPrestaJson(parsedJson['address'] ?? {});
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Order._fromStrapiJson(Map<String, dynamic> parsedJson) {
    try {
      var model = SerializerOrder.fromJson(parsedJson);
      id = model.id.toString();
      number = model.id.toString();
      status = null;
      createdAt = DateTime.parse(model.createdAt!);
      total = model.total;
      paymentMethodTitle = model.payment!.title;
      shippingMethodTitle = model.shipping!.title;
      customerNote = '';
      // List<dynamic> itemList = model.products!;
      // itemList.forEach((item) {
      //   lineItems
      //       .add(ProductItem.fromStrapiJson(item, Strapi().strapiAPI.apiLink));
      // });
      statusUrl = '';
      totalTax = 0.0;
      subtotal = 0.0;
    } on Exception catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Order.fromLocalJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    number = parsedJson['number'];
    status = parseOrderStatus(parsedJson['status']);
    createdAt = parsedJson['date_created'] != null
        ? DateTime.parse(parsedJson['date_created'])
        : DateTime.now();
    total =
        parsedJson['total'] != null ? double.parse(parsedJson['total']) : 0.0;
    totalTax = parsedJson['totalTax'] != null
        ? double.parse(parsedJson['totalTax'])
        : 0.0;
    paymentMethodTitle = parsedJson['payment_method_title'];

    parsedJson['line_items']?.forEach((item) {
      lineItems.add(ProductItem.fromLocalJson(item));
      quantity += int.parse("${item["quantity"]}");
    });

    billing = Address.fromLocalJson(parsedJson['billing']);
    shipping = Address.fromLocalJson(parsedJson['shipping']);
    shippingMethodTitle = parsedJson['shipping_lines'] != null &&
            parsedJson['shipping_lines'].length > 0
        ? parsedJson['shipping_lines'][0]['method_title']
        : null;
  }

  Map<String, dynamic> toOrderJson(CartModel cartModel, userId) {
    var items = lineItems.map((index) {
      return index.toJson();
    }).toList();

    return {
      'status': status!.content,
      'total': total.toString(),
      'totalTax': totalTax.toString(),
      'shipping_lines': [
        {'method_title': shippingMethodTitle}
      ],
      'number': number,
      'billing': billing?.toJson(),
      'shipping': shipping?.toJson(),
      'line_items': items,
      'id': id,
      'date_created': createdAt.toString(),
      'payment_method_title': paymentMethodTitle
    };
  }

  Map<String, dynamic> toJson(CartModel cartModel, userId, paid) {
    var hasAddonsOptions = false;
    var lineItems = cartModel.productsInCart.keys.map((key) {
      var productId = Product.cleanProductID(key);
      var productVariantId = ProductVariation.cleanProductVariantID(key);

      var item = {
        'product_id': productId,
        'quantity': cartModel.productsInCart[key]
      };

      var attrNames = <String?>[];
      if (cartModel.productVariationInCart[key] != null &&
          productVariantId != null) {
        item['variation_id'] = cartModel.productVariationInCart[key]!.id;
        cartModel.productVariationInCart[key]!.attributes.forEach((element) {
          if (element.id != null) {
            attrNames.add(element.name);
          }
        });
      }

      var product = cartModel.item[productId];
      if (cartModel.productsMetaDataInCart[key] != null) {
        var meta_data = <Map<String, dynamic>>[];
        cartModel.productsMetaDataInCart[key].forEach((k, v) {
          if (!attrNames.contains(k)) {
            product!.attributes!.forEach((element) {
              if (element.name == k) {
                Map<String, dynamic>? option = element.options!
                    .firstWhere((e) => e['name'] == v, orElse: () => null);
                if (option != null) {
                  meta_data.add({
                    'key': 'attribute_${element.slug}',
                    'value': option['slug'] ?? option['name']
                  });
                }
              }
            });
          }
        });
        item['meta_data'] = meta_data;
      }
//      if (product.bookingInfo != null) {
//        var meta_data =
//            List<Map<String, dynamic>>.from(item['meta_data'] ?? []);
//        var bookingInfo = product.bookingInfo.toJsonAPI();
//        bookingInfo.keys.forEach((key) {
//          meta_data.add({'key': key, 'value': bookingInfo[key]});
//        });
//        item['meta_data'] = meta_data;
//      }

      if (cartModel.productAddonsOptionsInCart[key] != null &&
          cartModel.productAddonsOptionsInCart[key]!.isNotEmpty) {
        hasAddonsOptions = true;
        var meta_data = item['meta_data'] as List<Map<String, dynamic>>? ?? [];
        var itemPrice = cartModel.getProductPrice(key);
        final options = cartModel.productAddonsOptionsInCart[key]!;
        for (var option in options) {
          final price =
              '${PriceTools.getCurrencyFormatted(option.price ?? 0.0, cartModel.currencyRates, currency: cartModel.currency)}';
          meta_data.add({
            'key':
                "${option.parent}${(option.price?.isNotEmpty ?? false) ? ' ($price)' : ''}",
            'value': '${option.label}',
          });
          itemPrice += double.tryParse(option.price ?? '0.0') ?? 0;
        }

        item['subtotal'] = '$itemPrice';
        item['total'] = '$itemPrice';
      }
      return item;
    }).toList();

    var params = {
      'set_paid': paid,
      'line_items': lineItems,
      'customer_id': userId,
    };
    try {
      if (cartModel.paymentMethod != null) {
        params['payment_method'] = cartModel.paymentMethod!.id;
      }
      if (cartModel.paymentMethod != null) {
        params['payment_method_title'] = cartModel.paymentMethod!.title;
      }
      if (paid) params['status'] = 'processing';

      if (cartModel.address != null &&
          cartModel.address!.mapUrl != null &&
          cartModel.address!.mapUrl!.isNotEmpty &&
          kPaymentConfig['EnableAddressLocationNote']) {
        params['customer_note'] = 'URL:' + cartModel.address!.mapUrl!;
      }
      if ((kPaymentConfig['EnableCustomerNote'] ?? true) &&
          cartModel.notes != null &&
          cartModel.notes!.isNotEmpty) {
        if (params['customer_note'] != null) {
          params['customer_note'] += '\n' + cartModel.notes!;
        } else {
          params['customer_note'] = cartModel.notes;
        }
      }

      if (kPaymentConfig['EnableAddress'] && cartModel.address != null) {
        params['billing'] = cartModel.address!.toJson();
        params['shipping'] = cartModel.address!.toJson();
      }

      var isMultiVendor = kFluxStoreMV.contains(serverConfig['type']);
      if (isMultiVendor) {
        if (kPaymentConfig['EnableShipping'] &&
            cartModel.selectedShippingMethods.isNotEmpty) {
          var shippings = <Map<String, dynamic>>[];
          cartModel.selectedShippingMethods.forEach((element) {
            shippings.add({
              'method_id': '${element.shippingMethods[0].id}',
              'method_title': element.shippingMethods[0].title,
              'total': '${element.shippingMethods[0].cost}'
            });
          });
          params['shipping_lines'] = shippings;
        }
      } else {
        if (kPaymentConfig['EnableShipping'] &&
            cartModel.shippingMethod != null) {
          params['shipping_lines'] = [
            {
              'method_id': '${cartModel.shippingMethod!.id}',
              'method_title': cartModel.shippingMethod!.title,
              'total': cartModel.getShippingCost().toString()
            }
          ];
        }
      }

      if (cartModel.rewardTotal > 0) {
        params['fee_lines'] = [
          {
            'name': 'Cart Discount',
            'tax_status': 'taxable',
            'total': '${cartModel.rewardTotal * (-1)}',
            'amount': '${cartModel.rewardTotal * (-1)}'
          }
        ];
      }
      if (cartModel.couponObj != null) {
        params['coupon_lines'] = [
          cartModel.couponObj!.toJson(),
        ];
      }

      if (hasAddonsOptions || cartModel.couponObj != null) {
        params['subtotal'] = cartModel.getSubTotal();
        params['total'] = cartModel.getTotal();
      }
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }

    return params;
  }

  Map<String, dynamic> toMagentoJson(CartModel cartModel, userId, paid) {
    return {
      'set_paid': paid,
      'paymentMethod': {'method': cartModel.paymentMethod!.id},
      'billing_address': cartModel.address!.toMagentoJson()['address'],
    };
  }

  @override
  String toString() => 'Order { id: $id  number: $number}';
}

class ProductItem {
  String? productId;
  String? name;
  int? quantity;
  String? total;
  String? featuredImage;
  String? addonsOptions;
  List<String?> attributes = [];

  ProductItem.fromJson(Map<String, dynamic> parsedJson) {
    try {
      productId = parsedJson['product_id'].toString();
      name = parsedJson['name'];
      quantity = int.parse("${parsedJson["quantity"]}");
      total = parsedJson['total'];
      featuredImage = parsedJson['featured_image'];
      if (parsedJson['featured_image'] != null) {
        featuredImage = parsedJson['featured_image'];
      }
      if (parsedJson['product_data'] != null) {
        if (parsedJson['product_data']['images'] != null &&
            parsedJson['product_data']['images'].isNotEmpty) {
          featuredImage = parsedJson['product_data']['images'][0]['src'];
        }
      }

      featuredImage ??= kDefaultImage;

      final metaData = parsedJson['meta_data'];
      if (metaData is List) {
        addonsOptions = metaData.map((e) => e['value']).join(', ');
      }

      /// For FluxStore Manager
      if (parsedJson['meta'] != null) {
        addonsOptions = parsedJson['meta'].map((e) => e['value']).join(', ');
        parsedJson['meta'].forEach((attr) => attributes.add(attr['value']));
      }
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  ProductItem.fromOpencartJson(Map<String, dynamic> parsedJson) {
    try {
      productId = parsedJson['product_id'].toString();
      name = parsedJson['name'];
      quantity = int.parse("${parsedJson["quantity"]}");
      total = parsedJson['total'];
      if (parsedJson['product_data'] != null) {
        if (parsedJson['product_data']['images'] != null &&
            parsedJson['product_data']['images'].isNotEmpty) {
          featuredImage = parsedJson['product_data']['images'][0];
        }
      }
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'quantity': quantity,
      'total': total,
      'featuredImage': featuredImage
    };
  }

  ProductItem.fromLocalJson(Map<String, dynamic> parsedJson) {
    productId = "${parsedJson["product_id"]}";
    name = parsedJson['name'];
    quantity = parsedJson['quantity'];
    total = parsedJson['total'].toString();
    featuredImage = parsedJson['featuredImage'];
  }

  ProductItem.fromMagentoJson(Map<String, dynamic> parsedJson) {
    try {
      productId = "${parsedJson["product_id"]}";
      name = parsedJson['name'];
      quantity = parsedJson['qty_ordered'];
      total = parsedJson['base_row_total'].toString();
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  ProductItem.fromShopifyJson(Map<String, dynamic> parsedJson) {
    try {
      productId = parsedJson['title'];
      name = parsedJson['title'];
      quantity = parsedJson['quantity'];
      total = '';
      featuredImage = ((parsedJson['variant'] ?? {})['image'] ?? {})['src'];
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  ProductItem.fromPrestaJson(Map<String, dynamic> parsedJson) {
    try {
      productId = parsedJson['product_id'];
      name = parsedJson['product_name'];
      quantity = int.parse(parsedJson['product_quantity']);
      total = parsedJson['product_price'];
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  ProductItem.fromStrapiJson(SerializerProduct model, apiLink) {
    try {
      // var model = SerializerProduct.fromJson(parsedJson);
      productId = model.id.toString();
      name = model.title;
      total = model.price.toString();

      var imageList = [];
      if (model.images != null) {
        for (var item in model.images!) {
          imageList.add(apiLink(item.url));
        }
      }
      featuredImage =
          imageList.isNotEmpty ? imageList[0] : apiLink(model.thumbnail!.url);
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }
}

enum OrderStatus {
  pending,
  processing,
  cancelled,
  //canceled,
  refunded,
  completed,
  onHold,
  failed,
}

extension OrderStatusExtension on OrderStatus {
  bool get isCancelled => [
        OrderStatus.cancelled,
        // OrderStatus.canceled,
      ].contains(this);

  String get content => describeEnum(this);

  Color get displayColor {
    switch (this) {
      case OrderStatus.pending:
        return Colors.amber;
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.cancelled:
        // case OrderStatus.canceled:
        return Colors.grey;
      case OrderStatus.refunded:
        return Colors.red;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.onHold:
        return Colors.blue;
      default:
        return Colors.yellow;
    }
  }

  String getTranslation(context) {
    switch (this) {
      case OrderStatus.pending:
        return S.of(context).orderStatusPending;
      case OrderStatus.processing:
        return S.of(context).orderStatusProcessing;
      case OrderStatus.cancelled:
        // case OrderStatus.canceled:
        return S.of(context).orderStatusCancelled;
      case OrderStatus.refunded:
        return S.of(context).orderStatusRefunded;
      case OrderStatus.completed:
        return S.of(context).orderStatusCompleted;
      case OrderStatus.onHold:
        return S.of(context).orderStatusOnHold;
      default:
        return S.of(context).orderStatusFailed;
    }
  }
}
