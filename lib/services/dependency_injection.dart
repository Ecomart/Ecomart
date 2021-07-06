import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

import '../common/config.dart';
import '../modules/firebase/firebase_notification_service.dart';
import '../modules/onesignal/one_signal_notification_service.dart';
import 'notification/notification_service.dart';
import 'notification/notification_service_impl.dart';

GetIt injector = GetIt.instance;

class DependencyInjection {
  static Future<void> inject() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    NotificationService notificationService = NotificationServiceImpl();
    if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid) {
      if (kOneSignalKey['enable'] ?? false) {
        notificationService =
            OneSignalNotificationService(appID: kOneSignalKey['appID']);
      } else {
        notificationService = FirebaseNotificationService();
      }
    }

    injector.registerSingleton<SharedPreferences>(sharedPreferences);
    injector.registerSingleton<NotificationService>(notificationService);
  }
}
