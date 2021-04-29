// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// --

// -- model uses
import 'models/msg.dart';
import 'models/mock_repo.dart';
// --

// -- pages
import 'pages/create_msg.dart';
import 'pages/msg_list.dart';
// --
//

class BoardPage extends StatefulWidget {
  BoardPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BoardPageState();
}

class BoardPageState extends State<BoardPage> {
  List<Message> newMessages;
  List<Message> savedMessages;

  @override
  void initState() {
    super.initState();

    newMessages = [];
    savedMessages = [];
    loadMessages();
  }

  void loadMessages() {
    newMessages.addAll(mockNewMessages);
    savedMessages.addAll(mockSavedMessages);
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
          title: Text("<name_here>'s Message Board"),
          backgroundColor: Colors.grey,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              _buildCategoryTab("Inbox"),
              _buildCategoryTab("Saved"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MessagesList(title: "Inbox", inboxMsgs: newMessages),
            MessagesList(title: "Saved", inboxMsgs: savedMessages),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreateMessagePage(
                  buddys: mocklocalUsers,
                ),
              ),
            );
          },
          tooltip: 'Post a message.',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String title) {
    return Tab(
      child: Text(title),
    );
  }

  void ignore(Message inboxMsg) {
    setState(() {
      if (inboxMsg.isSaved) {
        savedMessages.remove(inboxMsg);
      } else {
        newMessages.remove(inboxMsg);
      }
    });
  }

  void save(Message inboxMsg) {
    setState(() {
      newMessages.remove(inboxMsg);
      savedMessages.add(inboxMsg.copyWith(
        saved: true,
      ));
    });
  }
}
