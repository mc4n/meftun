import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../helpers/msghelper.dart' show MessageFactory;

class ProfilePage extends StatelessWidget {
  final MessageFactory messageFactory;

  const ProfilePage(this.messageFactory, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade800,
          leading: BackButton(),
        ),
        body: Column(
          children: [
            Text(messageFactory.chatItem.caption),
            CircleAvatar(
                backgroundImage: AssetImage(messageFactory.chatItem.photoURL))
          ],
        ));
  }
}
