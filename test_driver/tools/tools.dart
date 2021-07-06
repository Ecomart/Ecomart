import 'dart:io' show Directory, File;

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_driver/flutter_driver.dart';

const ACTION_DELAY = 3;
const INIT_DELAY = 10;
void log(message) {
  // ignore: avoid_print
  print(message);
}

Future<void> takeScreenshot(FlutterDriver driver, String path) async {
  try {
    final pixels = await driver.screenshot();
    final file = File(path);
    await file.writeAsBytes(pixels);
    log(path);
  } catch (ex) {
    log(ex);
    log('📛📛📛 could not take the screenshoot');
  }
}

final screenshotDir =
    '${Directory.current.path}/test_driver/fluxstore/screenshots';

extension FlutterDriverExtension on FlutterDriver {
  Future<void> shot(String fileName) async {
    try {
      final pixels = await screenshot();
      final path = '$screenshotDir/$fileName.png';
      final file = File(path);
      await file.writeAsBytes(pixels);
      log(path);
    } catch (ex) {
      log(ex);
      log('📛📛📛 could not take the screenshoot');
    }
  }
}
