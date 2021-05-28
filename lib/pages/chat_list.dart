import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/widget/chatitem.dart';
import '../models/chat.dart';

class ChatList extends StatefulWidget {
  final List<Chat> chats;

  ChatList({Key key, this.chats});

  @override
  State<StatefulWidget> createState() => ChatListState(chats);
}

class ChatListState extends State<ChatList> {
  final List<Chat> chats;
  void Function(String) onMsgSent;
  ChatListState(this.chats) {
    onMsgSent = (_) {
      setState(() => null);
    };
  }

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
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) =>
            ChatItem(chatItem: chats[index], onMsgSent: onMsgSent),
      )),
    );
  }
}
