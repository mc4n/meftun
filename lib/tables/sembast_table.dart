/*import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:path/path.dart';*/
import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/basemodel.dart' show ModelBase, ModelFrom;
import 'package:me_flutting/tables/table_base.dart' show TableBase;

import 'package:me_flutting/tables/dbase_manager.dart';
import 'package:me_flutting/tables/chattable.dart';

abstract class SembastTable<T extends ModelBase>
    implements ModelFrom<T>, TableBase<T> {
/*{
    var key = await store.add(db, {'name': 'Table', 'price': 15});

    var value = await store.record(key).get(db);

    await db.close();
}
*/

  @override
  Future<List<T>> select({int pageNum = 0, String orderBy}) async => [];

  @override
  Future<List<T>> selectWhere(String _where, List<dynamic> whereArgs,
          {int pageNum = 0, String orderBy}) async =>
      [];

  @override
  Future<T> single(String _where, List<dynamic> whereArgs,
          {String orderBy}) async =>
      null;

  @override
  Future<bool> insert(T item) async => null;

  @override
  Future<bool> deleteWhere(String _where, List<dynamic> whereArgs) async =>
      false;

  @override
  Future<bool> delete(String id) async => this.name != '';

  SembastDbManager get manager;
}

void main() {
  test('test sembast', () async {
    final _ = SembastDbManager(true);
    final chats =
        _.table('chats', tableFactory: (m, [_]) => SembastChatTable(m, _));
    chats.select();
  });
}
