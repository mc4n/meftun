import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../models/chat.dart' show Chat;
import '../pages/texting.dart' show TextingPage;

class ContactList extends StatefulWidget {
  final List<Chat> contacts;
  final void Function(String) onMsgSent;
  ContactList({Key key, this.contacts, this.onMsgSent}) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return _col(context);
  }

  Widget _col(BuildContext context) {
    return Container(
        height: 80,
        color: Colors.yellow.shade100,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(children: [
            TextButton(
                onPressed: () => null,
                child: Text('<', style: TextStyle(color: Colors.black))),
            _expan(context),
            TextButton(
                onPressed: () => null,
                child: Text('>', style: TextStyle(color: Colors.black))),
          ]),
        ));
  }

  Expanded _expan(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: widget.contacts.length,
          itemBuilder: (BuildContext _, int index) => TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TextingPage(
                      selChat: widget.contacts[index],
                      onMsgSent: widget.onMsgSent),
                ));
              },
              child: Column(children: [
                Text(widget.contacts[index].caption,
                    style: TextStyle(color: Colors.grey.shade800)),
                CircleAvatar(
                    backgroundImage:
                        AssetImage(widget.contacts[index].photoURL)),
              ]))),
    );
  }
}
