import 'package:meftun/models/basemodel.dart' show ModelBase;
import 'package:meftun/tables/dbase_manager.dart';
import 'package:meftun/tables/table_cursor.dart';

abstract class TableBase<T extends ModelBase<Tkey>, Tkey> {
  String get name;

  TableStorage get manager;

  Future<bool> insert(T item);

  TableCursor<T, Tkey> createCursor(int limit,
      {String orderBy, MapEntry<String, dynamic> filter});

  Future<int> count({MapEntry<String, dynamic> filter});

  Future<List<T>> list(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      int limit,
      int offset});

  Future<T> first(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      Tkey key,
      int limit,
      int offset});

  Future<bool> deleteAll(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      int limit,
      int offset});

  Future<bool> deleteOne(
      {String orderBy, MapEntry<String, dynamic> filter, Tkey key});

  Future<bool> updateOne(T item, List<int> changedFieldIndexes,
      {String orderBy, MapEntry<String, dynamic> filter, Tkey key});
}
