import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/pages/main.dart';
import '../helpers/msghelper.dart';
import '../models/directchat.dart';

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
  var p1 = chatFactory.addPerson('2pac');
  var p2 = chatFactory.addPerson('bigg');
  var g1 = chatFactory.addGroup('THUGS');
  chatFactory.addPerson('ali');
  chatFactory.addPerson('veli');
  chatFactory.addPerson('ayse');
  chatFactory.addPerson('fatma');
  chatFactory.addGroup('MALLAR');

  chatFactory.factoryByChat(p1).receiveMessage(p1, 'word da f up!');
  chatFactory.factoryByChat(p2).receiveMessage(p2, 'hi');

  final msgFactory_2 = chatFactory.factoryByChat(g1);
  msgFactory_2.addMessage('morning!');
  msgFactory_2.receiveMessage(p1, 'thug life bay behh!');
}
