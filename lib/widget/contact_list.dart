import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/helpers/msghelper.dart' show MessageFactory;
import '../main.dart' show chatFactory;
import '../models/chat.dart' show Chat;
import '../pages/texting.dart' show TextingPage;

class ContactList extends StatefulWidget {
  final bool Function(MessageFactory) filter;
  final void Function(String) onMsgSent;

  const ContactList(this.filter, this.onMsgSent, [Key key]) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    var contacts = chatFactory.msgFactories
        .where(widget.filter)
        .map((m) => m.chatItem)
        .toList();

    return Container(
        height: 80,
        color: Colors.yellow.shade200,
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              contacts.length > 0
                  ? TextButton(
                      onPressed: () => null,
                      child: Icon(Icons.navigate_before_rounded,
                          color: Colors.black, size: 30),
                    )
                  : Row(),
              contacts.length > 0
                  ? _expan(context, contacts)
                  : TextButton(
                      onPressed: () => null,
                      child: Row(children: [
                        Text(' New contact '),
                        Icon(Icons.person_add_alt, size: 26),
                      ]),
                    ),
              contacts.length > 0
                  ? TextButton(
                      onPressed: () => null,
                      child: Icon(Icons.navigate_next_rounded,
                          color: Colors.black, size: 30))
                  : Row(),
            ])));
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
                          chatFactory.factoryByChat(contacts[index]),
                          widget.onMsgSent,
                        )));
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
