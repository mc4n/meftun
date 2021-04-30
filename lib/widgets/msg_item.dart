// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// --

// -- models
import '../models/msg.dart';
// --

// -- pages
import '../board.dart';
import '../pages/msg_details.dart';
// --

class MessageItem extends StatelessWidget {
  final Message msgItem;

  const MessageItem({Key key, this.msgItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(msgItem.uuid),
      color: Colors.lightGreen.shade100,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Padding(
        child: Column(
          children: <Widget>[
            _itemHeader(context, msgItem),
            Text(this.msgItem.body),
            _itemFooter(context, msgItem)
          ],
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  Widget _itemFooter(BuildContext context, Message msgItem) {
    if (msgItem.isSaved) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Chip(
          label: Text("Saved."),
        ),
        ElevatedButton(
            onPressed: () {
              BoardPageState.of(context).unsave(msgItem);
            },
            child: Text("Unsave"))
      ]);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ElevatedButton(
              child: Text("Save"),
              onPressed: () {
                BoardPageState.of(context).save(msgItem);
              }),
          TextButton(
            child: Text("Ignore"),
            onPressed: () {
              BoardPageState.of(context).ignore(msgItem);
            },
          )
        ],
      );
    }
  }

  Widget _itemHeader(BuildContext context, Message msgItem) {
    ImageProvider<Object> iPv = AssetImage("avatar.png");

    if (msgItem.from.photoURL.startsWith("http")) {
      iPv = NetworkImage(
        msgItem.from.photoURL,
      );
    } else if (msgItem.from.photoURL != "") {
      iPv = AssetImage("${msgItem.from.photoURL}.jpg");
    }

    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: iPv,
        ),
        Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MessageDetailsPage(selectedMessage: msgItem)),
                    );
                  },
                  child: Text("${msgItem.from.name} says: "))),
        )
      ],
    );
  }
}
