import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';

void main() {
  test('test sembast', () async {
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join('databases', 'test.db'));

    var key = await store.add(db, {'name': 'Table', 'price': 15});

    var value = await store.record(key).get(db);

    print(value);

    await db.close();
  });
}
