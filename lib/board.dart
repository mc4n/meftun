import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'models/draft.dart';
import 'models/message.dart';
import 'models/person.dart';

import 'pages/chat_list.dart';

class BoardPage extends StatefulWidget {
  final Person userLoggedin = Person("mcan", "Mustafa Can");
  BoardPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BoardPageState(this.userLoggedin);
}

class BoardPageState extends State<BoardPage> {
  final Person userLoggedIn;

  BoardPageState(this.userLoggedIn);

  final List<Draft> allDrafts = [];

  final List<Person> people = [
    Person('2pac'),
    Person('ali'),
    Person('veli'),
    Person('deli'),
    Person('peri')
  ];

  @override
  void initState() {
    allDrafts.addAll([
      Draft('whatsup bro!', people[0], userLoggedIn, people[0]),
      Draft('hehehe', people[1], userLoggedIn, people[1]),
      Draft('ada daps dqpweq wdw lpqwld', people[2], userLoggedIn, people[2]),
      Draft('ben deli degilim nokta.', people[3], userLoggedIn, people[3]),
      Draft('periphery', people[4], userLoggedIn, people[4])
    ]);
    super.initState();
  }

  static BoardPageState of(BuildContext context) {
    return context.findAncestorStateOfType<BoardPageState>();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              _buildCategoryTab("Chats"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DraftList(
              drafts: allDrafts,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String title) {
    return Tab(
      child: Text(title),
    );
  }

  void deleteChat(Message _lastMsg) {
    setState(() {
      //
    });
  }

  void archieveChat(Message _lastMsg) {
    setState(() {
      //
    });
  }

  void unarchieveChat(Message _lastMsg) {
    setState(() {
      //
    });
  }
}
