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
    var usr = msg.from?.username ?? '';
    var fr = '$usr:\n  ${msg?.body}';
    return Container(child: _msgBalloon(c, fr, msg?.from?.id != me.id));
  }

  Widget _msgBalloon(BuildContext _c, String tx, [isLeft = false]) {
    //chip, card

    return Container(
        child: Text(tx, textAlign: isLeft ? TextAlign.left : TextAlign.right));
  }
}
