import 'package:flutter/material.dart';
import '../models/message.dart' show Message;

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
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(widget.messageItem.body.toString())),
          ),
        ),
      ),
    );
  }
}
