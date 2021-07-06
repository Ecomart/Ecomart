import 'dart:io' show Directory, sleep;

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../../tools/tools.dart';

const _loginEmail = 'simontest1@inspireui.com';
const _loginPassword = '12345678';

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

    /// Login using username/password → add to cart product → checkout
    /// → Select COD payment → view Product List screen → view product Detail screens
    test('Login testing.', () async {
      await driver.shot('login-onboarding');

      /// Press Skip.
      final skipButton = find.text('Skip');
      await driver.waitFor(skipButton);
      await driver.tap(skipButton);

      /// Press Login.
      final loginButton = find.text('Sign In');
      await driver.scrollIntoView(loginButton);
      await driver.waitFor(loginButton);
      await driver.tap(loginButton);
      sleep(const Duration(seconds: 3));
      await driver.shot('login-before-enter');

      /// Enter login info.
      final emailField = find.byValueKey('loginEmailField');
      final passwordField = find.byValueKey('loginPasswordField');
      final submitButton = find.byValueKey('loginSubmitButton');

      await driver.tap(emailField);
      await driver.enterText(_loginEmail);

      await driver.tap(passwordField);
      await driver.enterText(_loginPassword);

      /// Login.
      await driver.shot('login-after-enter');
      await driver.tap(submitButton);

      await driver.waitFor(mainTabBar);
      await driver.shot('login-home');

      sleep(const Duration(seconds: 5));

      /// Select Bags category.
      final bagsCategory = find.text('Bags');
      await driver.waitFor(bagsCategory);
      await driver.tap(bagsCategory);

      sleep(const Duration(seconds: 10));
      await driver.shot('login-product-list');

      /// Choose Navy Textured Backpack.
      final bagProduct = find.text('\$38.00');
      await driver.waitFor(bagProduct);
      await driver.tap(bagProduct);
      await driver.shot('login-product-details');

      sleep(const Duration(seconds: 10));

      /// Click Buy Now.
      final buyButton = find.text('Buy Now');
      await driver.waitFor(buyButton);
      await driver.tap(buyButton);
      await driver.shot('login-cart');

      /// Change quantity.
      final one = find.text('1');
      await driver.waitFor(one);
      await driver.tap(one);
      await driver.shot('login-cart-change-quantity');

      sleep(const Duration(seconds: 1));

      final five = find.text('5');
      await driver.waitFor(five);
      await driver.tap(five);
      await driver.shot('login-cart-updated');

      final checkoutButton = find.text('CHECKOUT');
      await driver.waitFor(checkoutButton);
      await driver.tap(checkoutButton);
      await driver.shot('login-cart-checkout');

      // TODO(simon): Fill address before go to shipping.

      final shippingTabButton = find.text('SHIPPING');
      await driver.waitFor(shippingTabButton);
      await driver.tap(shippingTabButton);
      await driver.shot('login-cart-checkout-shipping');

      final continueToReviewButton = find.text('CONTINUE TO REVIEW');
      await driver.waitFor(continueToReviewButton);
      await driver.tap(continueToReviewButton);
      await driver.shot('login-cart-checkout-review');

      final paymentTabButton = find.text('PAYMENT');
      await driver.waitFor(paymentTabButton);
      await driver.tap(paymentTabButton);
      await driver.shot('login-cart-checkout-payment');

      final codButton = find.text('Cash on Delivery');
      await driver.waitFor(codButton);
      await driver.tap(codButton);
      await driver.shot('login-cart-checkout-payment-cod');

      final listView = find.byValueKey('checkOutScreenListView');
      await driver.waitFor(listView);

      final placeOrderButton = find.text('PLACE MY ORDER');
      await driver.scrollUntilVisible(listView, placeOrderButton,
          dyScroll: -300.0);
      await driver.waitFor(placeOrderButton);
      await driver.tap(placeOrderButton);
      await driver.shot('login-cart-checkout-payment-place-order');

      sleep(const Duration(seconds: 5));

      final showOrderedButton = find.text('SHOW ALL MY ORDERED');
      await driver.waitFor(showOrderedButton);
      await driver.tap(showOrderedButton);

      sleep(const Duration(seconds: 10));

      await driver.shot('login-order-history');

      expect(1, 1);
    });
  }, timeout: const Timeout(Duration(minutes: 3)));
}
