import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_flutting/models/directchat.dart';
import 'package:me_flutting/pages/texting.dart';
import '../helpers/msghelper.dart';
import '../models/message.dart';

class MessageDialogs extends StatefulWidget {
  final MessageFactory messageFactory;
  const MessageDialogs(this.messageFactory, [Key key]) : super(key: key);

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
    return Expanded(
      child: _lv(widget.messageFactory.messages,
          widget.messageFactory.chatFactory.owner),
    );
  }

  Widget _lv(List<Message> messages, DirectChat owner) => ListView.builder(
      //reverse: true,
      physics: BouncingScrollPhysics(),
      controller: sc,
      itemCount: messages.length,
      shrinkWrap: false,
      itemBuilder: (_, __) {
        var msg = messages[__];
        var isMe = msg.from == owner;
        return Container(
          //color: Colors.yellow.shade100,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [_dialog(msg, isMe)],
              )),
        );
      });

  Widget _dialog(Message msg, bool isRight) => GestureDetector(
      onDoubleTap: () {
        if (widget.messageFactory.removeMessage(msg)) {
          setState(() => context
              .findAncestorWidgetOfExactType<TextingPage>()
              .onMsgSent
              ?.call(null));
        }
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
              Text('${msg.body}'),
            ]),
          )));
}
