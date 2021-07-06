// // Imports the Flutter Driver API.
// import 'dart:io' show Directory, sleep;
//
// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:test/test.dart';
//
// import '../../tools/tools.dart';
//
// var _SCREENSHOT_DIR = '${Directory.current.path}/screenshots';
//
// void main() {
//  group('FluxStore App :::', () {
//    final mainTabbar = find.byValueKey('mainTabBar');
//
//    FlutterDriver driver;
//    VmService serviceClient;
//
//    setUpAll(() async {
//      await Directory(_SCREENSHOT_DIR).create();
//      log('Connecting driver');
//      var dartVmServiceUrl = Platform.environment['VM_SERVICE_URL']
//              .replaceFirst(RegExp(r'http:'), 'ws:') +
//          "ws";
//
//      serviceClient = await vmServiceConnectUri(dartVmServiceUrl);
//      final vm = await serviceClient.getVM();
//      vm.isolates.forEach((element) {
//        log('Isolate: ${element.name} ${element.number}');
//      });
//      final mainIsolate = vm.isolates
//          .firstWhere((IsolateRef isolate) => isolate.name == "main");
//      await serviceClient.resume(mainIsolate.id);
//      driver = await FlutterDriver.connect(
//          isolateNumber: int.parse(mainIsolate.number));
//      log('Driver connected');
//    });
//
//    // Close the connection to the driver after the tests have completed.
//    tearDownAll(() async {
//      if (driver != null) {
//        await driver.close();
//      }
//      log('driver closing..');
//      serviceClient.dispose();
//      await serviceClient.onDone;
//      log('service client shut down');
//    });
//
//    test('🚘🚘🚘 Start testing 🏁🏁🏁🏁', () async {
//      await driver.clearTimeline();
//      await driver.runUnsynchronized(() async {
//        await driver.waitFor(mainTabbar);
//        sleep(const Duration(seconds: INIT_DELAY));
//        log('take screenshot home screen to $_SCREENSHOT_DIR/home.png');
//        takeScreenshot(driver, '$_SCREENSHOT_DIR/home.png');
//        sleep(const Duration(seconds: 10));
//        log('done ✅');
//        expect(1, 1);
//      });
//    }, timeout: const Timeout(Duration(minutes: 2)));
//  });
//
//   group('FluxStore App MV', () {
//     // First, define the Finders and use them to locate widgets from the
//     // test suite. Note: the Strings provided to the `byValueKey` method must
//     // be the same as the Strings we used for the Keys in step 1.
//
//     FlutterDriver driver;
//
//     // Connect to the Flutter driver before running any tests.
//     setUpAll(() async {
//       await Directory(_SCREENSHOT_DIR).create();
//       driver = await FlutterDriver.connect();
//       sleep(const Duration(seconds: INIT_DELAY));
//     });
//
//     // Close the connection to the driver after the tests have completed.
//     tearDownAll(() async {
//       if (driver != null) {
//         await driver.close();
//       }
//     });
//
//     var success = 0;
//     test('take homescreen screenshot', () async {
//       sleep(const Duration(seconds: INIT_DELAY));
//       log('tab bars show up');
//       success++;
//       sleep(const Duration(seconds: INIT_DELAY));
//       await takeScreenshot(driver, '$_SCREENSHOT_DIR/home.png');
//       log('take screen shot main screen');
//       success++;
//       expect(success, 2);
//     });
//   });
// }
