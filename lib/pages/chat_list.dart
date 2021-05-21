import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/models/message.dart';
import 'package:me_flutting/pages/create_msg.dart';
import '../models/draft.dart';

class DraftList extends StatelessWidget {
  final List<Draft> drafts;

  const DraftList({Key key, this.drafts}) : super(key: key);

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
                                      // buddys: ,
                                      // draft : Draft();
                                      ),
                                ),
                              )
                            },
                        child: Text(
                            "${drafts[index].to} --> ${drafts[index].body}"));
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
            _itemHeader(context, chatItem),
            Text("message body here..."),
            _itemFooter(context, chatItem)
          ],
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  Widget _itemFooter(BuildContext context, Draft lastMsg) {
    if (lastMsg is Message) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Chip(
          label: Text("it's a message."),
        ),
        ElevatedButton(
            onPressed: () {
              //BoardPageState.of(context).unarchieveChat(chat);
            },
            child: Text("Unurchieve"))
      ]);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ElevatedButton(
              child: Text("Archieve"),
              onPressed: () {
                //BoardPageState.of(context).archieveChat(chat);
              }),
          TextButton(
            child: Text("Delete"),
            onPressed: () {
              //BoardPageState.of(context).deleteChat(chatItem);
            },
          )
        ],
      );
    }
  }

  Widget _itemHeader(BuildContext context, Draft lastMsg) {
    ImageProvider<Object> iPv = AssetImage("avatar.png");

    // if (chatItem.from.photoURL.startsWith("http")) {
    //   iPv = NetworkImage(
    //     chatItem.from.photoURL,
    //   );
    // } else if (chatItem.from.photoURL != "") {
    //   iPv = AssetImage("${chatItem.from.photoURL}.jpg");
    // }

    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: iPv,
        ),
        Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateMessagePage(draft: null)),
                    );
                  },
                  child: Text("x says: "))),
        )
      ],
    );
  }
}
