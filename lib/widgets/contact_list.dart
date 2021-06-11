import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../models/chat.dart' show Chat;
import '../models/directchat.dart' show DirectChat;
import '../pages/texting.dart' show TextingPage;
import '../main.dart';
import '../helpers/table_helper.dart';

class ContactList extends StatefulWidget {
  final bool Function(ChatModel) filter;
  final void Function(String) onMsgSent;
  final Future<void> Function(
          void Function(DirectChat dcAdded, [String errMsg]) callBack)
      addContactClaimed;
  const ContactList(this.filter, this.onMsgSent, this.addContactClaimed,
      [Key key])
      : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        color: Colors.yellow.shade200,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: FutureBuilder<List<ChatModel>>(
              future: myContext
                  .tableEntityOf<ChatTable>()
                  .selectWhere(widget.filter),
              builder: (BuildContext bc, AsyncSnapshot<List<ChatModel>> snap) {
                if (snap.hasData && snap.data.length > 0)
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.navigate_before_rounded),
                        _expan(snap.data.map((m) => m.toChat()).toList()),
                        Icon(
                          Icons.navigate_next_rounded,
                        )
                      ]);
                else
                  return TextButton(
                      onPressed: () async {
                        await widget.addContactClaimed((_, [err]) {
                          if (err != null) print(err);
                        });
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(' New contact '),
                            Icon(Icons.person_add_alt, size: 26),
                          ]));
              }),
        ));
  }

  Expanded _expan(List<Chat> contacts) {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: contacts.length,
          itemBuilder: (BuildContext _, int index) => TextButton(
              onPressed: () async => TextingPage.letTheGameBegin(
                  context, contacts[index], widget.onMsgSent),
              child: Column(children: [
                Text(contacts[index].caption,
                    style: TextStyle(color: Colors.grey.shade800)),
                CircleAvatar(
                    backgroundImage: AssetImage(contacts[index].photoURL)),
              ]))),
    );
  }
}
