import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/main.dart';
import 'package:me_flutting/models/chat.dart';
import 'package:me_flutting/widget/msgdialogs.dart';

class TextingPage extends StatefulWidget {
  final Chat selChat;
  final void Function(String) onMsgSent;

  TextingPage({Key key, this.selChat, this.onMsgSent}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TextingPageState(selChat, onMsgSent);
}

class TextingPageState extends State<TextingPage> {
  final Chat selChat;
  final TextEditingController teC = TextEditingController();
  final void Function(String) onMsgSent;

  TextingPageState(this.selChat, this.onMsgSent);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('${selChat.caption}'),
      ),
      // body
      body: _body(),
      //
    );
  }

  void _sendMes([String _ = '']) {
    var data = teC.text;
    if (data.trim() != '') {
      msgFactory.sendMessage(selChat, data);
      if (onMsgSent != null) {
        onMsgSent(data);
        setState(() => null);
      }
      teC.text = '';
    }
  }

  Column _body() => Column(children: [
        Expanded(
          child: MessageDialogs(
            selChat: selChat,
          ),
        ),
        _butt(),
      ]);

  Card _butt() {
    return Card(
        color: Colors.grey.shade100,
        margin: EdgeInsets.all(4),
        child: Row(children: [
          Expanded(
              child: TextField(
            controller: teC,
            onSubmitted: _sendMes,
            style: TextStyle(fontSize: 16),
            autofocus: true,
          )),
          TextButton(
            onPressed: _sendMes,
            child: Icon(Icons.send, color: Colors.black),
          )
        ]));
  }
}
