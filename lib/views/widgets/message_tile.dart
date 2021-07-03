import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
//import 'package:me_flutting/types/chat.dart' show Chat;
import 'package:me_flutting/types/message.dart' show Message;
import 'package:me_flutting/main.dart';
import 'package:me_flutting/views/pages/main.dart';
import 'package:me_flutting/views/pages/profile.dart' show ProfilePage;
import 'package:me_flutting/views/pages/texting.dart' show TextingPage;
import 'package:me_flutting/views/pages/msgpreview.dart' show MessagePreview;

class MessageTile extends StatefulWidget {
  final Message msgItem;
  const MessageTile(this.msgItem, [Key key]) : super(key: key);

  @override
  State<StatefulWidget> createState() => MessageTileState();
}

class MessageTileState extends State<MessageTile> {
  static const PAD_AV_AR = 30.0;
  final SlidableController sldCont = SlidableController();

  @override
  Widget build(BuildContext context) {
    return _lastMsgDetailsFrame(widget.msgItem);
  }

  Widget _lastMsgDetailsFrame(Message lastMsg) {
    final isFromMe = lastMsg.from == meSession;
    final isToMe = lastMsg.from == lastMsg.chatGroup;
    final from = isFromMe ? '' : lastMsg.from.caption;
    final to = isToMe ? '' : lastMsg.chatGroup.caption;
    final dt = lastMsg.epochToTimeString();
    final fromAv = lastMsg.from.defaultPhotoURL;
    final toAv =
        isToMe ? meSession.defaultPhotoURL : lastMsg.chatGroup.defaultPhotoURL;
    final msgStat =
        lastMsg.epoch % 2 == 0 ? Colors.grey.shade700 : Colors.blue.shade300;

    final _av = (String whois, String avAss) => Column(
          children: [
            CircleAvatar(backgroundImage: AssetImage(avAss)),
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

    final _framecomp = _frame(Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(children: _avarettin)),
            _midSect(lastMsg.body.toString()),
          ],
        )));

    return _sl(_wrapInGd(_framecomp, lastMsg));
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
          context,
          widget.msgItem.chatGroup,
          () => MainPageState.setMainPageState(context)),
      child: Card(
        key: ValueKey(widget.msgItem.chatGroup.id),
        child: _inner,
      ));

  GestureDetector _wrapInGd(Widget item, Message msg) => GestureDetector(
      onLongPress: () async => await MessagePreview.sneakOut(context, msg),
      child: item);

  Slidable _sl(Widget _inner) => Slidable(
        key: Key(widget.msgItem.id),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.15,
        child: _inner,
        controller: sldCont,
        actions: [
          IconSlideAction(
              color: Colors.grey.shade100,
              icon: Icons.perm_identity,
              closeOnTap: false,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ProfilePage(
                        widget.msgItem.chatGroup.displayName,
                        widget.msgItem.chatGroup == meSession)));
              })
        ],
        secondaryActions: [
          IconSlideAction(
              color: Colors.grey.shade700,
              icon: Icons.delete,
              closeOnTap: false,
              onTap: () async {
                await messageTable.clearMessages(widget.msgItem.id);
                MainPageState.setMainPageState(context);
              }),
        ],
      );
}
