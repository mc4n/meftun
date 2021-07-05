import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/basemodel.dart';
import 'package:me_flutting/tables/dbase_manager.dart';
import 'package:me_flutting/tables/sembast_helper.dart';

class TestModel extends ModelBase {
  final String userName;
  final int age;
  TestModel(this.userName, this.age) : super(id: userName);

  @override
  Map<String, dynamic> get map => {'user_name': userName, 'age': age};
}

class TestTable with SembastHelper<TestModel, int> {
  final String _name;
  final SembastDbManager _manager;
  TestTable(this._manager, [this._name = 'tbTest']);

  @override
  TestModel modelFrom(Map<String, dynamic> _map) =>
      TestModel(_map['user_name'], _map['age']);

  @override
  String get name => _name;

  @override
  SembastDbManager get manager => _manager;

  @override
  get store => SembastDbManager.getIntMapStore(_name);
}

TestTable get myTestTable => SembastDbManager(false)
    .table('tbTest', tableBuilder: (man, [name]) => TestTable(man, name));

void main() {
  test('db filter like', () async {
    final ft =
        MapEntry('||', [MapEntry('**user_name', 'a'), MapEntry('age', 31)]);
    print((await myTestTable.list(filter: ft))
        .map(((i) => i.userName + ', ' + i.age.toString()))
        .join('\n'));
  });

  /*test('db update test', () async {
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
    final ls = await myTestTable.insert(TestModel('memo', 7));

    expect(ls, isNot(0));
  });*/
}
