import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../models/draft.dart';

class ChatItem extends StatelessWidget {
  final Draft chatItem;

  const ChatItem({Key key, this.chatItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      //key: ValueKey(chatItem..),
      color: Colors.lightGreen.shade100,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Padding(
        child: Column(
          children: <Widget>[
            Text("message body here..."),
          ],
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }
}
