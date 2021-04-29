// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/models/draft.dart';
import 'package:me_flutting/models/person.dart';
import 'package:me_flutting/pages/people_list.dart';
// --

// -- model uses
import 'models/msg.dart';
import 'models/mock_repo.dart';
import 'models/draft.dart';
// --

// -- pages
import 'pages/create_msg.dart';
import 'pages/inbox_msgs.dart';
import 'pages/saved_msgs.dart';
import 'pages/draft_list.dart';
// --
//

class BoardPage extends StatefulWidget {
  final Person userLoggedin;
  BoardPage({
    Key key,
    this.userLoggedin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BoardPageState(this.userLoggedin);
}

class BoardPageState extends State<BoardPage> {
  final Person userLoggedIn;
  List<Message> newMessages;
  List<Message> savedMessages;
  List<Draft> drafts;
  List<Person> contacts;

  BoardPageState(this.userLoggedIn);

  @override
  void initState() {
    super.initState();

    newMessages = [];
    savedMessages = [];
    drafts = [];
    contacts = [];

    newMessages.addAll(mockNewMessages);
    savedMessages.addAll(mockSavedMessages);
    contacts.addAll(mocklocalUsers);
    drafts.addAll(mockLocalDrafts);
  }

  static BoardPageState of(BuildContext context) {
    return context.findAncestorStateOfType<BoardPageState>();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${this.userLoggedIn.name}'s Message Board"),
          backgroundColor: Colors.grey,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              _buildCategoryTab("Inbox"),
              _buildCategoryTab("Saved"),
              _buildCategoryTab("Drafts"),
              _buildCategoryTab("People"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            InboxMessagesList(inboxMsgs: newMessages),
            SavedMessagesList(inboxMsgs: savedMessages),
            DraftList(drafts: drafts),
            PeopleList(buddies: contacts)
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
