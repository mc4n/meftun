import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meftun/main.dart';
import 'package:meftun/types/botchat.dart';
import 'package:meftun/views/pages/texting.dart';
import 'package:meftun/views/widgets/chat_list.dart' show ChatList;
import 'package:meftun/views/widgets/contact_list.dart' show ContactList;
import 'package:meftun/views/pages/profile.dart' show ProfilePage;
import 'about.dart' show aboutPage;

class MainPage extends StatefulWidget {
  final String title;
  const MainPage(this.title);
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
                        builder: (_) => ProfilePage(storage.adminId, true)));
                  },
                  child:
                      CircleAvatar(backgroundImage: AssetImage('avatar.png')),
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
          persistentFooterButtons: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TextingPage(
                        BotChat(storage.botmasterId, null, '[BotMaster]'),
                        () async => this.setState(() => null))));
              },
              child: Text('> Console'),
            ),
            aboutPage(context)
          ],
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
      : Text(widget.title, style: TextStyle(fontSize: 22, color: Colors.white));
}
