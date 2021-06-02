import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/models/chat.dart';
import '../helpers/msghelper.dart' show MessageFactory;
import '../pages/texting.dart' show TextingPage;

class ChatItem extends StatefulWidget {
  final MessageFactory messageFactory;
  final void Function(String) onMsgSent;

  const ChatItem(this.messageFactory, this.onMsgSent, [Key key])
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatItemState();
}

class ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    final lastMsg = widget.messageFactory.lastMessage;
    final meOrCaption = (Chat _) =>
        _ == widget.messageFactory.chatFactory.owner ? 'YOU' : _.caption;
    final from = meOrCaption(lastMsg.from);
    final to = meOrCaption(lastMsg.chatGroup);
    final dt = lastMsg.epochToTimeString();
    final fromAv = lastMsg.from.photoURL;
    final toAv = lastMsg.chatGroup.photoURL;
    final msgStatFrom =
        lastMsg.epoch % 2 == 0 ? Colors.grey.shade700 : Colors.blue.shade300;
    final msgStatTo = (lastMsg.epoch + DateTime.now().second) % 2 == 0
        ? Colors.grey.shade700
        : Colors.blue.shade300;
    const PAD_AV_AR = 40.0;

    return _frame(Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Column(
                children: [
                  CircleAvatar(backgroundImage: AssetImage(fromAv)),
                  Text(from)
                ],
              ),
              Column(children: [
                Icon(Icons.arrow_forward, color: msgStatFrom),
                Padding(padding: EdgeInsets.symmetric(horizontal: PAD_AV_AR)),
                Text(dt,
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 12)),
              ]),
            ]),
            Container(
              color: Colors.grey.shade100,
              child: Text(
                  lastMsg.body.length > 20
                      ? '${lastMsg.body.substring(0, 20)}...'
                      : lastMsg.body,
                  style: TextStyle(fontSize: 14)),
            ),
            Row(children: [
              Column(children: [
                Icon(Icons.arrow_forward, color: msgStatTo),
                Padding(padding: EdgeInsets.symmetric(horizontal: PAD_AV_AR)),
                Text('xx:xx',
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 12)),
              ]),
              Column(
                children: [
                  CircleAvatar(backgroundImage: AssetImage(toAv)),
                  Text(to)
                ],
              )
            ]),
          ],
        )));
  }

  Widget _frame(Widget _inner) => TextButton(
      onPressed: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    TextingPage(widget.messageFactory, widget.onMsgSent),
              ),
            )
          },
      child: Card(
        key: ValueKey(widget.messageFactory.chatItem.id),
        child: Padding(
          child: GestureDetector(
              child: _inner,
              onLongPress: () {
                print('onLongPress ');
              }),
          padding: EdgeInsets.symmetric(vertical: 10.0),
        ),
      ));
}
