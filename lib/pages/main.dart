import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../main.dart';
import '../widgets/chat_list.dart' show ChatList;
import '../widgets/contact_list.dart' show ContactList;
import '../pages/profile.dart' show ProfilePage;

class MainPage extends StatefulWidget {
  MainPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  static Future<void> setMainPageState(BuildContext con) async =>
      con.findAncestorStateOfType<MainPageState>().setState(() => null);

  bool isSearching = false;
  final TextEditingController tedit = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            ContactList(tedit.text.trim(), isSearching),
            Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
            ChatList(tedit.text.trim(), isSearching),
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
                    setState(() => null);
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
          onSubmitted: (_) => setState(() => null),
          controller: tedit,
          style: TextStyle(fontSize: 17, color: Colors.white))
      : Text(APP_TITLE, style: TextStyle(fontSize: 22, color: Colors.white));
}
