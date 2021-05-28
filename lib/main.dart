import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/pages/chat_list.dart';
import 'package:me_flutting/pages/contact_list.dart';
import 'helpers/msghelper.dart';
import 'models/directchat.dart';

MessageFactory msgFactory =
    MessageFactory(DirectChat('mcan', 'Mustafa Can', 'pac.jpg'));

void main() {
  msgFactory.addPerson('2pac');
  msgFactory.addPerson('bigg');
  msgFactory.addPerson('fooo');
  msgFactory.addPerson('ali');
  msgFactory.addPerson('veli');
  msgFactory.addPerson('ayse');
  msgFactory.addPerson('fatma');
  msgFactory.addPerson('obama');

  msgFactory.sendMessage(msgFactory.contacts.first, "fooozoaoa");
  msgFactory.receiveMessage(msgFactory.contacts.last, "long live");
  msgFactory.sendMessage(msgFactory.contacts.last, "e qpwe oqwe q");
  msgFactory.sendMessage(msgFactory.contacts.first, ":D :D");
  msgFactory.receiveMessage(msgFactory.contacts.first, "whut homie?");

  runApp(MyApp());
}

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
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  void Function(String) onMsgSent;
  MainPageState() {
    onMsgSent = (_) {
      setState(() => null);
    };
  }

  @override
  Widget build(BuildContext context) {
    return _tabCon(
        () => [
              Tab(
                child: Text('Chats'),
              ),
            ],
        () => [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ContactList(
                      contacts: msgFactory.contacts.toList(),
                      onMsgSent: onMsgSent,
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                    ChatList(
                      chats: msgFactory.contacts.toList(),
                      onMsgSent: onMsgSent,
                    ),
                  ],
                ),
              ),
            ]);
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
