import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../models/chat.dart' show Chat;
import '../models/directchat.dart' show DirectChat;
import '../pages/texting.dart' show TextingPage;
import '../main.dart';
import '../helpers/table_helper.dart';

class ContactList extends StatefulWidget {
  final bool Function(Chat) filter;
  final void Function(String) onMsgSent;
  final Future<void> Function(
          void Function(DirectChat dcAdded, [String errMsg]) callBack)
      addContactClaimed;

  const ContactList(this.filter, this.onMsgSent, this.addContactClaimed,
      [Key key])
      : super(key: key);

  @override
  _ContactListState createState() => _ContactListState([]);
}

class _ContactListState extends State<ContactList> {
  //final ScrollController sc = ScrollController();

  final List<Chat> contacts;
  _ContactListState(this.contacts);

  @override
  void initState() {
    lsInit();
    super.initState();
  }

  Future<void> lsInit() async {
    final ls = await myContext.tableEntityOf<ChatTable>().select();
    setState(() {
      contacts.addAll(ls.map((i) => i.toChat()).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        color: Colors.yellow.shade200,
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              contacts.length > 0
                  ? /*TextButton(
                      onPressed: () {
                        if (sc.hasClients) sc.jumpTo(sc.position.extentInside);
                      },
                      child: */
                  Icon(
                      Icons.navigate_before_rounded,
                      // color: Colors.black, size: 30),
                    )
                  : Row(),
              contacts.length > 0
                  ? _expan()
                  : TextButton(
                      onPressed: () async {
                        await widget.addContactClaimed((_, [err]) {
                          if (err != null) print(err);
                        });
                      },
                      child: Row(children: [
                        Text(' New contact '),
                        Icon(Icons.person_add_alt, size: 26),
                      ]),
                    ),
              contacts.length > 0
                  ? /*TextButton(
                      onPressed: () {
                        if (sc.hasClients) sc.jumpTo(sc.position.extentAfter);
                      },
                      child:*/
                  Icon(
                      Icons.navigate_next_rounded,
                      // color: Colors.black, size: 30)
                    )
                  : Row(),
            ])));
  }

  Expanded _expan() {
    return Expanded(
      child: ListView.builder(
          //controller: sc,
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
