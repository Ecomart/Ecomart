import 'package:flutter/cupertino.dart';

import '../services/paging/base_page_repository.dart';

abstract class PagingDataProvider<T> extends ChangeNotifier {
  List<T>? get data => _data;

  bool get isLoading => _isLoading;

  bool get hasNext => dataRepo!.hasNext;

  final BasePageRepository? dataRepo;

  PagingDataProvider({this.dataRepo});

  List<T>? _data;

  bool _isLoading = false;

  Future<void> getData() async {
    if (_isLoading) return;
    if (!hasNext) {
      _isLoading = true;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500), () {
        _isLoading = false;
      });
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();

    final _apiData = await dataRepo!.getData();

    _data = [..._data ?? [], ..._apiData as Iterable<T>? ?? []];
    await Future.delayed(const Duration(milliseconds: 300), () {
      _isLoading = false;
    });
    notifyListeners();
  }

  Future<void> refresh() {
    dataRepo!.refresh();
    _data = null;
    notifyListeners();
    return Future.delayed(const Duration(milliseconds: 300), getData);
  }
}
