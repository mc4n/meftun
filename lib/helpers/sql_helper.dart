//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';

class DbaseContext {
  final String dbName;
  final List<TableEntity> tableEntities;
  final List<PersistentTableEntity> persistentTableEntities;
  DbaseContext(this.dbName, this.tableEntities, [this.persistentTableEntities]);

  /*Future<Database> _open() async {
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
  }*/

  T tableEntityOf<T extends TableEntity>() {
    for (final _ in tableEntities) {
      if (_ is T) {
        if (_.context == null) _.context = this;
        return _;
      }
    }
    return null;
  }

  /*T persistentTableEntityOf<T extends PersistentTableEntity>() {
    for (final _ in persistentTableEntities) {
      if (_ is T) {
        if (_.dbase == null) _.dbase = ;
        return _;
      }
    }
    return null;
  }*/
}

abstract class PersistentTableEntity<T extends ModelBase> {
  /*final String name;
  Database dbase;
  PersistentTableEntity(this.name);*/
}

abstract class TableEntity<T extends ModelBase> {
  final String name;
  DbaseContext context;
  final List<T> _itemList = [];

  TableEntity(this.name);

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
