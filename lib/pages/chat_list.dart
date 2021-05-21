import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/pages/create_msg.dart';
import '../models/draft.dart';

class DraftList extends StatelessWidget {
  final List<Draft> drafts;

  DraftList({Key key, this.drafts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          child: Text("Drafts"),
          padding: EdgeInsets.only(top: 16.0),
        ),
        drafts.length > 0
            ? Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: drafts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TextButton(
                        onPressed: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CreateMessagePage(
                                      selectedLastMsg: drafts[index]),
                                ),
                              )
                            },
                        child: Text(
                            "${drafts[index].to} : ${drafts[index].body}"));
                  },
                ),
              )
            : Text("No draft was found."),
      ],
    );
  }
}

class ChatItem extends StatelessWidget {
  final Draft chatItem;

  const ChatItem({Key key, this.chatItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      //key: ValueKey(chatItem..),
      color: Colors.lightGreen.shade100,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Padding(
        child: Column(
          children: <Widget>[
            Text("message body here..."),
          ],
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }
}
