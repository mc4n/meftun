import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../helpers/msghelper.dart' show MessageFactory;
import '../models/chat.dart' show Chat;
import 'chatitem.dart' show ChatItem;
import '../main.dart' show chatFactory;

class ChatList extends StatefulWidget {
  final bool Function(MessageFactory) filter;
  final void Function(String) onMsgSent;

  const ChatList(this.filter, this.onMsgSent, [Key key]);

  @override
  State<StatefulWidget> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return _expan(chatFactory.msgFactories
        .where(widget.filter)
        .map((m) => m.chatItem)
        .toList());
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
            ChatItem(chatFactory.factoryByChat(chats[index]), widget.onMsgSent),
      )),
    );
  }
}
