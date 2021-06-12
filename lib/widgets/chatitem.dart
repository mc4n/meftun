import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../models/chat.dart' show Chat;
import '../models/message.dart' show Message;
import '../pages/texting.dart' show TextingPage;
import '../pages/profile.dart' show ProfilePage;
import 'package:flutter_slidable/flutter_slidable.dart';
import '../main.dart';
import '../helpers/table_helper.dart';

class ChatItem extends StatefulWidget {
  final Chat chatItem;
  final void Function(String) onMsgSent;

  const ChatItem(this.chatItem, this.onMsgSent, [Key key]) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatItemState();
}

class ChatItemState extends State<ChatItem> {
  static const PAD_AV_AR = 30.0;
  final SlidableController sldCont = SlidableController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Message>(
      future: myContext
          .tableEntityOf<MessageTable>()
          .getMessageDetails((m) => m.chatGroupId == widget.chatItem.id),
      builder: (BuildContext bc, AsyncSnapshot<Message> snap) {
        if (snap.hasData)
          return _lastMsgDetailsFrame(snap.data);
        else
          return Row();
      },
    );
  }

  Widget _lastMsgDetailsFrame(Message lastMsg) {
    final isFromMe = lastMsg.from == meSession;
    final isToMe = lastMsg.from == lastMsg.chatGroup;
    final from = isFromMe ? '' : lastMsg.from.caption;
    final to = isToMe ? '' : lastMsg.chatGroup.caption;
    final dt = lastMsg.epochToTimeString();
    final fromAv = lastMsg.from.photoURL;
    final toAv = isToMe ? meSession.photoURL : lastMsg.chatGroup.photoURL;
    final msgStat =
        lastMsg.epoch % 2 == 0 ? Colors.grey.shade700 : Colors.blue.shade300;

    final _av = (String whois, String avAss) => Column(
          children: [
            _wrapInGd(CircleAvatar(backgroundImage: AssetImage(avAss))),
            Text(whois)
          ],
        );

    final _ar = Column(
      children: [
        Icon(Icons.arrow_forward, color: msgStat),
        Padding(padding: EdgeInsets.symmetric(horizontal: PAD_AV_AR)),
        Text(dt, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
      ],
    );

    final _avarettin = [_av(from, fromAv), _ar, _av(to, toAv)];

    return _sl(_frame(Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(children: _avarettin)),
            _midSect(lastMsg.body.toString()),
          ],
        ))));
  }

  Widget _midSect(String lastMsg) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(lastMsg.length > 20 ? '${lastMsg.substring(0, 20)}...' : lastMsg,
              style: TextStyle(fontSize: 14)),
        ],
      );

  Widget _frame(Widget _inner) => TextButton(
      onPressed: () async => TextingPage.letTheGameBegin(
          context, widget.chatItem, widget.onMsgSent),
      child: Card(
        key: ValueKey(widget.chatItem.id),
        child: _inner,
      ));

  GestureDetector _wrapInGd(Widget item) =>
      GestureDetector(onLongPress: () => null, child: item);

  Slidable _sl(Widget _inner) => Slidable(
        key: Key(widget.chatItem.id),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.15,
        child: _inner,
        controller: sldCont,
        actions: [
          IconSlideAction(
              color: Colors.yellow.shade300,
              icon: Icons.preview,
              closeOnTap: false,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ProfilePage(widget.chatItem)));
              })
        ],
        secondaryActions: [
          IconSlideAction(
              color: Colors.grey.shade700,
              icon: Icons.delete,
              closeOnTap: false,
              onTap: () async {
                await myContext.tableEntityOf<MessageTable>().deleteWhere(
                    (msg) => msg.chatGroupId == widget.chatItem.id);
                widget.onMsgSent(null);
              }),
        ],
      );
}
