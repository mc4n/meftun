import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'msg.dart';
import 'person.dart';
import 'mock_repo.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Panel',
      // home: RequestMessagePage( // uncomment this and comment 'home' below to change the visible page for now
      //   buddys: mockPersons,
      // ),
      home: MessagesPage(),
    );
  }
}

class MessagesPage extends StatefulWidget {
  MessagesPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
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

  static MessagesPageState of(BuildContext context) {
    return context.findAncestorStateOfType<MessagesPageState>();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("<name_here>'s Message Board"),
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

class MessagesList extends StatelessWidget {
  final String title;
  final List<Message> inboxMsgs;

  const MessagesList({Key key, this.title, this.inboxMsgs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          child: Text(title),
          padding: EdgeInsets.only(top: 16.0),
        ),
        inboxMsgs.length > 0
            ? Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: inboxMsgs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MessageCardItem(inboxMsg: inboxMsgs[index]);
                  },
                ),
              )
            : Text("horaay, we have no new message here!"),
      ],
    );
  }
}

class MessageCardItem extends StatelessWidget {
  final Message inboxMsg;

  const MessageCardItem({Key key, this.inboxMsg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(inboxMsg.uuid),
      color: Colors.lightGreen.shade100,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Padding(
        child: Column(
          children: <Widget>[
            _itemHeader(inboxMsg),
            Text(this.inboxMsg.body),
            _itemFooter(context, inboxMsg)
          ],
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  Widget _itemFooter(BuildContext context, Message inboxMsg) {
    if (inboxMsg.isSaved) {
      return Container(
        margin: EdgeInsets.only(top: 8.0),
        alignment: Alignment.centerRight,
        child: Chip(
          label: Text("Saved."),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            child: Text("Save"),
            onPressed: () {
              MessagesPageState.of(context).save(inboxMsg);
            },
          ),
          TextButton(
            child: Text("Ignore"),
            onPressed: () {
              MessagesPageState.of(context).ignore(inboxMsg);
            },
          )
        ],
      );
    }

    return Container();
  }

  Widget _itemHeader(Message inboxMsg) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(
            inboxMsg.from.photoURL,
          ),
        ),
        Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("${inboxMsg.from.name} says: ")),
        )
      ],
    );
  }
}

/////// --------

class CreateMessagePage extends StatefulWidget {
  final List<Person> buddys;

  CreateMessagePage({Key key, this.buddys}) : super(key: key);

  @override
  CreateMessagePageState createState() {
    return new CreateMessagePageState();
  }
}

class CreateMessagePageState extends State<CreateMessagePage> {
  final _formKey = GlobalKey<FormState>();
  Person _selectedPerson;

  static CreateMessagePageState of(BuildContext context) {
    return context.findAncestorStateOfType<
        CreateMessagePageState>(); //(TypeMatcher<CreateMessagePageState>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post a message."),
        leading: CloseButton(),
        actions: <Widget>[
          Builder(
            builder: (context) => TextButton(
              child: Text("POST"),
              style: TextButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                CreateMessagePageState.of(context).save();
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Receipt:"),
              DropdownButtonFormField<Person>(
                hint: Text("Select a buddy"),
                value: _selectedPerson,
                onChanged: (buddy) {
                  setState(() {
                    _selectedPerson = buddy;
                  });
                },
                items: widget.buddys
                    .map(
                      (f) => DropdownMenuItem<Person>(
                        value: f,
                        child: Text(f.name),
                      ),
                    )
                    .toList(),
                validator: (buddy) {
                  if (buddy == null) {
                    return "You must select a buddy to post a message to.";
                  }
                  return null;
                },
              ),
              Container(
                height: 16.0,
              ),
              Text("Message body:"),
              TextFormField(
                maxLines: 20,
                inputFormatters: [LengthLimitingTextInputFormatter(280)],
                validator: (value) {
                  if (value.isEmpty) {
                    return "You must enter the message.";
                  }
                  return null;
                },
              ),
              Container(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void save() {
    if (_formKey.currentState.validate()) {
      // store the inbox_msg request on firebase
      Navigator.pop(context);
    }
  }
}
