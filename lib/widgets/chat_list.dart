import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'chatitem.dart' show ChatItem;
import '../models/chat.dart' show Chat;
//import '../main.dart';
//import '../helpers/table_helper.dart';

class ChatList extends StatefulWidget {
  final bool Function(Chat) filter;
  final void Function(String) onMsgSent;

  const ChatList(this.filter, this.onMsgSent, [Key key]);

  @override
  State<StatefulWidget> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  List<Chat> chats = [];

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
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) =>
            ChatItem(chats[index], widget.onMsgSent),
      )),
    );
  }
}
