import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/models/message.dart';
import 'package:me_flutting/widget/textingscreen.dart';

class CreateMessagePage extends StatefulWidget {
  final Iterable<Message> messages;

  CreateMessagePage({Key key, this.messages}) : super(key: key);

  @override
  CreateMessagePageState createState() =>
      new CreateMessagePageState(this.messages);
}

class CreateMessagePageState extends State<CreateMessagePage> {
  final Iterable<Message> messages;
  CreateMessagePageState(this.messages);

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
            Text(
              'last seen : 1231 231 e qwe qwe ',
              textAlign: TextAlign.left,
            )
            //Text('grop-id -> ${selectedLastMsg.chatGroup?.id}'),
          ],
        ),
        body: TextingScreen(messages: messages.toList()));
  }
}
