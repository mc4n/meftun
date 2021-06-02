import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/main.dart';
import 'package:me_flutting/models/directchat.dart';
import '../widgets/chat_list.dart' show ChatList;
import '../widgets/contact_list.dart' show ContactList;

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
  void Function(void Function(DirectChat dcAdded, [String errMsg]) callBack)
      addContactClaimed;

  MainPageState() {
    onMsgSent = (_) {
      setState(() => null);
    };
    addContactClaimed = (callback) {
      final tsea = tedit.text.trim();
      if (tsea != '' && !chatFactory.existsPerson(tsea))
        setState(() => callback(chatFactory.addPerson(tsea)));
      else
        callback(null,
            'person $tsea already exists or an invalid username supplied.');
    };
  }

  final TextEditingController tedit = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var ftext = tedit.text.trim();

    return _tabCon(
        () => [
              Tab(
                child: Text('Chats'),
              ),
            ],
        () => [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ContactList((_) => _.fContactsFilter(isSearching, ftext),
                        onMsgSent, addContactClaimed),
                    Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                    ChatList(
                      (_) => _.fChatsFilter(isSearching, ftext),
                      onMsgSent,
                    ),
                  ],
                ),
              ),
            ]);
  }

  Widget _tabCon(List<Tab> Function() head, List<Widget> Function() tail) {
    var _r = tail();
    return DefaultTabController(
      length: _r.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade700,
          leading: TextButton(
              onPressed: () {
                isSearching = !isSearching;
                onMsgSent(tedit.text = '');
              },
              child: !isSearching
                  ? Icon(Icons.search, color: Colors.white)
                  : Icon(Icons.cancel, color: Colors.white)),
          title: isSearching
              ? TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search in chats',
                  ),
                  onSubmitted: onMsgSent,
                  controller: tedit,
                  style: TextStyle(fontSize: 17, color: Colors.white))
              : Text('Meflutin',
                  style: TextStyle(fontSize: 22, color: Colors.white)),
          bottom: TabBar(
              labelStyle: TextStyle(fontSize: 19),
              isScrollable: true,
              tabs: head()),
        ),
        body: TabBarView(
          children: _r,
        ),
      ),
    );
  }
}
