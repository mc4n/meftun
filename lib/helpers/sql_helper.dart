import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart' show ModelBase;

const DB_NAME = 'demo.db';

Database _db;

Future<Database> open() async =>
    _db ??
    (_db = await openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      version: 1,
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
      },
    ));

Future<List<T>> query<T extends ModelBase>(
        String table, T Function(Map<String, Object>) translator,
        {String where,
        List<dynamic> whereArgs,
        int limit,
        int offset,
        String orderBy,
        bool distinct,
        String groupBy,
        String having}) async =>
    (await (await open()).query(table,
            limit: limit,
            offset: offset,
            orderBy: orderBy,
            distinct: distinct,
            where: where,
            whereArgs: whereArgs,
            having: having))
        .map(translator)
        .toList();

Future<int> insert<T extends ModelBase>(String table, T item) async =>
    (await open()).insert(table, item.map);

Future<int> update<T extends ModelBase>(
        String table, T item, String where, List<dynamic> whereArgs) async =>
    (await open()).update(table, item.map, where: where, whereArgs: whereArgs);

Future<int> delete(String table, String where, List<dynamic> whereArgs) async =>
    (await open()).delete(table, where: where, whereArgs: whereArgs);

//----------FOLLOWINGS ARE FOR BOT USES------------------
Future<int> deleteAsText(
        String table, String where, List<String> whereArgs) async =>
    (await open()).delete(table, where: where, whereArgs: whereArgs);

Future<String> queryAllAsText(String table) async =>
    (await (await open()).query(table)).join(',\n');

Future<String> queryAsText(String table, int limit, int offset) async =>
    (await (await open()).query(table, limit: limit, offset: offset))
        .join(',\n');

Future<String> queryWhereAsText(String table, String where,
        List<String> whereArgs, int limit, int offset) async =>
    (await (await open()).query(table,
            where: where, whereArgs: whereArgs, limit: limit, offset: offset))
        .join(',\n');

Future<void> execute(String queryText) async =>
    await (await open()).execute(queryText);

Future<String> queryRaw(String queryText) async =>
    (await (await open()).rawQuery(queryText)).join(',\n');

Future<int> insertRaw(String cmdText) async =>
    await (await open()).rawInsert(cmdText);

Future<int> updateRaw(String cmdText) async =>
    await (await open()).rawUpdate(cmdText);

Future<int> deleteRaw(String cmdText) async =>
    await (await open()).rawDelete(cmdText);
