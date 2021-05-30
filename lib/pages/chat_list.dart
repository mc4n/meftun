import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/widget/chatitem.dart';
import '../models/chat.dart';

class ChatList extends StatefulWidget {
  final List<Chat> chats;

  final void Function(String) onMsgSent;

  ChatList({Key key, this.chats, this.onMsgSent});

  @override
  State<StatefulWidget> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return _expan();
  }

  Expanded _expan() {
    return Expanded(
      child: Container(
          //color: Colors.blue.shade400,
          child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: widget.chats.length,
        itemBuilder: (BuildContext context, int index) => ChatItem(
            chatItem: widget.chats[index], onMsgSent: widget.onMsgSent),
      )),
    );
  }
}
