import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:me_flutting/views/pages/main.dart' show MainPage;
import 'package:me_flutting/tables/chattable.dart';
import 'package:me_flutting/tables/messagetable.dart';
import 'package:me_flutting/tables/dbase_manager.dart';
import 'package:me_flutting/types/directchat.dart';

final DirectChat meSession = DirectChat('1', 'mca');
ChatTable chatTable;
MessageTable messageTable;

void main() {
  final _ = SembastDbManager(true);

  chatTable = _.table('chats', tableFactory: (m, [_]) => SembastChatTable(m, _))
      as ChatTable;
  messageTable = _.table('messages',
      tableFactory: (m, [_]) => SembastMessageTable(m, _)) as MessageTable;

  const APP_TITLE = 'Meftune';
  runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: APP_TITLE,
      home: const MainPage(APP_TITLE)));
}
