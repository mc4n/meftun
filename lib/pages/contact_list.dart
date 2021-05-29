import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../models/chat.dart';
import '../pages/texting.dart';

class ContactList extends StatelessWidget {
  final List<Chat> contacts;
  final void Function(String) onMsgSent;
  ContactList({Key key, this.contacts, this.onMsgSent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _col(context);
  }

  Widget _col(BuildContext context) {
    return Container(
        height: 84,
        color: Colors.yellow.shade100,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(children: [
            TextButton(onPressed: () => null, child: Text('<')),
            _expan(context),
            TextButton(onPressed: () => null, child: Text('>')),
          ]),
        ));
  }

  Expanded _expan(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: contacts.length,
          itemBuilder: (BuildContext _, int index) => TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TextingPage(
                      selChat: contacts[index], onMsgSent: onMsgSent),
                ));
              },
              child: Column(children: [
                Text(contacts[index].caption),
                CircleAvatar(
                    backgroundImage: AssetImage(contacts[index].photoURL)),
              ]))),
    );
  }
}
