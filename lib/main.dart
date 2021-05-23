import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'models/draft.dart';
import 'models/person.dart';
import 'pages/chat_list.dart';

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

class MainPage extends StatefulWidget {
  MainPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainPageState(me);
}

class MainPageState extends State<MainPage> {
  final Person userLoggedIn;

  MainPageState(this.userLoggedIn);

  final List<Draft> allDrafts = [];

  @override
  void initState() {
    allDrafts.addAll(contacts.map((e) => e.createDraft(userLoggedIn)));
    var randomWords = [
      'lorem',
      'lorem ipsum :D',
      'iyidir',
      'come on!',
      'the world is yours!',
      'moooooo',
      'i love the way you do it',
      'what do you do?'
    ];
    var rnd = Random();
    allDrafts.forEach((element) {
      element.setBody = randomWords[rnd.nextInt(randomWords.length)];
    });
    super.initState();
  }

  static MainPageState of(BuildContext context) {
    return context.findAncestorStateOfType<MainPageState>();
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
              Tab(
                child: Text('Chats'),
              ),
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
}
