import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '/pages/main.dart' show MainPage;
import '/models/directchat.dart' show DirectChat;
import '/helpers/sql_helper.dart';
import '/helpers/table_helper.dart';
//import 'package:flutter/widgets.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  myContext.tableEntityOf<ChatTable>().insertChat(meSession);
  runApp(Builder(
      builder: (_) => MaterialApp(
            theme: ThemeData(primarySwatch: Colors.indigo),
            title: 'Mefluttin',
            home: MainPage(),
          )));
}

final meSession = DirectChat('1', 'mcan', 'Mustafa Can', 'pac.jpg');

final DbaseContext myContext =
    DbaseContext('demo.db', [ChatTable(), MessageTable()]);
