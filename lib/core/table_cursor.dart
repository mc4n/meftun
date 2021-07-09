import 'package:meftun/core/basemodel.dart' show ModelBase;
import 'dart:async';

typedef FnList<T> = Future<List<T>> Function(
    {String orderBy, MapEntry<String, dynamic> filter, int limit, int offset});

class TableCursor<T extends ModelBase<Tkey>, Tkey> {
  final FnList _source;
  final int _limit;
  final String _orderBy;
  MapEntry<String, dynamic> _filter;

  TableCursor(
    FnList source,
    int limit, {
    String orderBy,
    MapEntry<String, dynamic> filter,
  })  : _limit = limit,
        _filter = filter,
        _orderBy = orderBy,
        _source = source;

  Future<List<T>> _future(int page) {
    return _source(
        filter: _filter,
        limit: _limit,
        offset: page * _limit,
        orderBy: _orderBy);
  }

  int _pageNum = 0;

  set filter(MapEntry<String, dynamic> filter) => _filter = filter;

  void reset() => _pageNum = 0;

  Future<List<T>> get current async => getAt(_pageNum);

  Future<List<T>> getAt(int pageNum) async => (await _future(pageNum)) ?? [];

  Future<bool> seek(int pageNum) async {
    final listezittin = await getAt(pageNum);
    return pageNum >= 0 && listezittin != null && listezittin.length != 0;
  }

  Future<bool> moveBack() async {
    if (_pageNum == 0) return false;
    bool res = await seek(_pageNum - 1);
    if (res) _pageNum--;
    return res;
  }

  Future<bool> moveNext() async {
    bool res = await seek(_pageNum + 1);
    if (res) _pageNum++;
    return res;
  }
}
