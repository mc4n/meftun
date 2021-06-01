import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widget/chat_list.dart';
import '../widget/contact_list.dart';
import '../main.dart';

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
                    ContactList(
                      (_) => msgFactory.fContactsFilter(_, isSearching, ftext),
                      onMsgSent,
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                    ChatList(
                      (_) => msgFactory.fChatsFilter(_, isSearching, ftext),
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
