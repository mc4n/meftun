import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '/pages/main.dart' show MainPage;
import '/models/directchat.dart' show DirectChat;
import '/helpers/tables.dart';
import '/models/botchat.dart' show BotChat;
import 'package:flutter/widgets.dart';
import '/models/groupchat.dart' show GroupChat;
import '/models/mbody.dart' show RawBody;
import '/models/message.dart' show Message;

const SAFE_MODE = false;
const APP_TITLE = SAFE_MODE ? 'Meftune(Safe Mode)' : 'Meftune';
final meSession = DirectChat('1', 'mcan', name: 'Mustafa Can');

ChatTable chatTable;
MessageTable messageTable;

void main() {
  chatTable = SAFE_MODE ? SafeChatTable() : SqlChatTable();
  messageTable = SAFE_MODE ? SafeMessageTable() : SqlMessageTable();

  if (!SAFE_MODE) WidgetsFlutterBinding.ensureInitialized();

  chatTable.insertChat(meSession);

  final botEfendi = BotChat('5', meSession, 'efendi', name: 'Bot Efendi');
  chatTable.insertChat(botEfendi);
  chatTable.insertChat(BotChat('6', botEfendi, 'api', name: 'API helper bot'));
  chatTable
      .insertChat(BotChat('7', botEfendi, 'sql', name: 'SQLite helper bot'));

  if (SAFE_MODE) {
    final pac = DirectChat('2', 'pac', name: 'Tupac Shakur');
    final thugs = GroupChat('3', 'THUGS');
    final big = DirectChat('4', 'big', name: 'Notorious BIG');

    chatTable.insertChat(pac);
    chatTable.insertChat(thugs);
    chatTable.insertChat(big);

    messageTable.insertMessage(Message(
        '4', RawBody('maan, f this sh.'), meSession, big, 1542450000000));
    messageTable.insertMessage(
        Message('1', RawBody('whutsup bro?'), pac, pac, 1042342000000));
    messageTable.insertMessage(
        Message('3', RawBody('yeah, indeed.'), big, thugs, 1622450000000));
    messageTable.insertMessage(
        Message('2', RawBody('thug 4 life!'), pac, thugs, 1027675000000));
  }

  runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: APP_TITLE,
      home: MainPage()));
}
