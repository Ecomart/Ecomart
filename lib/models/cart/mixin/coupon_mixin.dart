import 'package:inspireui/widgets/coupon_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/tools.dart';
import '../../entities/coupon.dart';
import '../cart_base.dart';
import 'cart_mixin.dart';

mixin CouponMixin on CartMixin {
  Coupon? couponObj;
  Discount? _discount;
  String? savedCoupon;

  bool calculatingDiscount = false;

  void resetCoupon() {
    couponObj = null;
    _discount = null;
    clearSavedCoupon();
  }

  Future updateDiscount({Discount? discount, Function? onFinish}) async {
    if (discount != null) {
      _discount = discount;
      couponObj = discount.coupon;
      return;
    }

    if (couponObj == null) {
      _discount = null;
      return;
    }

    calculatingDiscount = true;
    try {
      _discount = await Coupons.getDiscount(
        cartModel: this as CartModel,
        couponCode: couponObj!.code,
      );
      couponObj = _discount?.coupon;
    } catch (_) {
      resetCoupon();
    } finally {
      calculatingDiscount = false;
    }

    if (onFinish != null) {
      onFinish();
    }
  }

  String getCoupon() {
    if (couponObj != null) {
      return '-${PriceTools.getCurrencyFormatted(getCouponCost(), currencyRates, currency: currency)}';
    }
    return '';
  }

  double getCouponCost() {
    return _discount?.discount ?? 0.0;
  }

  Future<void> clearSavedCoupon() async {
    savedCoupon = null;
    final _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.setString('saved_coupon', '');
  }
}
