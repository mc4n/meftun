import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:me_flutting/views/pages/main.dart' show MainPage;
import 'package:me_flutting/tables/chattable.dart';
import 'package:me_flutting/tables/messagetable.dart';
import 'package:me_flutting/tables/dbase_manager.dart';
import 'package:me_flutting/helpers/bot_context.dart' show fillDefaultBots;

final meSession = SafeChatTable.mockSessionOwner;
ChatTable chatTable;
MessageTable messageTable;

void main() {
  const SAFE_MODE = false;

  final _ = SembastDbManager(true);
  final chats =
      _.table('chats', tableFactory: (m, [_]) => SembastChatTable(m, _));
  final messages =
      _.table('messages', tableFactory: (m, [_]) => SembastMessageTable(m, _));

  chatTable = SAFE_MODE ? SafeChatTable() : chats;
  messageTable = SAFE_MODE ? SafeMessageTable() : messages;

  /*if (!SAFE_MODE) {
    WidgetsFlutterBinding.ensureInitialized();
    chatTable.insertChat(meSession);
    fillDefaultBots(chatTable);
  }*/

  const APP_TITLE = SAFE_MODE ? 'Meftune(Safe Mode)' : 'Meftune';
  runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: APP_TITLE,
      home: const MainPage(APP_TITLE)));
}
