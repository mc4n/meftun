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
    return Container(child: _msgBalloon(msg, msg?.from?.id != me.id));
  }

  Widget _msgBalloon(Message msg, [isLeft = false]) {
    var usr = msg.from?.username ?? '';
    // Card();
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          Text(usr, textAlign: isLeft ? TextAlign.left : TextAlign.right),
          Text(msg.body, textAlign: isLeft ? TextAlign.left : TextAlign.right)
        ]));
  }
}
