import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'chatitem.dart' show ChatItem;
import '../models/chat.dart' show Chat;
import '../main.dart';
import '../helpers/table_helper.dart';

class ChatList extends StatefulWidget {
  final bool Function(ChatModel) filter;
  final void Function(String) onMsgSent;
  const ChatList(this.filter, this.onMsgSent, [Key key]);
  @override
  State<StatefulWidget> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatModel>>(
      future: chatTable.selectWhere(widget.filter),
      builder: (BuildContext bc, AsyncSnapshot<List<ChatModel>> snap) {
        if (snap.hasData)
          return _expan(snap.data.map((m) => m.toChat()).toList());
        else
          return Text('no item');
      },
    );
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
            ChatItem(chats[index], widget.onMsgSent),
      )),
    );
  }
}
