import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/pages/chat_list.dart';
import 'package:me_flutting/pages/contact_list.dart';
import 'helpers/msghelper.dart';
import 'models/chat.dart';
import 'models/directchat.dart';

MessageFactory msgFactory =
    MessageFactory(DirectChat('mcan', 'Mustafa Can', 'pac.jpg'));

void main() {
  var me = msgFactory.owner;
  var p1 = msgFactory.addPerson('2pac');
  var p2 = msgFactory.addPerson('bigg');
  var g1 = msgFactory.addGroup('THUGS');
  msgFactory.addPerson('ali');
  msgFactory.addPerson('veli');
  msgFactory.addPerson('ayse');
  msgFactory.addPerson('fatma');
  msgFactory.addGroup('MALLAR');
  var g2 = msgFactory.addGroup('Mentals');

  msgFactory.sendMessage(p1, 'word da f up!');
  msgFactory.receiveMessage(p2, me, 'hi');
  msgFactory.sendMessage(g1, 'morning!');
  msgFactory.receiveMessage(p1, g1, 'thug life bay behh!');
  msgFactory.receiveMessage(p1, g2, '?');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mefluttin',
      home: MainPage(),
    );
  }
}

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

  MainPageState() {
    onMsgSent = (_) {
      setState(() => null);
    };
  }
  final TextEditingController tedit = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool fNotContact(Chat c) => msgFactory.getLastMessage(c)?.body != null;

    var ftext = tedit.text.trim();

    bool fContactsFilter(Chat c) =>
        !fNotContact(c) &&
        (!isSearching ||
            ftext == '' ||
            isSearching && ftext != '' && c.caption.contains(ftext));

    bool fChatsFilter(Chat c) =>
        fNotContact(c) &&
        (!isSearching ||
            ftext == '' ||
            isSearching && ftext != '' && c.caption.contains(ftext));

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
                    ContactList(
                      onMsgSent: onMsgSent,
                      filter: fContactsFilter,
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                    ChatList(
                      onMsgSent: onMsgSent,
                      filter: fChatsFilter,
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
                  style: TextStyle(fontSize: 22, color: Colors.white))
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
