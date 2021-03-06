part of '../config.dart';

Map get kPaymentConfig => Configurations.paymentConfig;

Map get Payments => Configurations.payments;

Map get kStripeConfig => Configurations.stripeConfig;

Map get PaypalConfig => Configurations.paypalConfig;

Map get RazorpayConfig => Configurations.razorpayConfig;

Map get TapConfig => Configurations.tapConfig;

Map get MercadoPagoConfig => Configurations.mercadoPagoConfig;

Map get afterShip => Configurations.afterShip;

/// Limit the country list from Billing Address
/// []: default show all country
List get DefaultCountry => Configurations.defaultCountryShipping;

//const List DefaultCountry = [
//  {
//    "name": "Vietnam",
//    "iosCode": "VN",
//    "icon": "https://cdn.britannica.com/41/4041-004-A06CBD63/Flag-Vietnam.jpg"
//  },
//  {
//    "name": "India",
//    "iosCode": "IN",
//    "icon":
//        "https://upload.wikimedia.org/wikipedia/en/thumb/4/41/Flag_of_India.svg/1200px-Flag_of_India.svg.png"
//  },
//  {"name": "Austria", "iosCode": "AT", "icon": ""},
//];
