import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/models/chat.dart';

class ChatItem extends StatelessWidget {
  final Chat chatItem;

  const ChatItem({Key key, this.chatItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(chatItem.id),
      color: Colors.lightGreen.shade100,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Padding(
        child: Column(
          children: <Widget>[
            Text("${chatItem.id} : ${chatItem.getLastMessage().body}"),
          ],
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }
}
