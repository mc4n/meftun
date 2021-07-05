import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/basemodel.dart' show ModelBase, ModelFrom;
import 'package:me_flutting/tables/dbase_manager.dart';
import 'package:me_flutting/tables/table_base.dart';
import 'package:sembast/sembast.dart' as semba;
import 'package:me_flutting/models/basemodel.dart' show ModelBase;

abstract class SembastHelper<T extends ModelBase<Tkey>, Tkey>
    implements ModelFrom<T, Tkey>, TableBase<T, Tkey> {
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

    semba.Filter _filterBuilder(MapEntry<String, dynamic> f) {
      final where = f.key.substring(2);
      final val = f.value;
      switch (f.key[0] + f.key[1]) {
        case '&&':
          return semba.Filter.and((f.value as List<MapEntry<String, dynamic>>)
              .map((i) => _filterBuilder(i))
              .toList());
        case '||':
          return semba.Filter.or((f.value as List<MapEntry<String, dynamic>>)
              .map((i) => _filterBuilder(i))
              .toList());
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
        case '**':
          return semba.Filter.matches(where, val);
        default:
          return semba.Filter.equals(f.key, val);
      }
    }

    if (filter != null) {
      finder.filter = _filterBuilder(filter);
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
        .map((i) => modelFrom(i.key, i.value))
        .toList();
  }

  @override
  Future<T> first(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      Tkey key,
      int limit,
      int offset}) async {
    final mp = key != null
        ? await store.record(key).getSnapshot(await manager.dbase)
        : await store.findFirst(await manager.dbase,
            finder: _getFinder(orderBy: orderBy, filter: filter));

    return mp?.value != null ? modelFrom(mp.key, mp.value) : null;
  }

  Future<List<Tkey>> _listKeys(
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

  Future<Tkey> _firstKey(
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
      {String orderBy, MapEntry<String, dynamic> filter, Tkey key}) async {
    final ke = key ?? await _firstKey(orderBy: orderBy, filter: filter);
    if (ke == null) return false;
    final _ = store.record(ke);
    if (_ == null) return false;
    final res = await _.delete(await manager.dbase);
    return res != null;
  }

  @override
  Future<bool> updateOne(T item, List<int> changedFieldIndexes,
      {String orderBy, MapEntry<String, dynamic> filter, Tkey key}) async {
    final ke = key ?? await _firstKey(orderBy: orderBy, filter: filter);
    if (ke == null) return false;
    final res = await store
        .record(ke)
        .update(await manager.dbase, item.selectMap(changedFieldIndexes));
    return res != null;
  }

  @override
  Future<bool> insert(T item) async =>
      (item.id != null
          ? await store.record(item.id).add(await manager.dbase, item.map)
          : await store.add(await manager.dbase, item.map)) !=
      null;

  SembastDbManager get manager;

  semba.StoreRef<Tkey, Map<String, Object>> get store;
}
