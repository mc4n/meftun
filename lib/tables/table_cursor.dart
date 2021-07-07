import 'package:meftun/models/basemodel.dart' show ModelBase;
import 'dart:async';

class TableCursor<T extends ModelBase<Tkey>, Tkey>
    implements StreamIterator<Future<List<T>>> {
  final int limit;
  TableCursor(
    Future<List<T>> Function(
            {String orderBy,
            MapEntry<String, dynamic> filter,
            int limit,
            int offset})
        source,
    int limit, {
    String orderBy,
    MapEntry<String, dynamic> filter,
  }) : limit = limit {
    future = (i) =>
        source(offset: i, orderBy: orderBy, filter: filter, limit: limit);
  }

  Future<List<T>> Function(int offset) future;
  int offset = 0;

  @override
  Future cancel() async {
    offset = 0;
  }

  @override
  Future<List<T>> get current async => await future(offset);

  @override
  Future<bool> moveNext() async {
    offset += limit;
    final listezittin = await future(offset);
    return listezittin != null && listezittin.length != 0;
  }
}
