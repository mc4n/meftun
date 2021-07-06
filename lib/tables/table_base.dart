import 'package:me_flutting/models/basemodel.dart' show ModelBase;
import 'package:me_flutting/tables/table_cursor.dart';

abstract class TableBase<T extends ModelBase<Tkey>, Tkey> {
  String get name;

  Future<bool> insert(T item);

  TableCursor<T, Tkey> createCursor(int limit,
      {String orderBy, MapEntry<String, dynamic> filter});

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
