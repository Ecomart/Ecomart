import 'package:flutter/services.dart';
import 'package:inspireui/utils/logs.dart';
import 'package:package_info/package_info.dart';
import 'package:universal_platform/universal_platform.dart';

/// For Google Play Services check to prevent app crashing.
class GmsTools {
  /// DO NOT CHANGE THE LINE BELOW.
  static const _isGmsAvailableMethod = 'isGmsAvailable';

  static final GmsTools _instance = GmsTools._internal();

  factory GmsTools() => _instance;

  GmsTools._internal();

  bool? _isGmsAvailable;

  bool get isGmsAvailable {
    if (_isGmsAvailable == null) {
      throw Exception(
          '[GMS Availability]: checkGmsAvailability() needed to call before using GmsTools().isGmsAvailable.');
    }
    return _isGmsAvailable ?? true;
  }

  /// Just need to call this once when app initialize.
  /// Then use GmsTools().isGmsAvailable getter instead.
  Future<bool?> checkGmsAvailability() async {
    final starTime = DateTime.now();
    if (UniversalPlatform.isAndroid) {
      final _packageName = (await PackageInfo.fromPlatform()).packageName;
      final _gmsCheckMethodChannel = '$_packageName/$_isGmsAvailableMethod';
      try {
        final status = await MethodChannel(_gmsCheckMethodChannel)
            .invokeMethod(_isGmsAvailableMethod);
        printLog('[GMS Availability]: ${status.toString()}', starTime);
        _isGmsAvailable = status;
      } on PlatformException {
        printLog('[GMS Availability]: Failed to get isGmsAvailable.', starTime);
      }
    } else {
      /// Just need to check for Android.
      /// Default true for other OS.
      _isGmsAvailable = true;
    }
    return _isGmsAvailable;
  }
}
