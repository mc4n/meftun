import 'package:flutter/material.dart';
import '../types/message.dart' show Message;
import 'dart:io' show File;
import '../types/mbody.dart' show ImageBody;

class MessagePreview extends StatefulWidget {
  static Future<Widget> sneakOut(BuildContext context, Message messageItem) =>
      showDialog(context: context, builder: (_) => MessagePreview(messageItem));

  @override
  State<StatefulWidget> createState() => MessagePreviewState();
  final Message messageItem;
  const MessagePreview(this.messageItem);
}

class MessagePreviewState extends State<MessagePreview>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() => null);
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
              scale: scaleAnimation,
              child: Wrap(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      /*constraints: BoxConstraints(
                      minWidth: 100,
                      maxHeight:200),*/
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: msgCard(context, widget.messageItem, false),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(10.0)),
                    Container(
                        child: Image.asset(widget.messageItem.from.photoURL)),
                  ])),
        ),
      );

  static Card msgCard(BuildContext context, Message msg, bool isRight) => Card(
      color: !isRight ? Colors.grey.shade200 : Colors.lightGreen.shade300,
      child: Padding(
        padding: EdgeInsets.all(3),
        child: Column(children: [
          Text('${msg.epochToTimeString()}', style: TextStyle(fontSize: 11)),
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
      ));
}
