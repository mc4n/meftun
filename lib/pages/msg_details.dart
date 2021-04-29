// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// --

class MessageDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
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
              "Message Details to be shown here",
              style: TextStyle(fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }
}
