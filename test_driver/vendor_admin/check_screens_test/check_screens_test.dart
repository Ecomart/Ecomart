// // Imports the Flutter Driver API.
// import 'dart:io' show Directory, sleep;
//
// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:test/test.dart';
//
// import '../../tools/tools.dart';
//
// var _CHECK_SCREENS_SCREENSHOT_DIR = '${Directory.current.path}/screenshots';
//
// void main() {
//   group('Vendor Admin App', () {
//     // First, define the Finders and use them to locate widgets from the
//     // test suite. Note: the Strings provided to the `byValueKey` method must
//     // be the same as the Strings we used for the Keys in step 1.
//
//     final vendorAdminLoginUsername =
//         find.byValueKey('vendorAdminLoginUsername');
//     final vendorAdminLoginPassword =
//         find.byValueKey('vendorAdminLoginPassword');
//     final vendorAdminHomeText = find.byValueKey('vendorAdminHomeText');
//     final vendorAdminLoginButton = find.byValueKey('vendorAdminLoginButton');
//     FlutterDriver driver;
//
//     // Connect to the Flutter driver before running any tests.
//     setUpAll(() async {
//       await Directory(_CHECK_SCREENS_SCREENSHOT_DIR).create();
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
//     test('login vendor', () async {
//       await driver.waitFor(vendorAdminLoginUsername);
//       log('type username');
//       await driver.tap(vendorAdminLoginUsername);
//       await driver.enterText('vendor@demo.com');
//       log('type password');
//       await driver.tap(vendorAdminLoginPassword);
//       await driver.enterText('demo');
//       log('tap login');
//       await driver.tap(vendorAdminLoginButton);
//       await takeScreenshot(driver, '$_CHECK_SCREENS_SCREENSHOT_DIR/login.png');
//       sleep(const Duration(seconds: INIT_DELAY));
//       await takeScreenshot(
//           driver, '$_CHECK_SCREENS_SCREENSHOT_DIR/mainScreen.png');
//       log('main screen');
//       expect(vendorAdminHomeText, vendorAdminHomeText);
//     });
//
//     final seeAllOrdersButton = find.byValueKey('seeAllOrdersButton');
//     final allOrdersBackButton = find.byValueKey('allOrdersBackButton');
// //    final showFilterOrderOptionButton =
// //        find.byValueKey('showFilterOrderOptionButton');
//
//     var listKeyTab = [
//       'dashboardTab',
//       'productsTab',
//       'notificationsTab',
//       'reviewsTab',
//       'chatListTab',
//       'settingsTab'
//     ];
//
//     test('check screens', () async {
//       const successCase = 7;
//       var caseCount = 0;
//
//       /// Check all Orders Screen
//       await driver.tap(seeAllOrdersButton);
//       sleep(const Duration(seconds: ACTION_DELAY));
//       await takeScreenshot(
//           driver, '$_CHECK_SCREENS_SCREENSHOT_DIR/allOrdersScreen.png');
//       await driver.tap(allOrdersBackButton);
//       caseCount++;
//       sleep(const Duration(seconds: ACTION_DELAY));
//
//       /// Check all screens
//       for (var tabKey in listKeyTab) {
//         final tab = find.byValueKey(tabKey);
//         if (tab != null) {
//           await driver.tap(tab);
//           sleep(const Duration(seconds: ACTION_DELAY));
//           await takeScreenshot(
//               driver, '$_CHECK_SCREENS_SCREENSHOT_DIR/$tabKey.png');
//           caseCount++;
//         }
//       }
//
//       expect(successCase, caseCount);
//     }, timeout: Timeout.none);
//   });
// }
