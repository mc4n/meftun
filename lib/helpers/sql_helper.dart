import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'package:flutter/widgets.dart';

class DbaseContext {
  final String dbName;
  final List<TableEntity> tableEntities;
  DbaseContext(this.dbName, this.tableEntities);

  String get cmdsOnCreate => tableEntities.map((m) => m.createString).join(';');

  Future<String> get dbPath async => join(await getDatabasesPath(), dbName);

  Future<Database> _open() async {
    return openDatabase(await dbPath, version: 1, onCreate: (_, __) async {
      for (final i in tableEntities) {
        await _.execute(i.createString);
      }
    });
  }

  T tableEntityOf<T extends TableEntity>() {
    for (final _ in tableEntities) {
      if (_ is T) {
        if (_.context == null) _.context = this;
        return _;
      }
    }
    return null;
  }
}

abstract class TableEntity<T extends ModelBase> {
  final String scheme;
  final String name;
  DbaseContext context;
  final List<T> _itemList = [];

  TableEntity(this.scheme, this.name);

  String get createString => 'create table $name ($scheme)';

  T from(Map<String, dynamic> _map);

  Future<List<T>> select() async {
    return _itemList;
    /*final db = await context._open();
    final maps = await db.query(name);
    await db.close();
    return List.generate(maps.length, (i) => from(maps[i]));*/
  }

  Future<void> insert(T item) async {
    _itemList.add(item);
    /*final db = await context._open();
    await db.insert(
      name,
      item.map,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return await db.close();*/
  }

  Future<void> delete(String id) async {
    int i = _itemList.indexWhere((_) => _.getId == id);
    _itemList.removeAt(i); //deleteWhere("id = ?", [id]);
  }

  /*Future<void> deleteWhere(String where, List<dynamic> whereArgs) async {
    final db = await context._open();
    await db.delete(name, where: where, whereArgs: whereArgs);
    return await db.close();
  }*/
}

mixin ModelBase {
  String get getId;
  Map<String, dynamic> get map;
}
