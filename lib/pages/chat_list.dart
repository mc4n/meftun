import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/widget/chatitem.dart';
import '../models/chat.dart';

class ChatList extends StatelessWidget {
  final List<Chat> chats;
  ChatList({Key key, this.chats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _col();
  }

  Column _col() {
    return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 16.0),
      ),
      _expan()
    ]);
  }

  Expanded _expan() {
    return Expanded(
        child: ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: chats.length,
      itemBuilder: (BuildContext context, int index) =>
          ChatItem(chatItem: chats[index]),
    ));
  }
}
