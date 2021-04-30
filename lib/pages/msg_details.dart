// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/models/msg.dart';
// --

class MessageDetailsPage extends StatelessWidget {
  final Message selectedMessage;
  const MessageDetailsPage({Key key, this.selectedMessage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: new Text("Message Details"),
        centerTitle: true,
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            Text(
              this.selectedMessage.from.name +
                  " : " +
                  this.selectedMessage.body,
              style: TextStyle(fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }
}
