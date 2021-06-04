import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/models/chat.dart' show Chat;
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
        _ == widget.messageFactory.chatFactory.owner ? '[YOU]' : _.caption;
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

    return _frame(Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _lrAvatar(fromAv, from, msgStatFrom, dt, true),
            _midSect(lastMsg.body),
            _lrAvatar(toAv, to, msgStatTo, dt, false),
          ],
        )));
  }

  Container _midSect(String lastMsg) => Container(
        color: Colors.grey.shade100,
        child: Text(
            lastMsg.length > 20 ? '${lastMsg.substring(0, 20)}...' : lastMsg,
            style: TextStyle(fontSize: 14)),
      );

  static const PAD_AV_AR = 30.0;


  Padding _lrAvatar(String avAss, String whois, Color msgStatColor, String dt, bool isleft) {
    final _av = Column(
      children: [
        _wrapInGd(CircleAvatar(backgroundImage: AssetImage(avAss))),
        Text(whois)
      ],
    );

    final _ar = Column(
      children: [
        Icon(Icons.arrow_forward, color: msgStatColor),
        Padding(padding: EdgeInsets.symmetric(horizontal: PAD_AV_AR)),
        Text(dt, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
      ],
    );

    final _avarettin = isleft ? [_av, _ar] : [_ar, _av];

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(children: _avarettin));
  }

  Widget _frame(Widget _inner /*, [ChatItemPositions _ = ChatItemPositions.Center]*/) => Dismissible(
          key: Key(widget.messageFactory.chatItem.id),
          // background: null,
          // secondaryBackground: null,
          child: TextButton(
              onPressed: () async => TextingPage.letTheGameBegin(context, widget.onMsgSent, widget.messageFactory),                  
              child: Card(key: ValueKey(widget.messageFactory.chatItem.id), child: _inner,)
          )
);

  GestureDetector _wrapInGd(Widget item) =>
      GestureDetector(onLongPress: () => null, child: item);
}

enum ChatItemPositions { Left, Center, Right }
