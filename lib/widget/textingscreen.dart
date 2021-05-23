import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_flutting/models/message.dart';
import 'package:me_flutting/models/person.dart';

class TextingScreen extends StatelessWidget {
  final List<Message> messages;
  const TextingScreen({Key key, this.messages}) : super(key: key);

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
    var ite = contacts[i];
    return Text('${ite.username}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Expanded(
        child: _lv(ITEM_C, _single),
      )
    ]));
  }
}
