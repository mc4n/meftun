import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/helpers/msghelper.dart';
import 'package:me_flutting/models/chat.dart';
import 'package:me_flutting/pages/texting.dart';

class ChatItem extends StatefulWidget {
  final Chat chatItem;

  const ChatItem({Key key, this.chatItem}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatItemState(chatItem: chatItem);
}

class ChatItemState extends State<ChatItem> {
  final Chat chatItem;
  
  ChatItemState({Key key, this.chatItem});
  @override
  Widget build(BuildContext context) {
    var lastMsg = getLastMessage(chatItem);

    var isMe = lastMsg.from.id == me.id;

    if (lastMsg.body.trim() == '') {
      return Card();
    }

    Widget avatarName(String tx, [String av = 'pac.jpg']) {
      return Column(children: [
        Text('$tx:'),
        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
        CircleAvatar(backgroundImage: AssetImage(av))
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
    avatarAndText.add(avatarName(
        '${lastMsg.from.caption} --> ${lastMsg.chatGroup.caption}'));
    avatarAndText.addAll(afterAvatar(lastMsg.body));

    var colorPicked = isMe ? Colors.green.shade100 : Colors.grey.shade300;

    var card_ = Card(
      key: ValueKey(chatItem.id),
      color: colorPicked,
      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Padding(
        child: GestureDetector(
            child: Row(children: avatarAndText),
            onHorizontalDragStart: (d) {
              print('onHorizontalDragStart-> ' + d.kind.toString());
            },
            onHorizontalDragEnd: (d) {
               //super.setState(()=>null);
              print('onHorizontalDragEnd-> ' +
                  d.velocity.pixelsPerSecond.toString());
            },
            onLongPress: () {
              //super.setState(() => null);
              print('onLongPress ');
            }),
        padding: EdgeInsets.all(15.0),
      ),
    );

    return TextButton(
        onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TextingPage(selChat: chatItem),
                ),
              )
            },
        child: card_);
  }
}
