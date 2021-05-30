import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../widget/chatitem.dart' show ChatItem;
import '../models/chat.dart' show Chat;

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
