import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:meftun/controllers/chattable.dart';
import 'package:meftun/core/table_cursor.dart';
import 'package:meftun/models/chatmodel.dart';
import 'package:meftun/types/chat.dart' show Chat;
import 'package:meftun/types/directchat.dart' show DirectChat;
import 'package:meftun/main.dart';
import 'package:meftun/views/pages/main.dart';
import 'package:meftun/views/pages/texting.dart' show TextingPage;

const RANGE = 6;

class ContactList extends StatefulWidget {
  final String tsea;
  final bool isSearching;
  const ContactList(this.tsea, this.isSearching);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final TableCursor<ChatModel, String> cursor =
      storage.chatTable.createCursor(RANGE, orderBy: 'display_name');

  Future<void> addContactClaimed(
      void Function(DirectChat dcAdded, [String errMsg]) callback) async {
    final tsea = widget.tsea;
    if (tsea != '') {
      final cTAdd = DirectChat(Chat.newId(), tsea);
      await storage.chatTable.insertChat(cTAdd);
      callback(cTAdd);
    } else
      callback(null, 'displayName cannot be empty ');
  }

  @override
  Widget build(BuildContext context) {
    cursor.filter =
        widget.isSearching ? MapEntry('**display_name', widget.tsea) : null;
    return Container(
        height: 80,
        color: Colors.yellow.shade200,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: FutureBuilder<List<Chat>>(future: () async {
            final re = await cursor?.current;
            return re.map((i) => ChatTable.asChat(i)).toList();
          }(), builder: (_, snap) {
            if (snap.hasData && snap.data.length > 0)
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          if (await cursor.moveBack()) setState(() {});
                        },
                        child: Icon(Icons.navigate_before_rounded)),
                    _expan(snap.data),
                    TextButton(
                        onPressed: () async {
                          if (await cursor.moveNext()) setState(() {});
                        },
                        child: Icon(
                          Icons.navigate_next_rounded,
                        ))
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
                    backgroundImage:
                        AssetImage(contacts[index].defaultPhotoURL)),
              ]))),
    );
  }
}
