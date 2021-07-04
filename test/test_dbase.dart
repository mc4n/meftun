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

class TestTable with SembastHelper<TestModel> {
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
  test('get test table', () async {
    final myTable = myTestTable;

    expect(myTable, isNotNull);
  });
}
