import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart' show ModelBase;
import 'table_helpers.dart' show SqlTableHelper;

class SqlDbaseContext {
  final String dbname;
  Database _db;
  Map<String, SqlTableHelper> _thelps;
  SqlDbaseContext(this.dbname);

  void putTableHelper(SqlTableHelper helper) {
    if (_thelps == null) _thelps = Map();
    _thelps.putIfAbsent(helper.tableName, () => helper);
  }

  static Map<String, SqlDbaseContext> _inst;

  static SqlDbaseContext instance([String dbaseName = 'demo.db']) {
    if (_inst == null) _inst = Map();
    return _inst.putIfAbsent(dbaseName, () => SqlDbaseContext(dbaseName));
  }

  Future<Database> open() async {
    return _db ??
        (_db = await openDatabase(
          join(await getDatabasesPath(), dbname),
          version: 1,
          onCreate: (_, __) async {
            for (final _cmd in _thelps.values)
              await _.execute(_cmd.generatorCommand);
          },
        ));
  }

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
      (await open())
          .update(table, item.map, where: where, whereArgs: whereArgs);

  Future<int> delete(
          String table, String where, List<dynamic> whereArgs) async =>
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
}
