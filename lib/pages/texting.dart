import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../helpers/msghelper.dart' show MessageFactory;
import '../widgets/msgdialogs.dart' show MessageDialogs;

class TextingPage extends StatefulWidget {
  static void letTheGameBegin(
      BuildContext context,
      final void Function(String) onMsgSent,
      final MessageFactory messageFactory) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TextingPage(messageFactory, onMsgSent),
      ),
    );
  }

  final void Function(String) onMsgSent;
  final MessageFactory messageFactory;

  const TextingPage(this.messageFactory, this.onMsgSent, {Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TextingPageState();
}

class _TextingPageState extends State<TextingPage> {
  final TextEditingController teC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.messageFactory.chatItem.caption}'),
            Row(children: [
              TextButton(
                  onPressed: () {
                    if (widget.messageFactory.chatFactory
                        .removeContact(widget.messageFactory.chatItem)) {
                      widget.onMsgSent(null);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Icon(Icons.person_remove_alt_1_sharp,
                      color: Colors.blue.shade100)),
              TextButton(
                  onPressed: () {
                    widget.messageFactory.clearMessages();
                    setState(() => null);
                    widget.onMsgSent(null);
                  },
                  child: Icon(Icons.delete, color: Colors.yellow.shade100)),
            ])
          ],
        ),
      ),
      body: _body(),
    );
  }

  void _sendMes([String _ = '']) {
    var data = teC.text;
    if (data.trim() != '') {
      var msg = widget.messageFactory.addMessageBody(data);
      if (DateTime.now().second % 3 == 0) widget.messageFactory.addReplyTo(msg);
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
            MessageDialogs(widget.messageFactory),
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
