import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:inspireui/utils/logs.dart';

import '../../models/entities/index.dart';
import '../../services/notification/notification_service.dart';

class FirebaseNotificationService extends NotificationService {
  final _instance = FirebaseMessaging.instance;

  final String _topicAllDevices = 'fluxstore_channel';

  @override
  void init({
    String? externalUserId,
    required NotificationDelegate notificationDelegate,
  }) {
    delegate = notificationDelegate;
    final startTime = DateTime.now();
    _instance.getToken().then((token) async {
      printLog('[FirebaseCloudMessaging] init FCM token', startTime);
    });
    _instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      delegate.onMessage(FStoreNotificationItem(
        id: message.messageId ?? '',
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        additionalData: message.data,
        date: DateTime.now(),
      ));
    });
  }

  @override
  void disableNotification() {
    _instance.unsubscribeFromTopic(_topicAllDevices);
  }

  @override
  void enableNotification() {
    _instance.subscribeToTopic(_topicAllDevices);
  }
}
