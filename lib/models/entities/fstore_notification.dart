import 'fstore_notification_item.dart';

class FStoreNotification {
  final bool enable;
  final List<FStoreNotificationItem> listNotification;

  const FStoreNotification({
    this.enable = true,
    this.listNotification = const <FStoreNotificationItem>[],
  });

  FStoreNotification copyWith({
    bool? enable,
    List<FStoreNotificationItem>? listNotification,
  }) {
    return FStoreNotification(
      enable: enable ?? this.enable,
      listNotification: List.from(listNotification ?? this.listNotification),
    );
  }

  factory FStoreNotification.fromJson(Map<String, dynamic> json) {
    var listNotification = <FStoreNotificationItem>[];
    if (json['listNotification'] != null) {
      listNotification = List.from(json['listNotification'])
          .map((json) => FStoreNotificationItem.fromJson(json))
          .toList();
    }
    return FStoreNotification(
      enable: json['enable'] ?? true,
      listNotification: listNotification,
    );
  }

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('enable', enable);
    writeNotNull(
        'listNotification', listNotification.map((e) => e.toJson()).toList());
    return val;
  }
}
