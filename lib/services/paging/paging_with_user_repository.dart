import 'dart:async';

import '../../models/index.dart';
import '../base_services.dart';
import 'base_page_repository.dart';

abstract class PagingWithUserRepository<T> extends BasePageRepository<T?> {
  Future<PagingResponse<T>>? Function({
    required User user,
    required dynamic cursor,
  }) get requestApi;

  final User user;

  PagingWithUserRepository(this.user);

  @override
  Future<List<T?>?> getData() async {
    if (!hasNext) return <T>[];

    final response = await requestApi(
      cursor: cursor,
      user: user,
    )!;

    // ignore: unnecessary_null_comparison
    if (response == null) return <T>[];

    final data = response.data;

    /// Shopify framework will return cursor
    /// The order framework will not and must to compute page number to call
    cursor = response.cursor ?? cursor;

    updateCursor();

    if (data?.isEmpty ?? true) {
      hasNext = false;
      return <T>[];
    }

    return data;
    // return data.map((json) => parseJson(json)).toList();
  }
}
