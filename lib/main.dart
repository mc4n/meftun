import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '/pages/main.dart' show MainPage;
import '/helpers/tables.dart';
import '/helpers/bot_helper.dart' show fillDefaultBots;

final meSession = SafeChatTable.mockSessionOwner;
ChatTable chatTable;
MessageTable messageTable;

void main() {
  const SAFE_MODE = false;

  chatTable = SAFE_MODE ? SafeChatTable() : SqlChatTable();
  messageTable = SAFE_MODE ? SafeMessageTable() : SqlMessageTable();

  if (!SAFE_MODE) {
    WidgetsFlutterBinding.ensureInitialized();
    chatTable.insertChat(meSession);
    fillDefaultBots(chatTable);
  }

  const APP_TITLE = SAFE_MODE ? 'Meftune(Safe Mode)' : 'Meftune';
  runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: APP_TITLE,
      home: const MainPage(APP_TITLE)));
}
