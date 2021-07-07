import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:meftun/views/pages/main.dart' show MainPage;
import 'package:meftun/tables/chattable.dart';
import 'package:meftun/tables/messagetable.dart';
import 'package:meftun/tables/dbase_manager.dart';

const WEB_MODE = true;
const APP_TITLE = WEB_MODE ? 'Meftune' : 'Meftun';
final TableStorage storage = SembastDbManager(WEB_MODE);

extension MyStorage on TableStorage {
  String get botmasterId => '0';
  String get adminId => '1';

  ChatTable get chatTable =>
      table('chats', tableBuilder: (m, [_]) => SembastChatTable(m, _));

  MessageTable get messageTable =>
      table('messages', tableBuilder: (m, [_]) => SembastMessageTable(m, _));
}

void main() {
  runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: APP_TITLE,
      home: const MainPage(APP_TITLE)));
}
