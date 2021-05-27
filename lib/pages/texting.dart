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
        backgroundColor: Colors.red.shade300,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('${selChat.caption}'),
      ),
      // body
      body: Column(children: [
        Expanded(
            child: TextingScreen(messages: selChat.getMessages().toList())),
        _butt(),
      ]),
      //
    );
  }

  Card _butt() {
    return Card(
        color: Colors.grey.shade100,
        margin: EdgeInsets.all(4),
        child: Row(children: [
          Expanded(child: TextField()),
          ElevatedButton(
              onPressed: () => {
                    // send the message.
                  },
              child: Text('SEND'))
        ]));
  }
}
