import 'package:me_flutting/models/basemodel.dart' show ModelBase, ModelFrom;
import 'package:me_flutting/tables/table_base.dart' show TableBase;

abstract class SafeTable<T extends ModelBase>
    implements ModelFrom<T>, TableBase<T> {
  List<Map<String, dynamic>> _itemStore = [];

  @override
  Future<List<T>> select({int pageNum = 0, String orderBy}) async =>
      _itemStore.map((m) => modelFrom(m)).toList();

  @override
  Future<List<T>> selectWhere(String _where, List<dynamic> whereArgs,
      {int pageNum = 0, String orderBy}) async {
    if (whereArgs.length == 1) {
      final ls = _itemStore.where((m) => m[_where] == whereArgs[0]);
      return ls.map((m) => modelFrom(m)).toList();
    } else
      return throw Exception('yorma beni birader!');
  }

  @override
  Future<T> single(String _where, List<dynamic> whereArgs,
      {String orderBy}) async {
    final ls = await selectWhere(_where, whereArgs, orderBy: orderBy);
    return ls != null && ls.length > 0 ? ls.last : null;
  }

  @override
  Future<bool> insert(T item) async {
    _itemStore.add(item.map);
    return exists('id', item.getId);
  }

  @override
  Future<bool> deleteWhere(String _where, List<dynamic> whereArgs) async {
    if (whereArgs.length == 1) {
      _itemStore.removeWhere((m) => m[_where] == whereArgs[0]);
      return !(await exists(_where, whereArgs[0]));
    } else
      return throw Exception('yorma beni birader!');
  }

  @override
  Future<bool> delete(String id) async => deleteWhere('id', [id]);

  Future<bool> exists(String key, dynamic value) async =>
      _itemStore.any((m) => m[key] == value);
}
