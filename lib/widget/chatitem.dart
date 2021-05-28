import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/models/chat.dart';
import 'package:me_flutting/pages/texting.dart';

import '../main.dart';

class ChatItem extends StatefulWidget {
  final Chat chatItem;
  final void Function(String) onMsgSent;

  const ChatItem({Key key, this.chatItem, this.onMsgSent}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      ChatItemState(chatItem: chatItem, onMsgSent: onMsgSent);
}

class ChatItemState extends State<ChatItem> {
  final Chat chatItem;
  final void Function(String) onMsgSent;

  ChatItemState({Key key, this.chatItem, this.onMsgSent});
  @override
  Widget build(BuildContext context) {
    var lastMsg = msgFactory.getLastMessage(chatItem);

    var isMe = lastMsg.from.id == msgFactory.owner.id;

    if (lastMsg.body == null) {
      return Card();
    }

    Widget avatarName(String tx, [String av = 'pac.jpg']) {
      return Column(children: [
        Text('$tx'),
        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
        CircleAvatar(backgroundImage: AssetImage(av))
      ]);
    }

    List<Widget> afterAvatar(String body) {
      return [
        Padding(padding: EdgeInsets.symmetric(horizontal: 11.0)),
        Padding(padding: EdgeInsets.only(left: 15.0)),
        Text("${body.length <= 280 ? body : body.substring(0, 280)}")
      ];
    }

    var avatarAndText = <Widget>[];
    avatarAndText.add(avatarName(
        '${lastMsg.from == msgFactory.owner ? 'YOU' : lastMsg.from.caption}'));

    avatarAndText.add(Text('   --->   '));

    avatarAndText.add(avatarName(
        '${lastMsg.chatGroup == msgFactory.owner ? 'YOU' : lastMsg.chatGroup.caption}'));

    avatarAndText.add(Padding(padding: EdgeInsets.symmetric(horizontal: 20.0)));

    avatarAndText.addAll(afterAvatar('"${lastMsg.body}"'));

    var colorPicked = isMe ? Colors.green.shade100 : Colors.grey.shade300;

    var card = Card(
      key: ValueKey(chatItem.id),
      color: colorPicked,
      child: Padding(
        child: GestureDetector(
            child: Row(children: avatarAndText),
            onHorizontalDragStart: (d) {
              //print('onHorizontalDragStart-> ' + d.kind.toString());
            },
            onHorizontalDragEnd: (d) {
              //super.setState(()=>null);
              //print('onHorizontalDragEnd-> ' +
              //  d.velocity.pixelsPerSecond.toString());
            },
            onLongPress: () {
              //super.setState(() => null);
              //print('onLongPress ');
            }),
        padding: EdgeInsets.symmetric(vertical: 10.0),
      ),
    );

    return TextButton(
        onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      TextingPage(selChat: chatItem, onMsgSent: onMsgSent),
                ),
              )
            },
        child: card);
  }
}
