//import 'package:meftun/tables/table_base.dart' show TableBase;
//import 'package:meftun/tables/sembast_helper.dart';
import 'package:meftun/models/basemodel.dart';
import 'package:meftun/tables/table_base.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

abstract class TableStorage {
  Map<String, TableBase> _tables = Map();
  T table<Tkey, Tval extends ModelBase<Tkey>, T extends TableBase<Tval, Tkey>>(
          String key,
          {T Function(TableStorage, [String tbname]) tableBuilder}) =>
      tableBuilder == null
          ? _tables[key]
          : _tables.putIfAbsent(key, () => tableBuilder(this, key));
}

class SembastDbManager extends TableStorage {
  static const DB_NAME = 'demo';

  String get dbPath => join('databases', '$DB_NAME.db');

  static StoreRef<int, Map<String, Object>> getIntMapStore(String nm) =>
      intMapStoreFactory.store(nm);

  static StoreRef<String, Map<String, Object>> getStrMapStore(String nm) =>
      stringMapStoreFactory.store(nm);

  DatabaseFactory get dbFactory =>
      isWeb ? databaseFactoryWeb : databaseFactoryIo;

  final bool isWeb;

  SembastDbManager([this.isWeb = false]);

  Future<Database> get dbase async => await dbFactory.openDatabase(dbPath);
}
