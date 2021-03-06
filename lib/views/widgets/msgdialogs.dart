import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meftun/types/chat.dart' show Chat;
import 'package:meftun/types/message.dart' show Message;
import 'package:meftun/main.dart';
import 'package:meftun/views/pages/texting.dart' show TextingPageState;
import 'package:meftun/views/pages/msgpreview.dart' show MessagePreviewState;

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
      future: storage.messageTable.chatMessages(widget.chatItem.id),
      builder: (BuildContext bc, AsyncSnapshot<List<Message>> snap) {
        if (snap.hasData)
          return Expanded(child: _lv(snap.data, storage.adminId));
        else
          return Text('no item');
      },
    );
  }

  Widget _lv(final List<Message> messages, String owner) => ListView.builder(
      //reverse: true,
      physics: BouncingScrollPhysics(),
      controller: sc,
      itemCount: messages.length,
      shrinkWrap: false,
      itemBuilder: (_, __) {
        var msg = messages[__];
        var isMe = msg.from.id == owner;
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
      child: MessagePreviewState.msgCard(context, msg, isRight));

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
