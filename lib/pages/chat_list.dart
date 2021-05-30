import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/main.dart';
import '../widget/chatitem.dart' show ChatItem;
import '../models/chat.dart' show Chat;

class ChatList extends StatefulWidget {
  final bool Function(Chat) filter;
  final void Function(String) onMsgSent;

  const ChatList({Key key, this.filter, this.onMsgSent});

  @override
  State<StatefulWidget> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return _expan(msgFactory.contacts.where(widget.filter).toList());
  }

  Expanded _expan(final List<Chat> chats) {
    return Expanded(
      child: Container(
          child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) =>
            ChatItem(chatItem: chats[index], onMsgSent: widget.onMsgSent),
      )),
    );
  }
}
