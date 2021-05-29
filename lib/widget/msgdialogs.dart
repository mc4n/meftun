import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_flutting/models/directchat.dart';
import 'package:me_flutting/models/message.dart';

class MessageDialogs extends StatelessWidget {
  final List<Message> messages;
  final DirectChat me;
  MessageDialogs({Key key, this.messages, this.me}) : super(key: key);

  //final ScrollController sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    var col = Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Expanded(
        child: _lv(messages.length, _single),
      )
    ]);
    return col;
  }

  Widget _lv(int ct, Widget Function(BuildContext context, int index) bItem) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      //controller: sc,
      itemCount: ct,
      itemBuilder: (BuildContext context, int index) {
        //sc?.jumpTo(sc?.position.maxScrollExtent);
        return bItem(context, index);
      },
    );
  }

  Widget _single(BuildContext c, int i) {
    var msg = messages[i];
    if (msg.body == null) return Row();
    return TextButton(
        onPressed: () => null, child: _msgCard(msg, msg?.from?.id != me.id));
  }

  Widget _msgCard(Message msg, [isLeft = false]) {
    var usr = !isLeft ? 'YOU' : msg.from?.username ?? '';

    return Card(
        key: ValueKey(msg.id),
        color: !isLeft ? Colors.green.shade200 : Colors.grey.shade100,
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Padding(
          child: Column(
            children: <Widget>[
              Text('$usr:'),
              Padding(padding: EdgeInsets.symmetric(vertical: 2)),
              Text('${msg.body}'),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        ));
  }
}
