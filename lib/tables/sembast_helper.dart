import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/basemodel.dart' show ModelBase, ModelFrom;
import 'package:me_flutting/tables/dbase_manager.dart';
import 'package:me_flutting/tables/table_base.dart';
import 'package:sembast/sembast.dart' as semba;
import 'package:me_flutting/models/basemodel.dart' show ModelBase;

abstract class SembastHelper<T extends ModelBase>
    implements ModelFrom<T>, TableBase<T> {
  semba.Finder _getFinder(
      {MapEntry<String, dynamic> filter,
      String orderBy,
      int limit,
      int offset}) {
    final finder = semba.Finder();

    if (orderBy != null) {
      var desc = false;
      orderBy =
          (desc = orderBy.startsWith('-')) ? orderBy.substring(1) : orderBy;
      finder.sortOrder = semba.SortOrder(orderBy, !desc);
    }

    if (filter != null) {
      final where = filter.key.substring(2);
      final val = filter.value;
      final oo = () {
        switch (filter.key[0] + filter.key[1]) {
          case '==':
            return semba.Filter.equals(where, val);
          case '>>':
            return semba.Filter.greaterThan(where, val);
          case '>=':
            return semba.Filter.greaterThanOrEquals(where, val);
          case '<<':
            return semba.Filter.lessThan(where, val);
          case '<=':
            return semba.Filter.lessThanOrEquals(where, val);
          case '!=':
            return semba.Filter.notEquals(where, val);
          case '??':
            return semba.Filter.isNull(where);
          case '!?':
            return semba.Filter.notNull(where);
          case '*_':
            return semba.Filter.matches(where, '^' + val);
          case '_*':
            return semba.Filter.matches(where, val + '\$');
          default:
            return semba.Filter.equals(filter.key, val);
        }
      };

      finder.filter = oo();
    }

    finder.limit = limit;
    finder.offset = offset;

    return finder;
  }

  @override
  Future<List<T>> list(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      int limit,
      int offset}) async {
    return (await store.find(await manager.dbase,
            finder: _getFinder(
                orderBy: orderBy,
                filter: filter,
                limit: limit,
                offset: offset)))
        .map((i) => modelFrom(i.value))
        .toList();
  }

  @override
  Future<T> first(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      int limit,
      int offset}) async {
    final mp = await store.findFirst(await manager.dbase,
        finder: _getFinder(orderBy: orderBy, filter: filter));

    return mp?.value != null ? modelFrom(mp.value) : null;
  }

  Future<List<int>> _listKeys(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      int limit,
      int offset}) async {
    return (await store.find(await manager.dbase,
            finder: _getFinder(
                orderBy: orderBy,
                filter: filter,
                limit: limit,
                offset: offset)))
        .map((i) => i.key)
        .toList();
  }

  Future<int> _firstKey(
      {String orderBy, MapEntry<String, dynamic> filter}) async {
    return (await store.findFirst(await manager.dbase,
            finder: _getFinder(orderBy: orderBy, filter: filter)))
        ?.key;
  }

  @override
  Future<bool> deleteAll(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      int limit,
      int offset}) async {
    final ke = await _listKeys(
        orderBy: orderBy, filter: filter, limit: limit, offset: offset);
    if (ke == null || ke.length == 0) return false;
    final res = await store.records(ke).delete(await manager.dbase);
    return res.length == ke.length;
  }

  @override
  Future<bool> deleteOne(
      {String orderBy, MapEntry<String, dynamic> filter}) async {
    final ke = await _firstKey(orderBy: orderBy, filter: filter);
    if (ke == null) return false;
    final res = await store.record(ke).delete(await manager.dbase);
    return res > 0;
  }

  @override
  Future<bool> updateAll(List<Map<String, Object>> values,
      {String orderBy,
      MapEntry<String, dynamic> filter,
      int limit,
      int offset}) async {
    final ke = await _listKeys(
        orderBy: orderBy, filter: filter, limit: limit, offset: offset);
    if (ke == null) return false;
    final res = await store.records(ke).update(await manager.dbase, values);
    return res.length > 0;
  }

  @override
  Future<bool> updateOne(Map<String, Object> value,
      {String orderBy, MapEntry<String, dynamic> filter}) async {
    final ke = await _firstKey(orderBy: orderBy, filter: filter);
    if (ke == null) return false;
    final res = await store.record(ke).update(await manager.dbase, value);
    return res != null;
  }

  @override
  Future<bool> insert(T item) async =>
      (await store.add(await manager.dbase, item.map)) > 0;

  SembastDbManager get manager;

  semba.StoreRef<int, Map<String, Object>> get store;
}
