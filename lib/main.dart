import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/pages/chat_list.dart';
import 'models/person.dart';

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

  @override
  void initState() {
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
          children: [ChatList(chats: contacts)],
        ),
      ),
    );
  }
}
