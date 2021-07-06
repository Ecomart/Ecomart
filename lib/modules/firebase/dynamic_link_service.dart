import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/utils.dart' show printLog;
import 'package:share/share.dart';

import '../../common/config.dart';
import '../../common/constants.dart' show RouteList, printLog;
import '../../services/index.dart';

class DynamicLinkService {
  DynamicLinkParameters productParameters({required String productUrl}) {
    return DynamicLinkParameters(
      uriPrefix: firebaseDynamicLinkConfig['uriPrefix'],
      link: Uri.parse(productUrl),
      androidParameters: AndroidParameters(
        packageName: firebaseDynamicLinkConfig['androidPackageName'],
        minimumVersion: firebaseDynamicLinkConfig['androidAppMinimumVersion'],
      ),
      iosParameters: IosParameters(
        bundleId: firebaseDynamicLinkConfig['iOSBundleId'],
        minimumVersion: firebaseDynamicLinkConfig['iOSAppMinimumVersion'],
        appStoreId: firebaseDynamicLinkConfig['iOSAppStoreId'],
      ),
    );
  }

  Future<Uri> generateFirebaseDynamicLink(DynamicLinkParameters params) async {
    return await params.buildUrl();
  }

  static void initDynamicLinks(BuildContext context) async {
    // A listener for link callbacks when the app is in background calling
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final deepLink = dynamicLink?.link;

      if (deepLink != null) {
        printLog('[firebase-dynamic-link] onLink: $deepLink');
        await _handleDynamicLink(deepLink.toString(), context);
        // await _handleDynamicLink(deepLink.toString(), context);
      }
    }, onError: (OnLinkErrorException e) async {
      printLog('[firebase-dynamic-link] error: ${e.message}');
    });

    // the getInitialLink() gets the link that opened the app (or null if it was not opened via a dynamic link)
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;

    if (deepLink != null) {
      printLog('[firebase-dynamic-link] getInitialLink: $deepLink');
      await _handleDynamicLink(deepLink.toString(), context);
    }
  }

  //Navigate to ProductDetail screen by entering productURL
  static Future<void> _handleDynamicLink(
      String productUrl, BuildContext context) async {
    try {
      /// Note: the deepLink URL will look like: https://mstore.io/product/stitch-detail-tunic-dress/
      final product = await Services().api.getProductByPermalink(productUrl);
      await Navigator.of(context).pushNamed(
        RouteList.productDetail,
        arguments: product,
      );
      // }
    } catch (err) {
      printLog('[firebase-dynamic-link] Error: ${err.toString()}');
    }
  }

  /// share product link that contains Dynamic link
  void shareProductLink({
    required String productUrl,
  }) async {
    var productParams = productParameters(productUrl: productUrl);
    var firebaseDynamicLink = await generateFirebaseDynamicLink(productParams);
    await Share.share(
      firebaseDynamicLink.toString(),
    );
  }
}
