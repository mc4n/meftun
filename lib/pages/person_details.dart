// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// --

class PersonDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: new Text("Person Details"),
        centerTitle: true,
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            Text(
              "Person Details to be shown here",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
