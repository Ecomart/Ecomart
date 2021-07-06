import 'dart:io' show Directory, sleep;

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../../tools/tools.dart';

void main() {
  group('FluxStore App', () {
    final mainTabBar = find.byValueKey('mainTabBar');
    final drawerMenu = find.byValueKey('drawerMenu');

    late final FlutterDriver driver;

    /// Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      await Directory(screenshotDir).create();
      driver = await FlutterDriver.connect();
      sleep(const Duration(seconds: 15));
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      await driver.close();
    });

    test('quick screenshot testing', () async {
      await driver.shot('q-onboarding');
      await driver.tap(find.text('Skip'));
      await driver.waitFor(find.text('Done'));
      await driver.tap(find.text('Done'));
      sleep(const Duration(seconds: 15));
      await driver.waitFor(mainTabBar);
      await driver.shot('q-home');
      await driver.waitFor(drawerMenu);
      await driver.tap(drawerMenu);
      await driver.shot('q-drawermenu');

      await driver.tap(find.text('Settings'));
      await driver.shot('q-profile');

      await driver.tap(find.text('LogIn'));
      await driver.shot('q-login');

      await driver.tap(find.text(' Sign up'));
      await driver.shot('q-signup');

      await driver.tap(find.pageBack());
      await driver.tap(find.pageBack());

      await driver.tap(find.text('My Wishlist'));
      await driver.shot('q-mywishlist');

      await driver.tap(find.pageBack());
      await driver.tap(find.text('Languages'));
      await driver.shot('q-languages');

      expect(1, 1);
    });

    test('quick performance test', () async {
      await driver.shot('q-onboarding');
      await driver.tap(find.text('Skip'));
      await driver.waitFor(find.text('Done'));
      await driver.tap(find.text('Done'));
      sleep(const Duration(seconds: 15));
      await driver.waitFor(mainTabBar);
      expect(1, 1);
    });
  }, timeout: const Timeout(Duration(minutes: 2)));
}
