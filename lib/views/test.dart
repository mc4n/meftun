import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meftun/core/basemodel.dart';
import 'package:meftun/core/dbase_manager.dart';
import 'package:meftun/core/sembast_helper.dart';
import 'package:meftun/core/table_base.dart';
import 'package:meftun/core/table_cursor.dart';

class TestModel extends ModelBase<int> {
  final String userName;
  final int age;
  TestModel(int id, this.userName, this.age) : super(id: id);

  @override
  Map<String, dynamic> get map => {'user_name': userName, 'age': age};
}

class TestTable extends TableEntity<TestModel, int>
    with SembastHelper<TestModel, int> {
  TestTable(TableStorage manager, String name) : super(name, manager);

  @override
  TestModel modelFrom(int _key, Map<String, dynamic> _map) =>
      TestModel(_key, _map['user_name'], _map['age']);

  @override
  get store => SembastDbManager.getIntMapStore(super.name);
}

class ListTesting extends StatefulWidget {
  @override
  _ListTestingState createState() =>
      _ListTestingState(TableCursor(_myTestTable.list, 5));

  final TestTable _myTestTable = SembastDbManager(true)
      .table('tbTest', tableBuilder: (man, [name]) => TestTable(man, name));
}

class _ListTestingState extends State<ListTesting> {
  String filterText;
  final TableCursor<TestModel, int> cursor;

  _ListTestingState(this.cursor);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(children: [
      TextField(
        onChanged: (i) {
          filterText = i;
          setState(() {});
        },
      ),
      Row(
        children: [
          _tb(),
          TextButton.icon(
              label: Text('back'),
              onPressed: () async {
                if (await cursor.moveBack()) setState(() {});
              },
              icon: Icon(Icons.arrow_left_rounded)),
          TextButton.icon(
              label: Text('next'),
              onPressed: () async {
                if (await cursor.moveNext()) setState(() {});
              },
              icon: Icon(Icons.arrow_right_rounded)),
        ],
      ),
      FutureBuilder<List<TestModel>>(
          future: cursor?.current,
          builder: (_, snap) {
            if (snap.hasData && snap.data != null && snap.data.length > 0) {
              return Expanded(
                  child: ListView.builder(
                itemCount: snap.data.length,
                itemBuilder: (context, index) {
                  return Text(snap.data[index].userName);
                },
              ));
            } else
              return Text('wait a few moment...');
          })
    ])));
  }

  TextButton _tb() => TextButton(
        child: Text('Fill with the mocks'),
        onPressed: () async {
          for (final i in '''# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
# IntelliJ related
*.iml
*.ipr
*.iws
.idea/
# The .vscode folder contains launch configuration and tasks you configure in
# VS Code which you may wish to be included in version control, so this line
# is commented out by default.
#.vscode/
# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/
# Web related
lib/generated_plugin_registrant.dart
# Symbolication related
app.*.symbols
# Obfuscation related
app.*.map.json
# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release
pubspec.sublime-workspace
/databases/'''
              .split('\n')
              .where((i) => i.trim() != '')
              .toList())
            await widget._myTestTable.insert(TestModel(null, i.toString(), -1));
          setState(() {});
        },
      );
}

void main() {
  runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: 'test list',
      home: ListTesting()));
}
