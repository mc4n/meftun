import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/models/chat.dart';
import '../models/person.dart';

class ChatItem extends StatelessWidget {
  final Chat chatItem;

  const ChatItem({Key key, this.chatItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lastMsg = chatItem.getLastMessage();

    var isMe = lastMsg.from.id == me.id;
    var isEmpty = lastMsg.body.trim() == '';

    Widget avatarName() {
      return Column(children: [
        Text('${lastMsg.from.username} :'),
        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
        CircleAvatar(backgroundImage: AssetImage('assets/avatar.png'))
      ]);
    }

    List<Widget> afterAvatar() {
      return [
        Padding(padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0)),
        Padding(padding: EdgeInsets.only(left: 25.0)),
        Text("${lastMsg.body}")
      ];
    }

    var avatarAndText = <Widget>[];
    avatarAndText.add(avatarName());
    avatarAndText.addAll(afterAvatar());

    var colorPicked = isEmpty
        ? Colors.white
        : (isMe ? Colors.lightGreen.shade100 : Colors.blueGrey.shade200);

    return Card(
      key: ValueKey(chatItem.id),
      color: colorPicked,
      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Padding(
        child: Row(children: avatarAndText),
        padding: EdgeInsets.all(15.0),
      ),
    );
  }
}
