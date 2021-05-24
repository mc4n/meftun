import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/models/chat.dart';
import 'package:me_flutting/widget/textingscreen.dart';

class TextingPage extends StatelessWidget {
  final Chat selChat;

  TextingPage({Key key, this.selChat}) : super(key: key);
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
          title: Text('${selChat.id}'),
        ),
        body: TextingScreen(messages: selChat.getMessages()));
  }
}
