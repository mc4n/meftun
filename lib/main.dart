import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '/pages/main.dart' show MainPage;
import '/models/directchat.dart' show DirectChat;
import '/models/groupchat.dart' show GroupChat;
import '/helpers/sql_helper.dart';
import '/helpers/table_helper.dart';
import '/models/mbody.dart' show RawBody;
import '/models/message.dart' show Message;

void main() {
  // temp chats
  final pac = DirectChat('2', 'pac', 'Tupac Shakur', 'pac.jpg');
  final thugs = GroupChat('3', 'THUGS');
  final big = DirectChat('4', 'big', 'Notorious BIG', 'big.jpg');
  myContext.tableEntityOf<ChatTable>().insertChat(meSession);
  myContext.tableEntityOf<ChatTable>().insertChat(pac);
  myContext.tableEntityOf<ChatTable>().insertChat(thugs);
  myContext.tableEntityOf<ChatTable>().insertChat(big);
  //

  // temp messages
  myContext.tableEntityOf<MessageTable>().insertMessage(
      Message('4', RawBody('I warned u.'), big, big, 1542450000000));
  myContext.tableEntityOf<MessageTable>().insertMessage(
      Message('1', RawBody('whutsup bro?'), pac, pac, 1042342000000));
  myContext.tableEntityOf<MessageTable>().insertMessage(
      Message('3', RawBody('yeah, indeed.'), big, thugs, 1622450000000));
  myContext.tableEntityOf<MessageTable>().insertMessage(
      Message('2', RawBody('thug 4 life!'), pac, thugs, 1027675000000));
  //

  runApp(Builder(
      builder: (_) => MaterialApp(
            theme: ThemeData(primarySwatch: Colors.indigo),
            title: 'Mefluttin',
            home: MainPage(),
          )));
}

final meSession = DirectChat('1', 'mcan', 'Mustafa Can', 'can.jpg');

final DbaseContext myContext =
    DbaseContext('myfl.db', [ChatTable(), MessageTable()]);
