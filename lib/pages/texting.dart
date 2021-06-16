import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../pages/profile.dart' show ProfilePage;
import '../widgets/msgdialogs.dart' show MessageDialogs;
import '../models/chat.dart' show Chat;
import '../models/message.dart' show Message;
import '../models/draft.dart' show Draft;
import '../main.dart';
import '../widgets/msgpanel.dart';
import '../helpers/bot_helper.dart';

class TextingPage extends StatefulWidget {
  static void letTheGameBegin(BuildContext context, Chat chatItem,
      Future<void> Function() setMainState) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TextingPage(chatItem, setMainState),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => TextingPageState(chatItem.type == 'B'
      ? BotManager.findManagerByBot(chatItem).msgMiddleMan
      : messageTable.insertMessage);

  final Future<void> Function() setMainState;

  final Chat chatItem;
  const TextingPage(this.chatItem, this.setMainState, {Key key})
      : super(key: key);
}

class TextingPageState extends State<TextingPage> {
  final Future<Message> Function(Draft) messagingMiddleware;

  Future<void> onMsgSendClaimed(Draft draft,
      Function({Message itemAdded, String errorMsg}) callback) async {
    final msgResult = await messagingMiddleware(draft);
    if (msgResult != null) {
      widget.setMainState();
      setState(() {
        callback(itemAdded: msgResult);
      });
    } else {
      callback(errorMsg: 'msg not sent!');
    }
  }

  Future<void> onMsgRemoveClaimed(
      Message msg, Function(bool isSucceed, {String errorMsg}) callback) async {
    await messageTable.deleteMessage(msg);
    setState(() {
      callback(true);
    });
    await widget.setMainState();
  }

  Future<void> onMsgQuoted(Message _) async {
    setState(() {
      quotedMessage = _;
    });
  }

  Message quotedMessage; // this better be MBody rather than ..

  TextingPageState(this.messagingMiddleware);

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
                  await chatTable.deleteChat(widget.chatItem);
                  await widget.setMainState();
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.person_remove_alt_1_sharp,
                    color: Colors.blue.shade100)),
            TextButton(
                onPressed: () async {
                  if (await messageTable.clearMessages(widget.chatItem.id)) {
                    setState(() => null);
                    await widget.setMainState();
                  }
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
          children: [
            MessageDialogs(widget.chatItem),
            MessagingPanel(widget.chatItem)
          ]),
    );
  }
}
