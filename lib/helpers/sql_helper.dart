import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database db;
Future<Database> open(String dbName) async {
  db = db ??
      await openDatabase(join(await getDatabasesPath(), dbName), version: 1,
          onCreate: (_, __) async {
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
  return db;
}

Future<String> queryRaw(String queryText) async {
  final q = await db.rawQuery(queryText);
  return q.join(',');
}

Future<void> insertRaw(String cmdText) async {
  await db.rawInsert(cmdText);
}

Future<void> updateRaw(String cmdText) async {
  await db.rawUpdate(cmdText);
}

Future<void> deleteRaw(String cmdText) async {
  await db.rawDelete(cmdText);
}

/*abstract class PersistentTableEntity<T extends ModelBase> {
  final String name;
  Database dbase;
  PersistentTableEntity(this.name);
}*/

abstract class TableEntity<T extends ModelBase> {
  final List<T> _itemList = [];
  final String tableName;
  TableEntity(this.tableName);

  T from(Map<String, dynamic> _map);

  Future<List<T>> select() async {
    return _itemList;
  }

  Future<T> single(bool Function(T) predicate) async {
    return (await select()).lastWhere(predicate);
  }

  Future<List<T>> selectWhere(bool Function(T) predicate) async {
    return (await select()).where(predicate).toList();
  }

  Future<void> insert(T item) async {
    _itemList.add(item);
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
  }
}

mixin ModelBase {
  String get getId;
  Map<String, dynamic> get map;
}
