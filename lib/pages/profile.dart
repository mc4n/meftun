import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/chat.dart' show Chat;
import '../main.dart';
import 'usageinfo.dart' show UsageInfoPage;

class ProfilePage extends StatelessWidget {
  final Chat chatItem;

  const ProfilePage(this.chatItem, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text('Profile/${chatItem.caption}'),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 180,
                    height: 290,
                    child: Image.asset(chatItem.photoURL)),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(chatItem.name ?? chatItem.caption,
                      style: TextStyle(fontSize: 25)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text(' ${chatItem.type == 'G' ? '(Group)' : ''} ',
                      style: TextStyle(fontSize: 15)),
                ])
              ],
            )),
        persistentFooterButtons: chatItem == meSession
            ? [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return Scaffold(
                          appBar: AppBar(
                            leading: CloseButton(),
                            title: Text('Usage Data'),
                          ),
                          body: UsageInfoPage(),
                        );
                      }));
                    },
                    child: Text('Usage Statistics')),
                Text('Settings')
              ]
            : [Row()]);
  }
}
