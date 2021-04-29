// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// --

// -- model uses
import '../models/msg.dart';
// --

// -- pages
import '../widgets/card_item.dart';
// --
//

class MessagesList extends StatelessWidget {
  final String title;
  final List<Message> inboxMsgs;

  const MessagesList({Key key, this.title, this.inboxMsgs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          child: Text(title),
          padding: EdgeInsets.only(top: 16.0),
        ),
        inboxMsgs.length > 0
            ? Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: inboxMsgs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MessageCardItem(inboxMsg: inboxMsgs[index]);
                  },
                ),
              )
            : Text("horaay, we have no new message here!"),
      ],
    );
  }
}
