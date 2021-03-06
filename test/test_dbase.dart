import 'package:flutter_test/flutter_test.dart';
import 'package:meftun/core/basemodel.dart';
import 'package:meftun/core/dbase_manager.dart';
import 'package:meftun/core/sembast_helper.dart';
import 'package:meftun/core/table_base.dart';

class TestModel extends ModelBase<String> {
  final String userName;
  final int age;
  TestModel(String id, this.userName, this.age) : super(id: id);

  @override
  Map<String, dynamic> get map => {'user_name': userName, 'age': age};
}

class TestTable extends TableEntity<TestModel, String>
    with SembastHelper<TestModel, String> {
  TestTable(TableStorage manager, String name) : super(name, manager);

  @override
  TestModel modelFrom(String _key, Map<String, dynamic> _map) =>
      TestModel(_key, _map['user_name'], _map['age']);

  @override
  get store => SembastDbManager.getStrMapStore(super.name);
}

void main() {
  TestTable myTestTable = SembastDbManager(false)
      .table('tbTest', tableBuilder: (man, [name]) => TestTable(man, name));

  test('test table cursor', () async {
    /* for (var i = 1; i <= 10; i++) 
         await myTestTable.insert(TestModel(null, 'item-$i', i * 10));
    */
    final scanner = myTestTable.createCursor(7);
    int counter = 0;
    do {
      final item = await scanner.current;
      /*print('------\n' +
          item
              .map(((i) => i.id + ', ' + i.userName + ', ' + i.age.toString()))
              .join('\n'));*/
      counter += item.length;
    } while (await scanner.moveNext());

    expect(counter, await myTestTable.count());
  });

  /*test('db filter like', () async { 
    final ft =
        MapEntry('||', [MapEntry('**user_name', 'a'), MapEntry('age', 31)]);
    print((await myTestTable.list(filter: ft))
        .map(((i) => i.id + ', ' + i.userName + ', ' + i.age.toString()))
        .join('\n'));
  });

  test('db update test', () async {
    const OLD = 5;
    const NEW = 3;
    final ftChang = MapEntry('==age', OLD);
    final r = await myTestTable.first(filter: ftChang);
    expect(r.age, OLD);
    final newmdl = TestModel(r.userName, NEW);
    final _ = await myTestTable.updateOne(newmdl, [1], filter: ftChang);
    expect(_, true);
    final rv2 = await myTestTable.first(
      filter: MapEntry('age', NEW),
    );
    expect(r, rv2);
    expect(rv2.age, NEW);
  });

  test('filters test', () async {
    final ls = await myTestTable.list(
      orderBy: '-user_name',
      filter:
          MapEntry('&&', [MapEntry('<=age', 7), MapEntry('*_user_name', 'm')]),
    );
    expect(ls.length, 1);
  });

  test('list test table', () async {
    final ls = await myTestTable.list(
      orderBy: '-user_name',
      filter: MapEntry('>=age', 7),
    );
    expect(ls.length, 4);
  });

  test('first test table', () async {
    final v = await myTestTable.first(
      orderBy: 'age',
      filter: MapEntry('<<age', 7),
    );
    expect(v, null);
  });

  test('delete test table', () async {
    final c1 = (await myTestTable.list()).length;

    await myTestTable.insert(TestModel('x', 100));

    final c2 = (await myTestTable.list()).length;
    expect(c1 + 1, c2);

    await myTestTable.deleteOne(filter: MapEntry('user_name', 'x'));

    final c3 = (await myTestTable.list()).length;
    expect(c1, c3);
  });

  test('insert test table', () async {
    final ls = await myTestTable.insert(TestModel(null, 'cem', 14));

    expect(ls, isNot(0));
  });

  test('insert custom key test table', () async {
    final ls = await myTestTable.insert(TestModel(null, 'cemo', 14));

    expect(ls, isNotNull);
  });*/
}
