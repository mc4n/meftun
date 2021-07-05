import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:me_flutting/views/pages/main.dart' show MainPage;
import 'package:me_flutting/tables/chattable.dart';
import 'package:me_flutting/tables/messagetable.dart';
import 'package:me_flutting/tables/dbase_manager.dart';
import 'package:me_flutting/types/directchat.dart';
import 'package:me_flutting/helpers/bot_context.dart' show fillDefaultBots;

DirectChat meSession;
ChatTable chatTable;
MessageTable messageTable;

void main() {
  final _ = SembastDbManager(true);

  chatTable =
      _.table('chats', tableBuilder: (m, [_]) => SembastChatTable(m, _));
  messageTable =
      _.table('messages', tableBuilder: (m, [_]) => SembastMessageTable(m, _));

  const APP_TITLE = 'Meftune';

  runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: APP_TITLE,
      home: FutureBuilder<DirectChat>(future: () async {
        fillDefaultBots(chatTable);
        final me = DirectChat('1', 'admin');
        await chatTable.deleteChat(me);
        await chatTable.insertChat(me);
        return me;
      }(), builder: (_, __) {
        if (__.hasData && __.data.id == '1') {
          meSession = __.data;
          return const MainPage(APP_TITLE);
        }
        return Center(child: Container(child: Image.asset('logo.png')));
      })));
}
