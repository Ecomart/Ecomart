import '../index.dart' show Config, ConfigType, Services;

abstract class BasePageRepository<T> {
  final service = Services();

  BasePageRepository() {
    initCursor();
  }

  Future<List<T?>?> getData();

  dynamic cursor;

  bool hasNext = true;

  void refresh() {
    hasNext = true;
    cursor = null;
    initCursor();
  }

  void initCursor() {
    if (Config().type != ConfigType.shopify) {
      cursor = 1;
    }
  }

  void updateCursor() {
    // Shopify cursor is String, the rest is int
    if (cursor is! String && cursor != null) {
      cursor++;
    }
  }

// T parseJson(Map<String, dynamic> json);
}
