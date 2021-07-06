import 'package:inspireui/utils/logs.dart';

import 'firebase_service.dart';

class FirebaseRemoteServices {
  static Future<void> loadRemoteConfig({required Function onUpdate}) async {
    final _remoteConfig = FirebaseServices().remoteConfig!;

    // Fixme: Hieu - update remote config
    try {
      await _remoteConfig.fetch();
      await _remoteConfig.activate();
    } catch (e) {
      printLog('Unable to fetch remote config. Default value will be used');
    }
  }
}
