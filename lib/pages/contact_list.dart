import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../models/chat.dart';

class ContactList extends StatelessWidget {
  final List<Chat> contacts;
  ContactList({Key key, this.contacts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _col();
  }

  Widget _col() {
    return Column(children: [
      Container(
          height: 84,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(children: [
              TextButton(onPressed: () => null, child: Text('<')),
              _expan(),
              TextButton(onPressed: () => null, child: Text('>')),
            ]),
          ))
    ]);
  }

  Expanded _expan() {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: contacts.length,
          itemBuilder: (BuildContext _, int index) => TextButton(
              onPressed: () => null,
              child: Column(children: [
                Text(contacts[index].caption),
                CircleAvatar(backgroundImage: AssetImage('avatar.png')),
              ]))),
    );
  }
}
