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
          //child: Text("Chats"),
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
                                  builder: (context) => CreateMessagePage(),
                                ),
                              )
                            },
                        child: Text(
                            "${drafts[index].chatGroup?.id} : ${drafts[index].body}"));
                  },
                ),
              )
            : Text("No chat."),
      ],
    );
  }
}
