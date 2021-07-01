import 'package:me_flutting/models/basemodel.dart' show ModelBase, ModelFrom;

typedef FnFrom<T extends ModelBase> = T Function(Map<String, dynamic>);

abstract class TableBaseHelper<T extends ModelBase> {
  Future<List<T>> select({int pageNum = 0, String orderBy});

  Future<List<T>> selectWhere(String _where, List<dynamic> whereArgs,
      {int pageNum = 0, String orderBy});

  Future<T> single(String _where, List<dynamic> whereArgs, {String orderBy});

  Future<bool> insert(T item);

  Future<bool> deleteWhere(String _where, List<dynamic> whereArgs);

  Future<bool> delete(String id);
}

abstract class SafeTableHelper<T extends ModelBase>
    implements ModelFrom<T>, TableBaseHelper<T> {
  List<Map<String, dynamic>> _itemStore = [];

  @override
  Future<List<T>> select({int pageNum = 0, String orderBy}) async =>
      _itemStore.map((m) => modelFrom(m)).toList();

  @override
  Future<List<T>> selectWhere(String _where, List<dynamic> whereArgs,
      {int pageNum = 0, String orderBy = 'id ASC'}) async {
    if (whereArgs.length == 1) {
      final cond = _where.replaceAll('= ?', '').trim();
      final ls = _itemStore.where((m) => m[cond] == whereArgs[0]);
      return ls.map((m) => modelFrom(m)).toList();
    } else
      return throw Exception('yorma beni birader!');
  }

  @override
  Future<T> single(String _where, List<dynamic> whereArgs,
      {String orderBy = 'id ASC'}) async {
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
      final cond = _where.replaceAll('= ?', '').trim();
      _itemStore.removeWhere((m) => m[cond] == whereArgs[0]);
      return !(await exists(cond, whereArgs[0]));
    } else
      return throw Exception('yorma beni birader!');
  }

  @override
  Future<bool> delete(String id) async => deleteWhere('id = ?', [id]);

  Future<bool> exists(String key, dynamic value) async =>
      _itemStore.any((m) => m[key] == value);
}
