import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/pages/main.dart' show MainPage;
import '../helpers/msghelper.dart' show ChatFactory;
import '../models/directchat.dart' show DirectChat;

ChatFactory chatFactory =
    ChatFactory(DirectChat('mcan', 'Mustafa Can', 'pac.jpg'));

void main() {
  _initTempObjects();
  runApp(Builder(
      builder: (_) => MaterialApp(
            title: 'Mefluttin',
            home: MainPage(),
          )));
}

void _initTempObjects() {
  final peeps = ['2pac', 'bigg', 'cube', 'ali', 'ayse'];
  peeps.forEach((element) {
    chatFactory.addPerson(element);
  });

  var g1 = chatFactory.addGroup('THUGS');

  final msgFact = chatFactory.msgFactories.elementAt(2);

  final body = 'he';

  var msg = msgFact.addMessageBody(body);

  final _ = msgFact.addResponse(msg);

  chatFactory
      .factoryByChat(g1)
      .addMessageBodyFrom(chatFactory.contacts.elementAt(0), 'thug life baby!');
  chatFactory
      .factoryByChat(g1)
      .addMessageBodyFrom(chatFactory.contacts.elementAt(2), 'yeah bro');

  chatFactory.msgFactories.elementAt(0).addMessageBody('pac, are there bro?');

  chatFactory.ownerFactory.addMessageBodyFrom(
      chatFactory.contacts.elementAt(1), 'it was all a dreeam!');
}
