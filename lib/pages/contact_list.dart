import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/main.dart';
import '../models/chat.dart' show Chat;
import '../pages/texting.dart' show TextingPage;

class ContactList extends StatefulWidget {
  final bool Function(Chat) filter;
  final void Function(String) onMsgSent;
  ContactList({Key key, this.filter, this.onMsgSent}) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return _col(context, msgFactory.contacts.where(widget.filter).toList());
  }

  Widget _col(BuildContext context, List<Chat> contacts) {
    return Container(
        height: 80,
        color: Colors.yellow.shade100,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(children: [
            TextButton(
                onPressed: () => null,
                child: Text('<', style: TextStyle(color: Colors.black))),
            if (contacts.length == 0)
              Text('No Contact found.')
            else
              _expan(context, contacts),
            TextButton(
                onPressed: () => null,
                child: Text('>', style: TextStyle(color: Colors.black))),
          ]),
        ));
  }

  Expanded _expan(BuildContext context, List<Chat> contacts) {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: contacts.length,
          itemBuilder: (BuildContext _, int index) => TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TextingPage(
                      selChat: contacts[index], onMsgSent: widget.onMsgSent),
                ));
              },
              child: Column(children: [
                Text(contacts[index].caption,
                    style: TextStyle(color: Colors.grey.shade800)),
                CircleAvatar(
                    backgroundImage: AssetImage(contacts[index].photoURL)),
              ]))),
    );
  }
}
