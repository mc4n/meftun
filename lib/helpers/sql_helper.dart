import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbaseContext {
  final String dbName;
  final List<TableEntity> tableEntities;
  DbaseContext(this.dbName, this.tableEntities);

  Future<Database> _open() async {
    return openDatabase(join(await getDatabasesPath(), dbName),
        version: 1, singleInstance: false, onCreate: (_, __) async {
      await _.execute(''' 
    		create table tb_messages (
						id text primary key not null,
		                body text not null,
		                from_id text not null,
		                chat_group_id text not null,
		                epoch integer not null,
		                mbody_type text not null)
    		''');

      await _.execute(''' 
       			create table tb_chats (
		       	        id text primary key not null,
		                user_name text not null,
		                name text not null,
		                photo_url text not null,
    					_type integer not null)
 			''');
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
  final String name;
  DbaseContext context;
  final List<T> _itemList = [];

  TableEntity(this.name);

  T from(Map<String, dynamic> _map);

  Future<List<T>> select() async {
    return _itemList;
    /*final db = await context._open();
    final maps = await db.query(name);
    await db.close();
    return List.generate(maps.length, (i) => from(maps[i]));*/
  }

  Future<T> single(bool Function(T) predicate) async {
    return _itemList.lastWhere(predicate);
  }

  Future<List<T>> selectWhere(bool Function(T) predicate) async {
    return _itemList.where(predicate).toList();
    /*final db = await context._open();
    final maps = await db.query(name, where: 'id = ?', whereArgs: [id]);
    await db.close();
    return List.generate(maps.length, (i) => from(maps[i]));*/
  }

  Future<void> insert(T item) async {
    _itemList.add(item);
    /*final db = await context._open();
    await db.insert(
      name,
      item.map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return await db.close();*/
  }

  Future<void> delete(String id) async {
    return deleteWhere((_) => _.getId == id);
  }

  Future<void> deleteWhere(bool Function(T) predicate) async {
    while (true) {
      int i = _itemList.lastIndexWhere(predicate);
      if (i == -1) break;
      _itemList.removeAt(i);
    }
    /*final db = await context._open();
    await db.delete(name, where: where, whereArgs: whereArgs);
    return await db.close();*/
  }
}

mixin ModelBase {
  String get getId;
  Map<String, dynamic> get map;
}
