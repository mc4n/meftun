import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/chat.dart' show Chat;
import '../models/directchat.dart' show DirectChat;
import '../pages/texting.dart' show TextingPageState;
import '../models/message.dart' show Message;
import 'dart:io' show File;
import '../models/mbody.dart' show ImageBody;
import '../main.dart';

class MessageDialogs extends StatefulWidget {
  final Chat chatItem;
  const MessageDialogs(this.chatItem, [Key key]) : super(key: key);
  @override
  _MessageDialogsState createState() => _MessageDialogsState();
}

class _MessageDialogsState extends State<MessageDialogs> {
  final ScrollController sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((i) {
      if (sc.hasClients) sc.jumpTo(sc.position.maxScrollExtent);
    });

    return FutureBuilder<List<Message>>(
      future: messageTable.chatMessages(
          widget.chatItem.id, (_) async => widget.chatItem),
      builder: (BuildContext bc, AsyncSnapshot<List<Message>> snap) {
        if (snap.hasData)
          return Expanded(child: _lv(snap.data, meSession));
        else
          return Text('no item');
      },
    );
  }

  Widget _lv(final List<Message> messages, DirectChat owner) =>
      ListView.builder(
          //reverse: true,
          physics: BouncingScrollPhysics(),
          controller: sc,
          itemCount: messages.length,
          shrinkWrap: false,
          itemBuilder: (_, __) {
            var msg = messages[__];
            var isMe = msg.from == owner;
            return Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [_dsmb(_dialog(msg, isMe), msg)],
                ),
              ),
            );
          });

  Widget _dialog(Message msg, bool isRight) => GestureDetector(
      onDoubleTap: () async {
        context
            .findAncestorStateOfType<TextingPageState>()
            .onMsgRemoveClaimed(msg, (isSucceed, {errorMsg}) => null);
      },
      child: Card(
          color: !isRight ? Colors.grey.shade200 : Colors.lightGreen.shade300,
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Column(children: [
              Text('${msg.epochToTimeString()}',
                  style: TextStyle(fontSize: 11)),
              Padding(padding: EdgeInsets.symmetric(vertical: 2)),
              !isRight ? Text('${msg.from.caption}:') : Row(),
              Padding(padding: EdgeInsets.symmetric(vertical: 3)),
              msg.body is ImageBody
                  ? Container(
                      width: 180,
                      height: 180,
                      child: Image.file(File(msg.body.toString())))
                  : Container(
                      constraints: BoxConstraints(
                          minWidth: 100,
                          maxWidth: MediaQuery.of(context).size.width * 9 / 10),
                      child: Text('${msg.body}'))
            ]),
          )));

  Dismissible _dsmb(Widget _inner, Message msg) => Dismissible(
        key: Key(widget.chatItem.id),
        child: _inner,
        background: Container(child: Icon(Icons.insert_comment)),
        confirmDismiss: (_) async {
          context.findAncestorStateOfType<TextingPageState>().onMsgQuoted(msg);
          setState(() => null);
          return false;
        },
      );
}
