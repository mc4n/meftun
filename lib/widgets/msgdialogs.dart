import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/directchat.dart' show DirectChat;
import '../pages/texting.dart' show TextingPage, TextingPageState;
import '../models/message.dart' show Message;
import 'dart:io' show File;
import '../models/mbody.dart' show ImageBody;
import 'package:flutter_slidable/flutter_slidable.dart';
import '../main.dart';
import '../helpers/table_helper.dart';

class MessageDialogs extends StatefulWidget {
  MessageDialogs([Key key]) : super(key: key);

  @override
  _MessageDialogsState createState() => _MessageDialogsState();

  bool isLoaded = false;
}

class _MessageDialogsState extends State<MessageDialogs> {
  final List<Message> messages = [];
  final SlidableController sldCont = SlidableController();
  final ScrollController sc = ScrollController();

  Future<void> lsInit() async {
    if (!widget.isLoaded) {
      final ment = myContext.tableEntityOf<MessageTable>();
      final chatItem =
          context.findAncestorWidgetOfExactType<TextingPage>()?.chatItem;
      final lsGroupMessageModels = await ment
          .selectWhere((mtbItem) => mtbItem.chatGroupId == chatItem.id);

      messages.clear();
      lsGroupMessageModels.forEach((msgModel) async => messages
          .add(await ment.getMessageDetails((pred) => pred.id == msgModel.id)));

      widget.isLoaded = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((i) {
      if (sc.hasClients) sc.jumpTo(sc.position.maxScrollExtent);
    });
    lsInit();
    return Expanded(
      child: _lv(meSession),
    );
  }

  Widget _lv(DirectChat owner) => ListView.builder(
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
                children: [_sl(_dialog(msg, isMe), msg)],
              )),
        );
      });

  Widget _dialog(Message msg, bool isRight) => GestureDetector(
      onDoubleTap: () async {
        await myContext.tableEntityOf<MessageTable>().delete(msg.id);
        widget.isLoaded = false;
        setState(() => context
            .findAncestorWidgetOfExactType<TextingPage>()
            .onMsgSent
            ?.call(null));
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
                      constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                      child: Text('${msg.body}'))
            ]),
          )));

  Slidable _sl(Widget _inner, Message msg) => Slidable(
        //key: Key(widget.chatItem.id),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.4,
        child: _inner,
        controller: sldCont,
        secondaryActions: [
          IconSlideAction(
              //caption: 'Quote',
              color: Colors.indigo.shade100,
              icon: Icons.copy,
              //closeOnTap: false,
              onTap: () {
                setState(() => context
                    .findAncestorStateOfType<TextingPageState>()
                    .onMsgQuoted
                    ?.call(msg));
              })
        ],
      );
}
