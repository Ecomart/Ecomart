import 'package:notification_permissions/notification_permissions.dart';

import '../../models/entities/fstore_notification_item.dart';

abstract class NotificationService {
  NotificationService();

  late final NotificationDelegate delegate;

  void init({
    /// OneSignal only
    String? externalUserId,
    required NotificationDelegate notificationDelegate,
  });

  Future<bool> requestPermission() async {
    final status = await NotificationPermissions.requestNotificationPermissions(
      iosSettings: const NotificationSettingsIos(
        sound: true,
        badge: true,
        alert: true,
      ),
    );
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isGranted() async {
    final status =
        await NotificationPermissions.getNotificationPermissionStatus();
    if (status == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  void disableNotification();

  void enableNotification();
}

mixin NotificationDelegate {
  void onTapMessage(FStoreNotificationItem notification);

  void onMessage(FStoreNotificationItem notification);
}
