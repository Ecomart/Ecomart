import 'dart:io' show Directory, sleep;

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../../tools/tools.dart';

final _time = DateTime.now();
const _showPhoneNumber = false;
const _registerPhoneNumber = '0987654321';
const _registerPassword = '';
final _registerEmail = 'test${_time.millisecondsSinceEpoch / 1000}@test.test';

void main() {
  group('FluxStore App', () {
    final mainTabBar = find.byValueKey('mainTabBar');

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

    /// Onboarding → Select Language Vietnam → Registration screen
    /// → Register Account using email/password.
    test('Register testing.', () async {
      await driver.shot('register-onboarding');
      final changeLangButton = find.byValueKey('changeLanguageIconButton');
      await driver.waitFor(changeLangButton);
      await driver.tap(changeLangButton);
      sleep(const Duration(seconds: 3));
      await driver.shot('register-onboarding-change-language');

      final languageList = find.byValueKey('changeLanguageList');
      final vietnameseButton = find.byValueKey('changeLanguageToVietnam');

      await driver.scrollUntilVisible(languageList, vietnameseButton,
          dyScroll: -300.0);

      await driver.tap(vietnameseButton);
      await driver.shot('register-onboarding-vietnamese');

      sleep(const Duration(seconds: 15));

      await driver.waitFor(find.text('Bỏ qua'));
      await driver.tap(find.text('Bỏ qua'));

      await driver.waitFor(find.text('Đăng ký'));
      await driver.tap(find.text('Đăng ký'));
      sleep(const Duration(seconds: 3));
      await driver.shot('register-before-enter');

      final firstNameField = find.byValueKey('registerFirstNameField');
      final lastNameField = find.byValueKey('registerLastNameField');
      final phoneField = find.byValueKey('registerPhoneField');
      final emailField = find.byValueKey('registerEmailField');
      final passwordField = find.byValueKey('registerPasswordField');
      final confirmCheckbox = find.byValueKey('registerConfirmCheckbox');
      final submitButton = find.byValueKey('registerSubmitButton');

      await driver.waitFor(firstNameField);
      await driver.tap(firstNameField);
      await driver.enterText('Test Driver');

      await driver.tap(lastNameField);
      await driver.enterText('${_time.millisecondsSinceEpoch / 1000}');

      if (_showPhoneNumber) {
        await driver.tap(phoneField);
        await driver.enterText(_registerPhoneNumber);
      }

      await driver.tap(emailField);
      await driver.enterText(_registerEmail);

      await driver.tap(passwordField);
      await driver.enterText(_registerPassword);

      await driver.tap(confirmCheckbox);
      await driver.shot('register-before-submit');

      await driver.tap(submitButton);

      await driver.waitFor(mainTabBar);
      await driver.shot('register-home');

      expect(1, 1);
    });
  }, timeout: const Timeout(Duration(minutes: 3)));
}
