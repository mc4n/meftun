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
  State<StatefulWidget> createState() => TextingPageState();
}

class TextingPageState extends State<TextingPage> {
  final TextEditingController teC = TextEditingController();

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
        title: Text('${widget.selChat.caption}'),
      ),
      // body
      body: _body(),
      //
    );
  }

  void _sendMes([String _ = '']) {
    var data = teC.text;
    if (data.trim() != '') {
      msgFactory.sendMessage(widget.selChat, data);
      if (widget.onMsgSent != null) {
        widget.onMsgSent(data);
        setState(() => null);
      }
      teC.text = '';
    }
  }

  Column _body() => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageDialogs(selChat: widget.selChat),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                child: _butt()),
          ]);

  Card _butt() {
    return Card(
        color: Colors.grey.shade200,
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
