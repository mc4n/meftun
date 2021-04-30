// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// --

// -- model uses
import '../models/msg.dart';
// --

// -- pages
import '../widgets/msg_item.dart';
// --
//

class SavedMessagesList extends StatelessWidget {
  final List<Message> savedMsgs;

  const SavedMessagesList({Key key, this.savedMsgs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          child: Text("Saved"),
          padding: EdgeInsets.only(top: 16.0),
        ),
        savedMsgs.length > 0
            ? Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: savedMsgs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MessageItem(msgItem: savedMsgs[index]);
                  },
                ),
              )
            : Text("No message saved."),
      ],
    );
  }
}
