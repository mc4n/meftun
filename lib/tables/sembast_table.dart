import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/basemodel.dart' show ModelBase, ModelFrom;
import 'package:me_flutting/tables/table_base.dart' show TableBase;
import 'package:me_flutting/tables/dbase_manager.dart';
import 'package:sembast/sembast.dart' as semba;

abstract class SembastTable<T extends ModelBase>
    implements ModelFrom<T>, TableBase<T> {
  @override
  Future<List<T>> select({int pageNum = 0, String orderBy}) async {
    return (await store.find(await manager.dbase))
        .map((i) => modelFrom(i.value))
        .toList();
  }

  @override
  Future<List<T>> selectWhere(String _where, List<dynamic> whereArgs,
      {int pageNum = 0, String orderBy}) async {
    final finder = semba.Finder(
        filter: semba.Filter.equals(_where, whereArgs[0]),
        sortOrders: [semba.SortOrder(orderBy)]);
    return (await store.find(await manager.dbase, finder: finder))
        .map((i) => modelFrom(i.value))
        .toList();
  }

  @override
  Future<T> single(String _where, List<dynamic> whereArgs,
      {String orderBy}) async {
    final finder = semba.Finder(
        filter: semba.Filter.equals(_where, whereArgs[0]),
        sortOrders: [semba.SortOrder(orderBy, false)]);

    final res = (await store.findFirst(await manager.dbase, finder: finder));

    return res != null ? modelFrom(res.value) : null;
  }

  @override
  Future<bool> insert(T item) async =>
      (await store.add(await manager.dbase, item.map)) > 0;

  @override
  Future<bool> deleteWhere(String _where, List<dynamic> whereArgs) async {
    final finder =
        semba.Finder(filter: semba.Filter.equals(_where, whereArgs[0]));
    return (await store.delete(await manager.dbase, finder: finder)) > 0;
  }

  @override
  Future<bool> delete(String id) async => deleteWhere('id', [id]);

  SembastDbManager get manager;

  semba.StoreRef<int, Map<String, Object>> get store;
}
