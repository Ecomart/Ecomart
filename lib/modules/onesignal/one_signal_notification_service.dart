import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../models/entities/fstore_notification_item.dart';
import '../../services/notification/notification_service.dart';

class OneSignalNotificationService extends NotificationService {
  final _instance = OneSignal.shared;
  final String appID;

  OneSignalNotificationService({required this.appID}) {
    _instance.setAppId(appID);
  }

  @override
  void disableNotification() {
    _instance.disablePush(true);
  }

  @override
  void enableNotification() {
    _instance.disablePush(false);
  }

  @override
  void init({
    String? externalUserId,
    required NotificationDelegate notificationDelegate,
  }) {
    _instance.setExternalUserId(externalUserId ?? '');
    delegate = notificationDelegate;
    _setupOnTapMessage();
    _setupOnMessage();
  }

  void _setupOnTapMessage() {
    _instance.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      final data = result.notification;
      delegate.onTapMessage(FStoreNotificationItem(
        id: data.notificationId,
        title: data.title ?? '',
        body: data.body ?? '',
        additionalData: data.additionalData,
        date: DateTime.now(),
      ));
    });
  }

  void _setupOnMessage() {
    _instance.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent result) {
      // printLog(
      //     result.notification.jsonRepresentation().replaceAll('\\n', '\n'));

      /// When a notification arrives it will show right away if the app in the foreground
      /// If the app is opening the notification will schedule 25 seconds to show
      /// This statement makes the notification will show even when the app is opening
      _instance.completeNotification(result.notification.notificationId, true);
      final data = result.notification;
      delegate.onMessage(FStoreNotificationItem(
        id: data.notificationId,
        title: data.title ?? '',
        body: data.body ?? '',
        additionalData: data.additionalData,
        date: DateTime.now(),
      ));
    });
  }
}
