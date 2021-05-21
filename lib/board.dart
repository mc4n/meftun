import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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

  @override
  void initState() {
    super.initState();
  }

  static BoardPageState of(BuildContext context) {
    return context.findAncestorStateOfType<BoardPageState>();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          //title: Text("${this.userLoggedIn.name}'s Message Board"),
          backgroundColor: Colors.grey,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              _buildCategoryTab("Chats"),
              _buildCategoryTab("People"),
            ],
          ),
        ),
        body: TabBarView(
          children: [DraftList(), DraftList()],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (context) => CreateMessagePage(
        //           draft: Draft("", null, userLoggedIn),
        //         ),
        //       ),
        //     );
        //   },
        //   tooltip: 'start a chat.',
        //   child: Icon(Icons.add),
        // ),
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
