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

  chatTable = _.table('chats', tableFactory: (m, [_]) => SembastChatTable(m, _))
      as ChatTable;
  messageTable = _.table('messages',
      tableFactory: (m, [_]) => SembastMessageTable(m, _)) as MessageTable;

  const APP_TITLE = 'Meftune';

  runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: APP_TITLE,
      home: FutureBuilder<DirectChat>(future: () async {
        fillDefaultBots(chatTable);
        await chatTable.delete('1');
        final me = DirectChat('1', 'admin');
        await chatTable.insertChat(me);
        return me;
      }(), builder: (_, __) {
        if (__.hasData && __.data.id == '1') {
          meSession = __.data;
          return const MainPage(APP_TITLE);
        }
        return Text('...');
      })));
}
