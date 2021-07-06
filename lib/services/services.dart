import '../frameworks/woocommerce/services/woo_mixin.dart';
import '../modules/firebase/firebase_service.dart';
import 'service_config.dart';

class Services with ConfigMixin, WooMixin {
  static final Services _instance = Services._internal();

  factory Services() => _instance;

  Services._internal();

  // final firebase = BaseFirebaseServices();
  final firebase = FirebaseServices();
}
