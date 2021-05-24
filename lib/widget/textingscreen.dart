import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_flutting/models/message.dart';
import 'package:me_flutting/models/person.dart';

class TextingScreen extends StatelessWidget {
  final List<Message> messages;
  const TextingScreen({Key key, this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Expanded(
        child: _lv(messages.length, _single),
      )
    ]);
  }

  Widget _lv(int ct, Widget Function(BuildContext context, int index) bItem) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: ct,
      itemBuilder: (BuildContext context, int index) {
        return bItem(context, index);
      },
    );
  }

  Widget _single(BuildContext c, int i) {
    var msg = messages[i];
    return TextButton(
        onPressed: () {
          //
        },
        //padding: EdgeInsets.symmetric(horizontal: 20),
        child: _msgCard(msg, msg?.from?.id != me.id));
  }

  Widget _msgCard(Message msg, [isLeft = false]) {
    var usr = msg.from?.username ?? '';

    return Card(
        key: ValueKey(msg.id),
        color: !isLeft ? Colors.lightGreen.shade100 : Colors.blueGrey.shade200,
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
