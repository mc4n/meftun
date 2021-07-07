import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'message_tile.dart' show MessageTile;
import 'package:meftun/types/message.dart' show Message;
import 'package:meftun/main.dart';

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
    return FutureBuilder<List<Message>>(
      future: storage.messageTable.lastMessages,
      builder: (bc, snap) {
        if (snap.hasData)
          return _expan(snap.data);
        else
          return Row();
      },
    );
  }

  Expanded _expan(final List<Message> msgs) {
    return Expanded(
      child: Container(
          child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: msgs.length,
        itemBuilder: (BuildContext context, int index) =>
            MessageTile(msgs[index]),
      )),
    );
  }
}
