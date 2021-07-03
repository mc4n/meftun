import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/basemodel.dart';
import 'package:me_flutting/tables/dbase_manager.dart';
import 'package:me_flutting/tables/sembast_table.dart';
import 'package:me_flutting/tables/table_base.dart';

class TestModel extends ModelBase {
  final String userName;
  final int age;

  TestModel(this.userName, this.age);

  @override
  String get getId => userName;

  @override
  Map<String, dynamic> get map => throw UnimplementedError();
}

class TestTable extends TableBase<TestModel> with SembastTable<TestModel> {
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
  get store => SembastDbManager.getStore(_name);
}

TestTable get myTestTable => SembastDbManager(false)
    .table('tbTest', tableFactory: (man, [name]) => TestTable(man, name));

void main() {
  test('get test table', () async {
    final myTable = myTestTable;

    expect(myTable, isNotNull);
  });
}
