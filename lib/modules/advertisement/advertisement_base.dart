import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/advertisement_item.dart';

enum AdvertisementType { banner, reward, native, interstitial }

extension AdvertisementTypeExtension on AdvertisementType {
  String get content => describeEnum(this);
}

enum AdvertisementProvider { facebook, google }

extension AdvertisementProviderExtension on AdvertisementProvider {
  String get content => describeEnum(this);
}

abstract class AdvertisementBase {
  AdvertisementProvider get adsProvider;

  void showAd({
    required AdvertisementItem adItem,
  });

  void hideAd(String adId) {
    EasyDebounce.cancel(adId);
  }

  Widget createAdWidget({
    required AdvertisementItem adItem,
  });
}
