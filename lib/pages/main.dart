import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../main.dart';
import '../models/chat.dart' show Chat;
import '../models/directchat.dart' show DirectChat;
import '../widgets/chat_list.dart' show ChatList;
import '../widgets/contact_list.dart' show ContactList;
import '../pages/profile.dart' show ProfilePage;
import '../helpers/table_helper.dart';

class MainPage extends StatefulWidget {
  MainPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  bool isSearching = false;
  void Function(String) onMsgSent;
  Future<void> Function(
          void Function(DirectChat dcAdded, [String errMsg]) callBack)
      addContactClaimed;

  MainPageState() {
    onMsgSent = (_) {
      setState(() => null);
    };
    addContactClaimed = (callback) async {
      final tsea = tedit.text.trim();
      if (tsea != '') {
        final cTAdd = DirectChat(Chat.newId(), tsea, 'A new chat item.');
        await myContext.tableEntityOf<ChatTable>().insertChat(cTAdd);
        setState(() => callback(cTAdd));
      } else
        callback(null, 'username cannot be empty ');
    };
  }

  final TextEditingController tedit = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var ftext = tedit.text.trim();

    return _tabCon([
      Tab(
        child: Text('Chats'),
      ),
    ], [
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ContactList((_) {
              return _ != meSession &&
                  (!isSearching ||
                      ftext == '' ||
                      isSearching && ftext != '' && _.caption.contains(ftext));
            }, onMsgSent, addContactClaimed),
            Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
            ChatList(
              (_) {
                return _ != meSession &&
                    (!isSearching ||
                        ftext == '' ||
                        isSearching &&
                            ftext != '' &&
                            _.caption.contains(ftext));
              },
              onMsgSent,
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _tabCon(List<Tab> head, List<Widget> tail) => DefaultTabController(
        length: tail.length,
        child: Scaffold(
          appBar: AppBar(
              leading: TextButton(
                  onPressed: () {
                    isSearching = !isSearching;
                    onMsgSent(tedit.text = '');
                  },
                  child: !isSearching
                      ? Icon(Icons.search, color: Colors.white)
                      : Icon(Icons.cancel, color: Colors.white)),
              title: Row(children: [
                Expanded(child: _tit),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ProfilePage(meSession)));
                  },
                  child: CircleAvatar(
                      backgroundImage: AssetImage(meSession.photoURL)),
                )
              ]),
              bottom: TabBar(
                labelStyle: TextStyle(fontSize: 19),
                isScrollable: true,
                tabs: head,
              )),
          body: TabBarView(
            children: tail,
          ),
        ),
      );

  Widget get _tit => isSearching
      ? TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Search in chats',
          ),
          onSubmitted: onMsgSent,
          controller: tedit,
          style: TextStyle(fontSize: 17, color: Colors.white))
      : Text('Meflutin', style: TextStyle(fontSize: 22, color: Colors.white));
}
