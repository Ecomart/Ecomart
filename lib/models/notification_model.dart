import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';

import '../common/constants.dart';
import '../services/dependency_injection.dart';
import '../services/notification/notification_service.dart';
import 'entities/fstore_notification.dart';
import 'entities/fstore_notification_item.dart';

class NotificationModel extends ChangeNotifier {
  final _storage = LocalStorage(LocalStorageKey.app);
  final _service = injector<NotificationService>();
  FStoreNotification _fStoreNotification = const FStoreNotification();

  bool get enable => _fStoreNotification.enable;

  List<FStoreNotificationItem> get listNotification =>
      _fStoreNotification.listNotification;

  void loadData() async {
    await _storage.ready.then((value) async {
      final data = _storage.getItem(LocalStorageKey.notification);
      if (data != null) {
        _fStoreNotification = FStoreNotification.fromJson(data);
      }
      if (!(await _service.isGranted())) {
        disableNotification();
      }
    });
  }

  void markAsRead(String notificationId) {
    _setStatusMessage(notificationId: notificationId, seen: true);
  }

  void markAsUnread(String notificationId) {
    _setStatusMessage(notificationId: notificationId, seen: false);
  }

  void removeMessage(String notificationId) {
    final notifications = _fStoreNotification.listNotification;
    notifications.removeWhere((element) => element.id == notificationId);
    _fStoreNotification.copyWith(listNotification: notifications);
    notifyListeners();
    _saveDataToLocal();
  }

  void saveMessage(FStoreNotificationItem item) {
    final notifications = _fStoreNotification.listNotification;
    notifications.add(item);
    _fStoreNotification =
        _fStoreNotification.copyWith(listNotification: notifications);
    notifyListeners();
    _saveDataToLocal();
  }

  void checkGranted() async {
    final isGranted = await _service.isGranted();
    if (isGranted != enable) {
      if (isGranted) {
        enableNotification();
      } else {
        disableNotification();
      }
    }
  }

  void enableNotification() async {
    if (!(await _service.isGranted())) {
      final granted = await _service.requestPermission();
      if (!granted) {
        return;
      }
    }
    _fStoreNotification = _fStoreNotification.copyWith(enable: true);
    _service.enableNotification();
    _saveDataToLocal();
    notifyListeners();
  }

  void disableNotification() {
    _fStoreNotification = _fStoreNotification.copyWith(enable: false);
    _service.disableNotification();
    _saveDataToLocal();
    notifyListeners();
  }

  void _setStatusMessage({required String notificationId, required bool seen}) {
    final notifications = _fStoreNotification.listNotification;
    var index =
        notifications.indexWhere((element) => element.id == notificationId);
    final item = notifications[index];
    notifications[index] = item.copyWith(seen: seen);
    _fStoreNotification =
        _fStoreNotification.copyWith(listNotification: notifications);
    notifyListeners();
    _saveDataToLocal();
  }

  void _saveDataToLocal() {
    _storage.setItem(LocalStorageKey.notification, _fStoreNotification);
  }
}
