import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'chatitem.dart' show ChatItem;
import '../models/chat.dart' show Chat;
import '../main.dart';

class ChatList extends StatefulWidget {
  final String tsea;
  final bool isSearching;
  const ChatList(this.tsea, this.isSearching, [Key key]);
  @override
  State<StatefulWidget> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Chat>>(
      future: widget.isSearching
          ? chatTable.filterChats(widget.tsea)
          : chatTable.chats(),
      builder: (BuildContext bc, AsyncSnapshot<List<Chat>> snap) {
        if (snap.hasData)
          return _expan(snap.data);
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
            ChatItem(chats[index]),
      )),
    );
  }
}
