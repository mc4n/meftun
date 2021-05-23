import 'package:me_flutting/models/draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/widget/textingscreen.dart';

class CreateMessagePage extends StatefulWidget {
  final Draft selectedLastMsg;

  CreateMessagePage({Key key, this.selectedLastMsg}) : super(key: key);

  @override
  CreateMessagePageState createState() =>
      new CreateMessagePageState(this.selectedLastMsg);
}

class CreateMessagePageState extends State<CreateMessagePage> {
  final Draft selectedLastMsg;
  CreateMessagePageState(this.selectedLastMsg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            Text('grop-id -> ${selectedLastMsg.chatGroup?.id}'),
          ],
        ),
        body: TextingScreen());
  }
}
