import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_flutting/helpers/msghelper.dart';
import 'package:me_flutting/models/message.dart';

class MessageDialogs extends StatefulWidget {
  final MessageFactory messageFactory;
  const MessageDialogs(this.messageFactory, [Key key]) : super(key: key);

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
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: sc,
        itemCount: widget.messageFactory.messages.length,
        itemBuilder: (BuildContext context, int i) {
          var msg = widget.messageFactory.messages.elementAt(i);
          return _msgItem(msg);
        },
      ),
    );
  }

  Widget _msgItem(Message msg) {
    if (msg.body == null) return Container();
    var usr = msg.from == widget.messageFactory.chatFactory.owner
        ? 'YOU'
        : msg.from.username;
    var dt = DateTime.fromMillisecondsSinceEpoch(msg.epoch);
    return Card(child: _pad(msg.body, usr, dt));
  }

  Widget _pad(String body, String name, DateTime dt) => Padding(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('$name:'),
              Padding(padding: EdgeInsets.symmetric(vertical: 2)),
              Text('$body'),
              Padding(padding: EdgeInsets.only(top: 4)),
              Text(
                  '(${dt.day == DateTime.now().day && dt.month == DateTime.now().month && dt.year == DateTime.now().year ? 'Today' : dt.month} ${dt.hour}:${dt.minute})',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12))
            ]),
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      );
}
