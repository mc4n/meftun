import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_flutting/main.dart';
import 'package:me_flutting/models/chat.dart';
import 'package:me_flutting/models/message.dart';

class MessageDialogs extends StatefulWidget {
  final Chat selChat;
  MessageDialogs({Key key, this.selChat}) : super(key: key);

  @override
  _MessageDialogsState createState() => _MessageDialogsState();
}

class _MessageDialogsState extends State<MessageDialogs> {
  final ScrollController sc = ScrollController();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((i) {
      if (sc.hasClients) sc.jumpTo(sc.position.maxScrollExtent);
    });
    var col = Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Expanded(
        child: _lv(msgFactory.getMessages(widget.selChat).length, _single),
      )
    ]);
    return col;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _lv(int ct, Widget Function(BuildContext context, int index) bItem) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      controller: sc,
      itemCount: ct,
      itemBuilder: (BuildContext context, int index) {
        return bItem(context, index);
      },
    );
  }

  Widget _single(BuildContext c, int i) {
    var msg = msgFactory.getMessages(widget.selChat).elementAt(i);
    if (msg.body == null) return Row();
    return TextButton(
        onPressed: () => null,
        child: _msgCard(msg, msg?.from?.id != msgFactory.owner.id));
  }

  Widget _msgCard(Message msg, [isLeft = false]) {
    var usr = !isLeft ? 'YOU' : msg.from?.username ?? '';
    var dt = DateTime.fromMillisecondsSinceEpoch(msg.epoch);
    return Card(
        key: ValueKey(msg.id),
        color: !isLeft ? Colors.green.shade200 : Colors.grey.shade100,
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Padding(
          child: Column(children: <Widget>[
            Text('$usr:'),
            Padding(padding: EdgeInsets.symmetric(vertical: 2)),
            Text('${msg.body}'),
            Padding(padding: EdgeInsets.only(top: 4)),
            Text(
                '(${dt.day == DateTime.now().day && dt.month == DateTime.now().month && dt.year == DateTime.now().year ? 'Today' : dt.month} ${dt.hour}:${dt.minute})',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12))
          ]),
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        ));
  }
}
