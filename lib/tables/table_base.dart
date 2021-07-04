import 'package:me_flutting/models/basemodel.dart' show ModelBase;

abstract class TableBase<T extends ModelBase> {
  String get name;

  Future<bool> insert(T item);

  Future<List<T>> list(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      int limit,
      int offset});

  Future<T> first(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      int limit,
      int offset});

  Future<bool> deleteAll(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      int limit,
      int offset});

  Future<bool> deleteOne({String orderBy, MapEntry<String, dynamic> filter});

  Future<bool> updateAll(List<Map<String, Object>> values,
      {String orderBy,
      MapEntry<String, dynamic> filter,
      int limit,
      int offset});

  Future<bool> updateOne(Map<String, Object> value,
      {String orderBy, MapEntry<String, dynamic> filter});
}
