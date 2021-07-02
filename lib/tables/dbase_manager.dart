//import 'package:me_flutting/tables/table_base.dart' show TableBase;
import 'package:path/path.dart';
import 'package:me_flutting/tables/sembast_table.dart';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastDbManager {
  static const DB_NAME = 'demo';

  String get dbPath => join('databases', '$DB_NAME.db');

  final StoreRef<int, Map<String, Object>> store = intMapStoreFactory.store();

  DatabaseFactory get dbFactory =>
      isWeb ? databaseFactoryWeb : databaseFactoryIo;

  final bool isWeb;

  SembastDbManager([this.isWeb = false]);

  Map<String, SembastTable> _tables = Map();

  SembastTable table(String key,
          {SembastTable Function(SembastDbManager, [String tbname])
              tableFactory}) =>
      table == null
          ? _tables[key]
          : _tables.putIfAbsent(key, () => tableFactory(this, key));

  Future<Database> get dbase async => await dbFactory.openDatabase(dbPath);
}
