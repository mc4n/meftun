import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/pages/main.dart';
import '../helpers/msghelper.dart';
import '../models/directchat.dart';

MessageFactory msgFactory =
    MessageFactory(DirectChat('mcan', 'Mustafa Can', 'pac.jpg'));

void main() {
  _initTempObjects();
  runApp(Builder(
      builder: (_) => MaterialApp(
            title: 'Mefluttin',
            home: MainPage(),
          )));
}

void _initTempObjects() {
  var me = msgFactory.owner;
  var p1 = msgFactory.addPerson('2pac');
  var p2 = msgFactory.addPerson('bigg');
  var g1 = msgFactory.addGroup('THUGS');
  msgFactory.addPerson('ali');
  msgFactory.addPerson('veli');
  msgFactory.addPerson('ayse');
  msgFactory.addPerson('fatma');
  msgFactory.addGroup('MALLAR');
  var g2 = msgFactory.addGroup('Mentals');

  msgFactory.sendMessage(p1, 'word da f up!');
  msgFactory.receiveMessage(p2, me, 'hi');
  msgFactory.sendMessage(g1, 'morning!');
  msgFactory.receiveMessage(p1, g1, 'thug life bay behh!');
  msgFactory.receiveMessage(p1, g2, '?');
}
