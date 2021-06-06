import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '/pages/main.dart' show MainPage;
//import '/pages/profile.dart' show ProfilePage;
import '/helpers/msghelper.dart' show ChatFactory;
import '/models/directchat.dart' show DirectChat;
import '/models/mbody.dart' show RawBody;
import 'dart:math' show Random;

void main() {
  _initTempObjects();
  runApp(Builder(
      builder: (_) => MaterialApp(
            theme: ThemeData(primarySwatch: Colors.indigo),
            title: 'Mefluttin',
            home: MainPage(), // ProfilePage(chatFactory.ownerFactory),
          )));
}

ChatFactory chatFactory =
    ChatFactory(DirectChat('mcan', 'Mustafa Can', 'pac.jpg'));

void _initTempObjects() {
  chatFactory.addGroup('THUGS');
  final _ = ['2pac', 'bigg', 'cube'];
  _.forEach((__) {
    chatFactory.addPerson(__);
  });
  chatFactory.addGroup('mentals');
  final cts = chatFactory.msgFactories;
  final rnd = Random();
  final exampleMsgs = [
    'Hello World!',
    'The world is mine!',
    'Bang bang',
    'selamun aleyküm'
  ];

  for (final _ in exampleMsgs) {
    final mf = cts.elementAt(rnd.nextInt(cts.length));
    final _msg = mf.addMessageBody(RawBody(_));
    if (rnd.nextInt(2) == 1) mf.addReplyTo(_msg);
  }
}
