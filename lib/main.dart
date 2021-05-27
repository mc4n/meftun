import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/pages/chat_list.dart';
import 'helpers/msghelper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mefluttin',
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _tabCon(
        () => [
              Tab(
                child: Text('Chats'),
              ),
            ],
        () => [ChatList(chats: contacts)]);
  }

  Widget _tabCon(List<Tab> Function() head, List<Widget> Function() tail) {
    var _r = tail();
    return DefaultTabController(
      length: _r.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.shade300,
          bottom: TabBar(
              labelStyle: TextStyle(fontSize: 18),
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
