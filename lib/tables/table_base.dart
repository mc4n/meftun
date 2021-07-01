import 'package:me_flutting/models/basemodel.dart' show ModelBase;

abstract class TableBase<T extends ModelBase> {
  Future<List<T>> select({int pageNum = 0, String orderBy});

  Future<List<T>> selectWhere(String _where, List<dynamic> whereArgs,
      {int pageNum = 0, String orderBy});

  Future<T> single(String _where, List<dynamic> whereArgs, {String orderBy});

  Future<bool> insert(T item);

  Future<bool> deleteWhere(String _where, List<dynamic> whereArgs);

  Future<bool> delete(String id);
}
