import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:meftun/views/pages/main.dart' show MainPage;
import 'package:meftun/tables/chattable.dart';
import 'package:meftun/tables/messagetable.dart';
import 'package:meftun/tables/dbase_manager.dart';
import 'package:meftun/types/directchat.dart';
import 'package:meftun/helpers/bot_context.dart' show fillDefaultBots;

const APP_TITLE = 'Meftune';
DirectChat meSession;
TableStorage storage = SembastDbManager(true);

extension MyStorage on TableStorage {
  ChatTable get chatTable =>
      table('chats', tableBuilder: (m, [_]) => SembastChatTable(m, _));

  MessageTable get messageTable =>
      table('messages', tableBuilder: (m, [_]) => SembastMessageTable(m, _));
}

Future<bool> initDefaults() async {
  fillDefaultBots(storage.chatTable);
  final me = DirectChat('1', 'admin');
  if (await storage.chatTable.first(key: me.id) == null)
    await storage.chatTable.insertChat(me);
  meSession = me;
  return true;
}

void main() {
  runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: APP_TITLE,
      home: FutureBuilder<bool>(
          future: initDefaults(),
          builder: (_, __) {
            if (__.hasData && __.data) {
              return const MainPage(APP_TITLE);
            }
            return Center(child: Container(child: Image.asset('logo.png')));
          })));
}
