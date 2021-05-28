import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/main.dart';
import 'package:me_flutting/models/chat.dart';
import 'package:me_flutting/widget/msgdialogs.dart';
import 'package:me_flutting/models/message.dart';

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
          child: MessageDialogs(
              me: msgFactory.owner,
              messages: msgFactory
                  .getMessages(selChat)
                  .where((m) => m is Message)
                  .map((m) => m as Message)
                  .toList()),
        ),
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
