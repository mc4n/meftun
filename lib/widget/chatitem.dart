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

    Widget avatarName(String tx, [String av = 'assets/avatar.png']) {
      return Column(children: [
        Text('$tx:'),
        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
        //CircleAvatar(backgroundImage: AssetImage(av))
      ]);
    }

    List<Widget> afterAvatar(String body) {
      return [
        Padding(padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0)),
        Padding(padding: EdgeInsets.only(left: 25.0)),
        Text("${body.length <= 280 ? body : body.substring(0, 280)}")
      ];
    }

    var avatarAndText = <Widget>[];
    avatarAndText.add(avatarName('${lastMsg.from.toTitle()} --> ${lastMsg.chatGroup.toTitle()}'));
    avatarAndText.addAll(afterAvatar(lastMsg.body));

    var colorPicked = isEmpty
        ? Colors.white
        : (isMe ? Colors.green.shade100 : Colors.grey.shade300);

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
