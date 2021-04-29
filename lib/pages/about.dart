// -- external libs

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// --

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("About"),
        centerTitle: true,
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            Text("Copyright (C) All right reserved."),
            Text("This app is developed by Mustafa Can"),
            Text("To contact please send an e-mail to 'mustcalypse@gmail.com'")
          ],
        ),
      ),
    );
  }
}
