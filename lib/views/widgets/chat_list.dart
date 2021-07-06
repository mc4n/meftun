import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'message_tile.dart' show MessageTile;
import 'package:me_flutting/types/message.dart' show Message;
import 'package:me_flutting/main.dart';
//import 'package:me_flutting/types/directchat.dart';

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
      future: /* widget.isSearching
          ? null
          :*/
          storage.messageTable
              .lsLastMsgs((i) async => storage.chatTable.getChat(i)),
      builder: (bc, snap) {
        if (snap.hasData)
          return _expan(snap.data);
        else
          return Text('no item');
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
