import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/basemodel.dart' show ModelBase, ModelFrom;
import 'package:me_flutting/tables/dbase_manager.dart';
import 'package:me_flutting/tables/table_base.dart';
import 'package:sembast/sembast.dart' as semba;
import 'package:me_flutting/models/basemodel.dart' show ModelBase;

abstract class SembastHelperV2<T extends ModelBase>
    implements ModelFrom<T>, TableBase<T> {
  @override
  Future<bool> insert(T item) async =>
      (await store.add(await manager.dbase, item.map)) > 0;

  semba.Finder _getFinder({MapEntry<String, Object> filter, String orderBy}) {
    final finder = semba.Finder();

    if (orderBy != null) {
      var desc = false;
      orderBy =
          (desc = orderBy.startsWith('-')) ? orderBy.substring(1) : orderBy;
      finder.sortOrder = semba.SortOrder(orderBy, !desc);
    }

    if (filter != null)
      finder.filter = semba.Filter.equals(filter.key, filter.value);

    return finder;
  }

  Future<List<T>> list({String orderBy}) async {
    return (await store.find(await manager.dbase,
            finder: _getFinder(orderBy: orderBy)))
        .map((i) => modelFrom(i.value))
        .toList();
  }

  @override
  Future<List<T>> select({int pageNum = 0, String orderBy}) async => null;

  @override
  Future<List<T>> selectWhere(String _where, List<dynamic> whereArgs,
          {int pageNum = 0, String orderBy}) async =>
      null;

  @override
  Future<T> single(String _where, List<dynamic> whereArgs,
          {String orderBy}) async =>
      null;

  @override
  Future<bool> deleteWhere(String _where, List<dynamic> whereArgs) async =>
      null;

  @override
  Future<bool> delete(String id) async => null;

  SembastDbManager get manager;

  semba.StoreRef<int, Map<String, Object>> get store;
}
