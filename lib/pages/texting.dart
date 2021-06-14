import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../pages/profile.dart' show ProfilePage;
import '../widgets/msgdialogs.dart' show MessageDialogs;
import '../models/chat.dart' show Chat;
import '../models/message.dart' show Message;
import '../main.dart';
import '../widgets/msgpanel.dart';

class TextingPage extends StatefulWidget {
  static void letTheGameBegin(BuildContext context, final Chat chatItem,
      final void Function(String) onMsgSent) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TextingPage(chatItem, onMsgSent),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => TextingPageState();

  final Chat chatItem;
  final void Function(String) onMsgSent;

  const TextingPage(this.chatItem, this.onMsgSent, {Key key}) : super(key: key);
}

class TextingPageState extends State<TextingPage> {
  Message quotedMessage; // this better be MBody rather than ..
  void Function(Message msgQuoted) onMsgQuoted;
  TextingPageState() {
    onMsgQuoted = (_) {
      setState(() {
        quotedMessage = _;
      });
    };
  }

  Widget get _title => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ProfilePage(widget.chatItem)));
              },
              child: Row(children: [
                CircleAvatar(
                    backgroundImage: AssetImage(widget.chatItem.photoURL)),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                Text('${widget.chatItem.caption}',
                    style: TextStyle(color: Colors.white, fontSize: 23))
              ])),
          Row(children: [
            TextButton(
                onPressed: () async {
                  await chatTable.delete(widget.chatItem.id);
                  widget.onMsgSent(null);
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.person_remove_alt_1_sharp,
                    color: Colors.blue.shade100)),
            TextButton(
                onPressed: () async {
                  await messageTable.deleteWhere(
                      (msg) => msg.chatGroupId == widget.chatItem.id);
                  setState(() => null);
                  widget.onMsgSent(null);
                },
                child: Icon(Icons.delete, color: Colors.yellow.shade100)),
          ])
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: _title),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [MessageDialogs(), MessagingPanel(widget.chatItem)]),
    );
  }
}
