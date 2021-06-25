import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../types/chat.dart' show Chat;
import '../pages/texting.dart' show TextingPage;
import '../types/directchat.dart' show DirectChat;
import '../main.dart';
import '../pages/main.dart';

class ContactList extends StatefulWidget {
  final String tsea;
  final bool isSearching;
  const ContactList(this.tsea, this.isSearching, [Key key]) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  Future<void> Function(
          void Function(DirectChat dcAdded, [String errMsg]) callBack)
      addContactClaimed;

  _ContactListState() {
    addContactClaimed = (callback) async {
      final tsea = widget.tsea;
      if (tsea != '') {
        final cTAdd = DirectChat(Chat.newId(), tsea, name: 'A new chat item.');
        await chatTable.insertChat(cTAdd);
        callback(cTAdd);
      } else
        callback(null, 'username cannot be empty ');
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        color: Colors.yellow.shade200,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: FutureBuilder<List<Chat>>(
              future: widget.isSearching
                  ? chatTable.filterChats(widget.tsea)
                  : chatTable.chats(),
              builder: (BuildContext bc, AsyncSnapshot<List<Chat>> snap) {
                if (snap.hasData && snap.data.length > 0)
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.navigate_before_rounded),
                        _expan(snap.data),
                        Icon(
                          Icons.navigate_next_rounded,
                        )
                      ]);
                else
                  return TextButton(
                      onPressed: () async {
                        await addContactClaimed((_, [err]) {
                          if (err != null)
                            print(err);
                          else
                            MainPageState.setMainPageState(context);
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
                  context,
                  contacts[index],
                  () => MainPageState.setMainPageState(context)),
              child: Column(children: [
                Text(contacts[index].caption,
                    style: TextStyle(color: Colors.grey.shade800)),
                CircleAvatar(
                    backgroundImage: AssetImage(contacts[index].photoURL)),
              ]))),
    );
  }
}
